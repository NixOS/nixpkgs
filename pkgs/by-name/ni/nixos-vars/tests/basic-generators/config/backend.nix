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
        out=''${out:?} # Make shellcheck happy
        cat ${root}/generators/"$1"/files/"$2" > "$out"
      '';
      set = mkBackendScript "set" ''
        in=''${in:?} # Make shellcheck happy
        mkdir -p ${root}/generators/"$1"/files/
        cat "$in" > ${root}/generators/"$1"/files/"$2"
      '';
      exists = mkBackendScript "exists" ''
        if [[ ! -f ${root}/generators/"$1"/files/"$2" ]]; then
          exit 42
        fi
      '';
      delete = mkBackendScript "delete" ''
        rm -rf ${root}/generators/"$1"/files/"$2"
      '';

      # This example showcases that scripts can be written in any language
      list =
        pkgs:
        pkgs.writers.writePython3 "list" { } ''
          from pathlib import Path
          base = Path("${root}/generators")
          if base.exists():
              for generator in base.iterdir():
                  for file in (generator / "files").iterdir():
                      print(f"{generator.name} {file.name}")
        '';

      deploy = noop;
      fixup = noop; # This one's optional, but I wanted to make sure that works
    };
  };
}
