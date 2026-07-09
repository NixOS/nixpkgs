{ lib, ... }:
let
  noop = pkgs: pkgs.writeShellScript "noop" "echo 'Unimplemented!'";
  root = "/tmp/vars-demo";
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
      list = mkBackendScript "list" ''
        if [[ -d "${root}/generators" ]]; then
          for generator in "${root}/generators"/*; do
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

      deploy = noop;
      fixup = noop; # This one's optional, but I wanted to make sure that works
    };
  };
}
