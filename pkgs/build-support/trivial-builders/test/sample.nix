{ pkgs ? import ../../../.. { config = { }; overlays = [ ]; } }:
let
  inherit (pkgs)
    figlet
    zlib
    hello
    writeText
    runCommand
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
  pathLike.outPath = ./invoke-writeReferencesToFile.nix;
  helloFigletRef = writeText "hi" "hello ${hello} ${figlet}";
  selfRef = runCommand "self-ref-1" {} "echo $out >$out";
  selfRef2 = runCommand "self-ref-2" {} ''echo "${figlet}, $out" >$out'';
  inherit (pkgs)
    emptyFile
    emptyDirectory
  ;
}
