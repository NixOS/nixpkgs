/* This script file handles the game logic */
var maxColumn = 10;
var maxRow = 15;
var maxIndex = maxColumn * maxRow;
var board = new Array(maxIndex);
var component;

//Index function used instead of a 2D array
function index(column, row) {
    return column + (row * maxColumn);
}

function startNewGame() {
    //Calculate board size
    maxColumn = Math.floor(gameCanvas.width / gameCanvas.blockSize);
    maxRow = Math.floor(gameCanvas.height / gameCanvas.blockSize);
    maxIndex = maxRow * maxColumn;

    //Close dialogs
    dialog.hide();

    //Initialize Board
    board = new Array(maxIndex);
    gameCanvas.score = 0;
    for (var column = 0; column < maxColumn; column++) {
        for (var row = 0; row < maxRow; row++) {
            board[index(column, row)] = null;
            createBlock(column, row);
        }
    }
}

function createBlock(column, row) {
    if (component == null)
        component = Qt.createComponent("Block.qml");

    // Note that if Block.qml was not a local file, component.status would be
    // Loading and we should wait for the component's statusChanged() signal to
    // know when the file is downloaded and ready before calling createObject().
    if (component.status == Component.Ready) {
        var dynamicObject = component.createObject(gameCanvas);
        if (dynamicObject == null) {
            console.log("error creating block");
            console.log(component.errorString());
            return false;
        }
        dynamicObject.type = Math.floor(Math.random() * 3);
        dynamicObject.x = column * gameCanvas.blockSize;
        dynamicObject.y = row * gameCanvas.blockSize;
        dynamicObject.width = gameCanvas.blockSize;
        dynamicObject.height = gameCanvas.blockSize;
        board[index(column, row)] = dynamicObject;
    } else {
        console.log("error loading block component");
        console.log(component.errorString());
        return false;
    }
    return true;
}

var fillFound; //Set after a floodFill call to the number of blocks found
var floodBoard; //Set to 1 if the floodFill reaches off that node

//![1]
function handleClick(xPos, yPos) {
    var column = Math.floor(xPos / gameCanvas.blockSize);
    var row = Math.floor(yPos / gameCanvas.blockSize);
    if (column >= maxColumn || column < 0 || row >= maxRow || row < 0)
        return;
    if (board[index(column, row)] == null)
        return;
    //If it's a valid block, remove it and all connected (does nothing if it's not connected)
    floodFill(column, row, -1);
    if (fillFound <= 0)
        return;
    gameCanvas.score += (fillFound - 1) * (fillFound - 1);
    shuffleDown();
    victoryCheck();
}
//![1]

function floodFill(column, row, type) {
    if (board[index(column, row)] == null)
        return;
    var first = false;
    if (type == -1) {
        first = true;
        type = board[index(column, row)].type;

        //Flood fill initialization
        fillFound = 0;
        floodBoard = new Array(maxIndex);
    }
    if (column >= maxColumn || column < 0 || row >= maxRow || row < 0)
        return;
    if (floodBoard[index(column, row)] == 1 || (!first && type != board[index(column, row)].type))
        return;
    floodBoard[index(column, row)] = 1;
    floodFill(column + 1, row, type);
    floodFill(column - 1, row, type);
    floodFill(column, row + 1, type);
    floodFill(column, row - 1, type);
    if (first == true && fillFound == 0)
        return;     //Can't remove single blocks
    board[index(column, row)].opacity = 0;
    board[index(column, row)] = null;
    fillFound += 1;
}

function shuffleDown() {
    //Fall down
    for (var column = 0; column < maxColumn; column++) {
        var fallDist = 0;
        for (var row = maxRow - 1; row >= 0; row--) {
            if (board[index(column, row)] == null) {
                fallDist += 1;
            } else {
                if (fallDist > 0) {
                    var obj = board[index(column, row)];
                    obj.y += fallDist * gameCanvas.blockSize;
                    board[index(column, row + fallDist)] = obj;
                    board[index(column, row)] = null;
                }
            }
        }
    }
    //Fall to the left
    var fallDist = 0;
    for (var column = 0; column < maxColumn; column++) {
        if (board[index(column, maxRow - 1)] == null) {
            fallDist += 1;
        } else {
            if (fallDist > 0) {
                for (var row = 0; row < maxRow; row++) {
                    var obj = board[index(column, row)];
                    if (obj == null)
                        continue;
                    obj.x -= fallDist * gameCanvas.blockSize;
                    board[index(column - fallDist, row)] = obj;
                    board[index(column, row)] = null;
                }
            }
        }
    }
}

//![2]
function victoryCheck() {
    //Award bonus points if no blocks left
    var deservesBonus = true;
    for (var column = maxColumn - 1; column >= 0; column--)
        if (board[index(column, maxRow - 1)] != null)
        deservesBonus = false;
    if (deservesBonus)
        gameCanvas.score += 500;

    //Check whether game has finished
    if (deservesBonus || !(floodMoveCheck(0, maxRow - 1, -1)))
        dialog.show("Game Over. Your score is " + gameCanvas.score);
}
//![2]

//only floods up and right, to see if it can find adjacent same-typed blocks
function floodMoveCheck(column, row, type) {
    if (column >= maxColumn || column < 0 || row >= maxRow || row < 0)
        return false;
    if (board[index(column, row)] == null)
        return false;
    var myType = board[index(column, row)].type;
    if (type == myType)
        return true;
    return floodMoveCheck(column + 1, row, myType) || floodMoveCheck(column, row - 1, board[index(column, row)].type);
}

