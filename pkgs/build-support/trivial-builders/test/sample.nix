{ pkgs ? import ../../../.. { config = {}; overlays = []; } }:
let
  inherit (pkgs)
    figlet
    zlib
    hello
    writeText
    ;
in
{
  hello = hello;
  figlet = figlet;
  zlib = zlib;
  zlib-dev = zlib.dev;
  norefs = writeText "hi" "hello";
  norefsDup = writeText "hi" "hello";
  helloRef = writeText "hi" "hello ${hello}";
  helloRefDup = writeText "hi" "hello ${hello}";
  path = ./invoke-writeReferencesToFile.nix;
  helloFigletRef = writeText "hi" "hello ${hello} ${figlet}";
  inherit (pkgs)
    emptyFile
    emptyDirectory
  ;
}
