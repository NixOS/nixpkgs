let
  noop = pkgs: pkgs.writeShellScript "noop" "echo 'Unimplemented!'";
  root = "/tmp/vars-demo";
in
{
  vars = {
    defaultGeneratorBackend = "example";
    generatorBackends.example = {
      get =
        pkgs:
        pkgs.writeShellScript "get" ''
          ${pkgs.coreutils}/bin/cat ${root}/generators/"$1"/files/"$2" > $out
        '';
      set =
        pkgs:
        pkgs.writeShellScript "set" ''
          ${pkgs.coreutils}/bin/mkdir -p ${root}/generators/"$1"/files/
          ${pkgs.coreutils}/bin/cat "$in" > ${root}/generators/"$1"/files/"$2"
        '';
      exists =
        pkgs:
        pkgs.writeShellScript "exists" ''
          if [[ ! -f ${root}/generators/"$1"/files/"$2" ]]; then
            exit 1
          fi
        '';
      deploy = noop;
      fixup = noop; # This one's optional, but I wanted to make sure that works
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
          ${pkgs.coreutils}/bin/cat $in/example/example \
            | ${pkgs.lib.getExe pkgs.cowsay} > $out/derived
        '';
    };
  };
}
