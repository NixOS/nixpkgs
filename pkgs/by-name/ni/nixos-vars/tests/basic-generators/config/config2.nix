{
  imports = [ ./backend.nix ];

  vars = {
    prompts.example.description = "Your name";

    generators.example = {
      prompts = [ "example" ];
      files.example = { };
      script =
        pkgs:
        pkgs.writeScript "gen-example" ''
          #!/bin/sh
          echo "Hewwo $(${pkgs.coreutils}/bin/cat "$prompts/example")!!" > $out/example
        '';
    };

    generators.derived = {
      dependencies = [ "example" ];
      files.derived2 = { };
      script =
        pkgs:
        pkgs.writeScript "gen-derived" ''
          #!/bin/sh
          ${pkgs.coreutils}/bin/cat $in/example/example \
             > $out/derived2
        '';
    };
  };
}
