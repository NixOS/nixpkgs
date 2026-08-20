{ lib, modulesPath, ... }:
{
  imports = [
    "${modulesPath}/security/secrets.nix"
    ../common/backend-plain.nix
    ../common/backend-prompt.nix
    ../common/backend-age.nix
  ];

  secrets = {
    defaultGeneratorBackend = "plain";
    defaultPromptBackend = "simple";

    age.publicKeys = [
      "age13ar5t7vvsssmckjhjtngy3p5y0v4k896ecjrxveql9ysu8gxhe9sdar3k3" # Host
      "age195x33zrqzppjfnj2rjjlq3z8s64r5zlwe6rcywm9zu6agf449pmqdslyat" # Target
    ];

    # NOTE: do *not* do this with real keys!!! This will copy the keys to the
    # world-readable Nix store, which is most probably not what you want!
    age.identity.host = toString ../common/key-host.txt;
    age.identity.target = toString ../common/key-target.txt;

    age.ssh.target = "root@lapetus.overlay.moonythm.dev";
    age.ssh.identity = "/home/moon/.ssh/id_ed25519";

    # This prompt will default to the "simple" backend we chose above.
    prompts.example.label = "Your name";
    prompts.example.description = "the person to address the greeting to";
    prompts.example.type = "multiline";

    generators.example = {
      prompts = [ "example" ];
      files.example.deploy = false;
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

    generators.derivedPlain = {
      dependencies = [ "derived" ];
      files.derived = { };
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
