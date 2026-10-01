{
  cloudflare-cf,
  lib,
  runCommand,
  nodejs,
  writableTmpDirAsHomeHook,
}:

runCommand "cloudflare-cf-functional-tests"
  {
    nativeBuildInputs = [
      nodejs
      writableTmpDirAsHomeHook
    ];
  }
  ''
    node ${./test.mjs} ${lib.getExe cloudflare-cf} ${cloudflare-cf.version} ${cloudflare-cf}
    touch $out
  ''
