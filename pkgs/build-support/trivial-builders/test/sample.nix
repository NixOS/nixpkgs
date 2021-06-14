{ pkgs ? import ../../../.. { config = {}; overlays = []; } }:
let
  inherit (pkgs)
    figlet
    hello
    writeText
    ;
in
{
  hello = hello;
  figlet = figlet;
  norefs = writeText "hi" "hello";
  helloRef = writeText "hi" "hello ${hello}";
  helloFigletRef = writeText "hi" "hello ${hello} ${figlet}";
  inherit (pkgs)
    emptyFile
    emptyDirectory
  ;
}
