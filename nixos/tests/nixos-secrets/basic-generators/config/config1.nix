{ lib, ... }:
{
  imports = [ ./common.nix ];

  secrets = {
    store.greeting = {
      prompts.name.description = "Your name";

      files.greeting = { };
      generate =
        pkgs:
        pkgs.writeScript "gen-greeting" ''
          #!/bin/sh
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          echo "Hewwo $(cat "$prompts/name")!" > $out/greeting
        '';
    };

    store.derived = {
      dependencies = [ "greeting" ];
      files.derived = { };
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
          cat $in/greeting/greeting | cowsay > $out/derived
        '';
    };
  };
}
