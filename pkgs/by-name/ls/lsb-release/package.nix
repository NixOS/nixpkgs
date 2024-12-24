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
    meta = with lib; {
      description = "Prints certain LSB (Linux Standard Base) and Distribution information";
      mainProgram = "lsb_release";
      license = [ licenses.mit ];
      maintainers = with maintainers; [ primeos ];
      platforms = platforms.linux;
    };
  }
  ''
    install -Dm 555 ${
      replaceVars ./lsb_release.sh {
        inherit runtimeShell coreutils getopt;
      }
    } $out/bin/lsb_release
  ''
