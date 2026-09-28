{ lib, ... }:
{
  imports = [ ./common.nix ];

  secrets = {
    store.greeting = {
      prompts.name.description = "Your name";
      files.greeting = { };
      generate =
        pkgs:
        pkgs.writeShellScript "gen-example" ''
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          echo "Hewwo $(cat "$prompts/name")!!!" > $out/greeting
        '';
    };

    store.derived = {
      dependencies = [ "greeting" ];
      files.reverse-greeting = { };
      generate =
        pkgs:
        pkgs.writeShellScript "gen-reverse" ''
          export PATH="${
            lib.makeBinPath [
              pkgs.coreutils
              pkgs.util-linuxMinimal # rev
            ]
          }"
          cat $in/greeting/greeting | rev > $out/reverse-greeting
        '';
    };
  };
}
