{ lib, ... }:
{
  imports = [ ./common.nix ];

  secrets = {
    store.greeting = {
      prompts.name.description = "Your name";
      files.greeting = { };
      generate =
        pkgs:
        pkgs.writeScript "gen-example" ''
          #!/bin/sh
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          echo "Hewwo $(cat "$prompts/name")!!" > $out/greeting
        '';
    };

    store.derived = {
      dependencies = [ "greeting" ];
      files.derived2 = { };
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

          cat $in/greeting/greeting | cowsay > $out/derived2
        '';
    };
  };
}
