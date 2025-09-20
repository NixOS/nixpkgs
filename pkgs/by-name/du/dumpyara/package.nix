{
  lib,
  buildFHSEnv,
  dumpyara-unwrapped,
  runCommand,
  dumpyara,
  squashfsTools,
  zip,
}:
buildFHSEnv {
  pname = "dumpyara";
  inherit (dumpyara-unwrapped) version;

  strictDeps = true;

  runScript = lib.getExe dumpyara-unwrapped;

  passthru.tests = {
    requiredTools =
      runCommand "check-required-tools"
        {
          nativeBuildInputs = [
            dumpyara
            squashfsTools
            zip
          ];
        }
        ''
          echo foo > bar.txt
          mksquashfs bar.txt system.img
          zip system.zip system.img
          dumpyara system.zip
          touch $out
        '';
  };

  inherit (dumpyara-unwrapped) meta;
}
