{ lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/security/vars.nix"
    ./backend-plain.nix
    ./backend-prompt.nix
    ./backend-age.nix
  ];

  vars = {
    age.publicKeys = [
      "age13ar5t7vvsssmckjhjtngy3p5y0v4k896ecjrxveql9ysu8gxhe9sdar3k3" # Host
      "age195x33zrqzppjfnj2rjjlq3z8s64r5zlwe6rcywm9zu6agf449pmqdslyat" # Target
    ];

    age.identity.host = ./key-host.txt;
    age.identity.target = ./key-target.txt;

    prompts.example.description = "Your name";
    prompts.example.type = "multiline";

    generators.example = {
      prompts = [ "example" ];
      files.example = { };
      script =
        pkgs:
        pkgs.writeScript "gen-example" ''
          #!/bin/sh
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          echo "Hewwo $(cat "$prompts/example")!" > "$out/example"
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

    generators.derived2 = {
      backend = "age";
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

    generators.derived3 = {
      dependencies = [ "derived2" ];
      files.derived = { };
      script =
        pkgs:
        pkgs.writeScript "gen-derived" ''
          #!/bin/sh
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          cat $in/derived2/derived > $out/derived
        '';
    };
  };
}
