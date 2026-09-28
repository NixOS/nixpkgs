{ lib, ... }:
{
  secrets.store.derived = {
    dependencies = [ "greeting" ];
    files.cow-greeting = { };
    generate =
      pkgs:
      pkgs.writeShellScript "gen-derived" ''
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
