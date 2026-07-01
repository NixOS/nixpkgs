let
  noop = pkgs: pkgs.writeShellScript "noop" "echo 'Unimplemented!'";
  root = "/tmp/vars-demo";
  mkBackendScript =
    name: text: pkgs:
    pkgs.lib.getExe (
      pkgs.writeShellApplication {
        inherit name text;
        runtimeInputs = [ pkgs.coreutils ];
      }
    );
in
{
  vars = {
    defaultGeneratorBackend = "example";
    generatorBackends.example = {
      get = mkBackendScript "get" ''
        cat ${root}/generators/"$1"/files/"$2" > $out
      '';
      set = mkBackendScript "set" ''
        mkdir -p ${root}/generators/"$1"/files/
        cat "$in" > ${root}/generators/"$1"/files/"$2"
      '';
      exists = mkBackendScript "exists" ''
        if [[ ! -f ${root}/generators/"$1"/files/"$2" ]]; then
          exit 42
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
