let
  noop = pkgs: pkgs.writeShellScript "noop" "echo 'Unimplemented!'";
in
{
  vars = {
    defaultGeneratorBackend = "example";
    generatorBackends.example = {
      get = noop;
      set = noop;
      deploy = noop;
      fixup = noop; # This one's optional, but I wanted to make sure that works
      exists =
        pkgs:
        pkgs.writeShellScript "exists" ''
          if [[ ! -f ./generators/$1/files/$2 ]]; then 
            exit 1
          fi
        '';
    };

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
      files.derived = { };
      script =
        pkgs:
        pkgs.writeShellScript "gen-derived" ''
          cp $in/example $out/derived
        '';
    };
  };
}
