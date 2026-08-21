{ lib, modulesPath, ... }:
{
  imports = [
    ./backend.nix
    "${modulesPath}/security/secrets.nix"
  ];

  secrets = {
    store.example = {
      prompts.example.description = "Your name";

      files.example = { };
      generate =
        pkgs:
        pkgs.writeScript "gen-example" ''
          #!/bin/sh
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          echo "Hewwo $(cat "$prompts/example")!" > $out/example
        '';
    };

    store.derived = {
      dependencies = [ "example" ];
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
          cat $in/example/example | cowsay > $out/derived
        '';
    };
  };
}
