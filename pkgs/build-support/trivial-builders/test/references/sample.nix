{ pkgs ? import ../../../../.. { config = {}; overlays = []; } }:
let
  inherit (pkgs)
    figlet
    hello
    writeText
    runCommand
    ;
in
{
  hello = hello;
  figlet = figlet;
  norefs = writeText "hi" "hello";
  helloRef = writeText "hi" "hello ${hello}";
  helloFigletRef = writeText "hi" "hello ${hello} ${figlet}";
  selfRef = runCommand "self-ref" {} "echo $out >$out";
  selfRef2 = runCommand "self-ref-2" {} ''echo "${figlet}, $out" >$out'';
  inherit (pkgs)
    emptyFile
    emptyDirectory
  ;
}
