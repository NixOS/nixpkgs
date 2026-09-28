{ lib, ... }:
{
  imports = [ ./common.nix ];

  secrets = {
    store.greeting = {
      prompts.name.description = "Your name";
      files.greeting = { };
      generate =
        pkgs:
        pkgs.writeShellScript "gen-greeting" ''
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          echo "Hewwo $(cat "$prompts/name")!" > $out/greeting
        '';
    };

    store.derived = {
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
  };
}
