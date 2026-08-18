{ lib, ... }:
let
  noop = pkgs: pkgs.writeShellScript "noop" "echo 'Unimplemented!'";
  rootHost = "/tmp/vars-demo";
  rootTarget = "/tmp/vars-demo"; # Absolute in the context of the target system!
  mkBackendScript =
    name: text: pkgs:
    pkgs.writeScript name ''
      #!/bin/sh
      export PATH="${lib.makeBinPath [ pkgs.coreutils ]}"
      ${text}
    '';
in
{
  vars = {
    defaultPromptBackend = "example";

    # Non-interactive backend
    promptBackends.example.script = mkBackendScript "prompt" ''
      out=''${out:?} # Make shellcheck happy
      echo -n "placeholder" > "$out"
    '';

    defaultGeneratorBackend = "example";
    generatorBackends.example = {
      get = mkBackendScript "get" ''
        out=''${out:?} # Make shellcheck happy
        cat ${rootHost}/generators/"$1"/files/"$2" > "$out"
      '';
      set = mkBackendScript "set" ''
        in=''${in:?} # Make shellcheck happy
        mkdir -p ${rootHost}/generators/"$1"/files/
        cat "$in" > ${rootHost}/generators/"$1"/files/"$2"
      '';
      exists = mkBackendScript "exists" ''
        if [[ ! -f ${rootHost}/generators/"$1"/files/"$2" ]]; then
          exit 42
        fi
      '';
      delete = mkBackendScript "delete" ''
        rm -rf ${rootHost}/generators/"$1"/files/"$2"
      '';
      list = mkBackendScript "list" ''
        if [[ -d "${rootHost}/generators" ]]; then
          for generator in "${rootHost}/generators"/*; do
            [[ -d "$generator" ]] || continue
            files="$generator/files"
            [[ -d "$files" ]] || continue
            for file in "$files"/*; do
              [[ -e "$file" ]] || continue
              echo "$(basename "$generator") $(basename "$file")"
            done
          done
        fi
      '';

      fixup = noop;

      deploy.remote = mkBackendScript "deploy-remote" ''
        echo "Not implemented :(" 1>&2
        exit 1
      '';

      deploy.local = mkBackendScript "deploy-local" ''
        if [[ ! -d "$1" ]]; then
          echo "System root not found" 1>&2
          exit 1
        fi

        rm -rf "$1/${rootTarget}"
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
