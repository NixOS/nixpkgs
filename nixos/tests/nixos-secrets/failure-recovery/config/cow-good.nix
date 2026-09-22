{ lib, ... }:
{
  secrets.store.derived = {
    dependencies = [ "greeting" ];
    files.cow-greeting = { };
    generate =
      pkgs:
      pkgs.writeScript "gen-derived" ''
        #!/bin/sh
        export PATH="${
          lib.makeBinPath [
            pkgs.coreutils
            pkgs.cowsay
          ]
        }"
        cat $in/greeting/greeting | cowsay > $out/cow-greeting
      '';
  };
}
