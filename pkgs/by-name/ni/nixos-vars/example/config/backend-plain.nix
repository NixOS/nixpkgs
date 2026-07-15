let
  rootHost = "/tmp/vars-demo";
  rootTarget = "/tmp/deployed-vars-demo";
  mkScript =
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
    defaultGeneratorBackend = "plain";
    generatorBackends.plain = {
      get = mkScript "get" ''
        out=''${out:?} # Make shellcheck happy
        cat ${rootHost}/generators/"$1"/files/"$2" > "$out"
      '';
      set = mkScript "set" ''
        in=''${in:?} # Make shellcheck happy
        mkdir -p ${rootHost}/generators/"$1"/files/
        cat "$in" > ${rootHost}/generators/"$1"/files/"$2"
      '';
      exists = mkScript "exists" ''
        if [[ ! -f ${rootHost}/generators/"$1"/files/"$2" ]]; then
          exit 42
        fi
      '';

      delete = mkScript "delete" ''
        rm -rf ${rootHost}/generators/"$1"/files/"$2"
      '';

      # This example showcases that scripts can be written in any language
      list =
        pkgs:
        pkgs.writers.writePython3 "list" { } ''
          from pathlib import Path
          base = Path("${rootHost}/generators")
          if base.exists():
              for generator in base.iterdir():
                  for file in (generator / "files").iterdir():
                      print(f"{generator.name} {file.name}")
        '';

      fixup = mkScript "fixup" "";

      deploy = mkScript "deploy" ''
        echo "Not implemented :(" 1>&2 
        exit 1
      '';

      deployLocal = mkScript "deployLocal" ''
        if [[ ! -d "$1" ]]; then
          echo "System root not found" 1>&2 
          exit 1
        fi

        if [[ -d "${rootHost}/generators" ]]; then
          for generator in "${rootHost}/generators"/*; do
            [[ -d "$generator" ]] || continue
            files="$generator/files"
            [[ -d "$files" ]] || continue
            for file in "$files"/*; do
              [[ -e "$file" ]] || continue
              dir="$1/${rootTarget}/$(basename "$generator")"
              mkdir -p "$dir"
              cp "$file" "$dir/$(basename "$file")"
            done
          done
        fi
      '';

      fileModule =
        { generator, name, ... }:
        {
          path = "${rootTarget}/${generator.name}/${name}";
        };
    };
  };
}
