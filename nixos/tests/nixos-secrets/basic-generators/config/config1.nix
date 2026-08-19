{ lib, modulesPath, ... }:
{
  imports = [
    ./backend.nix
    "${modulesPath}/security/secrets.nix"
  ];

  secrets = {
    prompts.example.description = "Your name";

    generators.example = {
      prompts = [ "example" ];
      files.example = { };
      script =
        pkgs:
        pkgs.writeScript "gen-example" ''
          #!/bin/sh
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          echo "Hewwo $(cat "$prompts/example")!" > $out/example
        '';
    };

    generators.derived = {
      dependencies = [ "example" ];
      files.derived = { };
      script =
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
