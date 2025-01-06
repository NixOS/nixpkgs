{
  replaceVars,
  runCommand,
  lib,
  runtimeShell,
  coreutils,
  getopt,
}:

runCommand "lsb_release"
  {
    meta = {
      description = "Prints certain LSB (Linux Standard Base) and Distribution information";
      mainProgram = "lsb_release";
      license = [ lib.licenses.mit ];
      maintainers = with lib.maintainers; [ primeos ];
      platforms = lib.platforms.linux;
    };
  }
  ''
    install -Dm 555 ${
      replaceVars ./lsb_release.sh {
        inherit runtimeShell coreutils getopt;
      }
    } $out/bin/lsb_release
  ''
