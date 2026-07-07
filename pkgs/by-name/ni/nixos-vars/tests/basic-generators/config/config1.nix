{
  imports = [ ./backend.nix ];
  vars = {
    prompts.example.description = "Your name";

    generators.example = {
      prompts = [ "example" ];
      files.example = { };
      script =
        pkgs:
        pkgs.writeShellScript "gen-example" ''
          echo "Hewwo $(${pkgs.coreutils}/bin/cat "$prompts/example")!" > $out/example
        '';
    };

    generators.derived = {
      dependencies = [ "example" ];
      files.derived = { };
      script =
        pkgs:
        pkgs.writeShellScript "gen-derived" ''
          ${pkgs.coreutils}/bin/cat $in/example/example \
            | ${pkgs.lib.getExe pkgs.cowsay} > $out/derived
        '';
    };
  };
}
