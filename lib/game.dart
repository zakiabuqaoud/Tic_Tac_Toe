import 'package:flutter/material.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  static const playerX = "X";
  static const playerY = "Y";

  List<String> occupied = ["", "", "", "", "", "", "", "", ""]; //9 item;
  late String currentPlayer;
  late bool endGame;

  @override
  void initState() {
    currentPlayer = "X";
    endGame = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
            Colors.teal,
            Colors.pink,
            Colors.teal,
          ])),
        ),
        title: const Text("Tic Tac Toe Game", style: TextStyle(color: Colors.white),),
      ),
      body: Container(
        color: const Color.fromRGBO(255, 254, 229, 1),
        child: Center(
          child: Column(
            children: [getHeaderText(), getGameArea(context), restartGame()],
          ),
        ),
      ),
    );
  }

  Widget getHeaderText() {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Text(
          "$currentPlayer turn",
          style: TextStyle(
              color: currentPlayer == "X" ? Colors.pink : Colors.teal,
              fontSize: 40),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget getGameArea(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.height / 2,
      height: MediaQuery.of(context).size.height / 2,
      margin: const EdgeInsets.all(8),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: MediaQuery.of(context).size.height / 5,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
          ),
          itemCount: 9,
          itemBuilder: (context, index) => getBox(index)),
    );
  }

  Widget getBox(index) {
    return InkWell(
      onTap: () {
        if (endGame || occupied[index].isNotEmpty) {
          // return if game already ended or box already clicked
          return;
        }
        setState(() {
          occupied[index] = currentPlayer;
          changeTurn();
          checkForWinner();
          checkForDraw();
        });
      },
      child: Container(
        color: occupied[index].isEmpty
            ? Colors.grey
            : occupied[index] == "X"
                ? Colors.pink
                : Colors.teal,
        child: Center(
            child: Text(
          occupied[index],
          style: const TextStyle(fontSize: 50, color: Colors.white),
        )),
      ),
    );
  }

  changeTurn() {
    if (currentPlayer == "X") {
      setState(() {
        currentPlayer = "Y";
      });
    } else {
      setState(() {
        currentPlayer = "X";
      });
    }
  }

  checkForWinner() {
    List<List<int>> winningList = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6]
    ];
    for (var winningPos in winningList) {
      String position0 = occupied[winningPos[0]];
      String position1 = occupied[winningPos[1]];
      String position2 = occupied[winningPos[2]];

      if (position0.isNotEmpty) {
        if (position0 == position1 && position0 == position2) {
          showGameOverMessage("Player $position0 own", Colors.green);
          setState(() {
            endGame = true;
          });
        }
      }
    }
  }

  showGameOverMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: color,
        content: Text(
          "Game Over \n $message",
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20),
        )));
  }

  Widget restartGame() {
    return ElevatedButton(
        onPressed: () {
          setState(() {
            endGame = false;
            occupied = ["", "", "", "", "", "", "", "", ""]; //9 item;
            currentPlayer = "X";
          });
        },
        style: const ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Colors.pink),) ,
        child: const Text(
          "Restart Game",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ));
  }

  checkForDraw() {
    bool draw = true;

    if (endGame) {
      return;
    }

    for (var occupiedPlayer in occupied) {
      if (occupiedPlayer.isEmpty) {
        draw = false;
      }
    }

    if (draw) {
      setState(() {
        endGame = true;
      });
      showGameOverMessage("Without Owner", Colors.deepOrange);
    }
  }
}
