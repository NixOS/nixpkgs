{ lib
, runCommand
, writeText
, emptyFile
, emptyDirectory
, figlet
, hello
, zlib
}:
{
  inherit
    figlet
    hello
    zlib
    ;
  zlib-dev = zlib.dev;
  norefs = writeText "hi" "hello";
  norefsDup = writeText "hi" "hello";
  helloRef = writeText "hi" "hello ${hello}";
  helloRefDup = writeText "hi" "hello ${hello}";
  path = ./apath.txt;
  pathLike.outPath = ./apath.txt;
  helloFigletRef = writeText "hi" "hello ${hello} ${figlet}";
  selfRef = runCommand "self-ref-1" { } "echo $out >$out";
  selfRef2 = runCommand "self-ref-2" { } ''echo "${figlet}, $out" >$out'';
  inherit
    emptyFile
    emptyDirectory
    ;
}
