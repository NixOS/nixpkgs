{
  cacert,
  cf,
  lib,
  runCommand,
  nodejs,
  writableTmpDirAsHomeHook,
}:

runCommand "cf-functional-tests"
  {
    __darwinAllowLocalNetworking = true;
    sandboxProfile = ''
      (allow mach-lookup (global-name "com.apple.FSEvents"))
    '';
    nativeBuildInputs = [
      cacert
      nodejs
      writableTmpDirAsHomeHook
    ];
  }
  ''
    node ${./test.mjs} ${lib.getExe cf} ${cf.version} ${cf}
    touch $out
  ''
