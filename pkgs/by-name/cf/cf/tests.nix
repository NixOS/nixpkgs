{
  cf,
  lib,
  runCommand,
  nodejs,
  writableTmpDirAsHomeHook,
}:

runCommand "cf-functional-tests"
  {
    nativeBuildInputs = [
      nodejs
      writableTmpDirAsHomeHook
    ];
  }
  ''
    node ${./test.mjs} ${lib.getExe cf} ${cf.version} ${cf}
    touch $out
  ''
