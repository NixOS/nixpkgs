{
  imports = [ ./backend.nix ];

  vars = {
    generators.example = {
      files.example = { };
      script =
        pkgs:
        pkgs.writeShellScript "gen-example" ''
          echo "Hewwo!" > $out/example
        '';
    };

    generators.derived = {
      dependencies = [ "example" ];
      files.derived2 = { };
      script =
        pkgs:
        pkgs.writeShellScript "gen-derived" ''
          ${pkgs.coreutils}/bin/cat $in/example/example \
            | ${pkgs.lib.getExe pkgs.cowsay} > $out/derived2
        '';
    };
  };
}
