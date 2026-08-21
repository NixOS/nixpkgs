{ lib, modulesPath, ... }:
{
  imports = [
    ./backend.nix
    "${modulesPath}/security/secrets.nix"
  ];

  secrets = {
    store."different attribute name" = {
      name = "example"; # This should be used instead!
      prompts.example.description = "Your name";
      files.example = { };
      generate =
        pkgs:
        pkgs.writeScript "gen-example" ''
          #!/bin/sh
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          echo "Hewwo $(cat "$prompts/example")!!" > $out/example
        '';
    };

    store.derived = {
      dependencies = [ "example" ];
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

          cat $in/example/example | cowsay > $out/derived2
        '';
    };
  };
}
