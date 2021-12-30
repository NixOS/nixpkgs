{ callPackage, lib, pkgs, runCommand, concatText, writeText, hello }:
let
  stri = writeText "pathToTest";
  txt1 = stri "abc";
  txt2 = stri hello;
  res = concatText "textToTest" [ txt1 txt2 ];
in
runCommand "test-concatPaths" { } ''
  diff -U3 <(cat ${txt1} ${txt2}) ${res}
  touch $out
''
