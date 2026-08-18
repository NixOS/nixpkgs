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

    age.ssh.target = "root@lapetus.overlay.moonythm.dev";
    age.ssh.identity = "/home/moon/.ssh/id_ed25519";

    prompts.example.label = "Your name";
    prompts.example.description = "the person to address the greeting to";
    prompts.example.type = "multiline";

    generators.example = {
      prompts = [ "example" ];
      files.example.local = true;
      script =
        pkgs:
        pkgs.writeScript "gen-example" ''
          #!/bin/sh
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          echo "Hewwo $(cat "$prompts/example")!" > "$out/example"
        '';
    };

    generators.derived = {
      backend = "age";
      dependencies = [ "example" ];
      files.derived.local = false;
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

    generators.derivedPlain = {
      dependencies = [ "derived" ];
      files.derived.local = true;
      script =
        pkgs:
        pkgs.writeScript "gen-derived-plain" ''
          #!/bin/sh
          export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
          cat $in/derived/derived > $out/derived
        '';
    };
  };
}
