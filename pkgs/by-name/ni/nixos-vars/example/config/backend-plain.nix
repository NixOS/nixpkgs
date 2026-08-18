{ lib, config, ... }:
let
  cfg = config.vars.plain;

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
  options.vars.plain = {
    hostDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/vars-ng-ng-plain/host/${config.networking.hostName}";
      description = ''
        The directory where the plain backend will store variables on the host
        machine.
      '';
    };

    targetDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/vars-ng-ng-plain/target";
      description = ''
        The directory where the age backend will store variables on the target
        machine.
      '';
    };
  };

  config.vars = {
    defaultGeneratorBackend = "plain";
    generatorBackends.plain = {
      get = mkScript "get" ''
        out=''${out:?} # Make shellcheck happy
        cat ${cfg.hostDirectory}/generators/"$1"/files/"$2" > "$out"
      '';
      set = mkScript "set" ''
        in=''${in:?} # Make shellcheck happy
        mkdir -p ${cfg.hostDirectory}/generators/"$1"/files/
        cat "$in" > ${cfg.hostDirectory}/generators/"$1"/files/"$2"
      '';
      exists = mkScript "exists" ''
        if [[ ! -f ${cfg.hostDirectory}/generators/"$1"/files/"$2" ]]; then
          exit 42
        fi
      '';

      delete = mkScript "delete" ''
        rm -rf ${cfg.hostDirectory}/generators/"$1"/files/"$2"
      '';

      # This example showcases that scripts can be written in any language
      list =
        pkgs:
        pkgs.writers.writePython3 "list" { } ''
          from pathlib import Path
          base = Path("${cfg.hostDirectory}/generators")
          if base.exists():
              for generator in base.iterdir():
                  for file in (generator / "files").iterdir():
                      print(f"{generator.name} {file.name}")
        '';

      deploy.local = mkScript "deploy-local" ''
        # NOTE: this script will not parse the input file list (my bash-fu is
        # not strong enough...). It will instead push all the secrets to the
        # target machine :p

        if [[ ! -d "$1" ]]; then
          echo "System root not found" 1>&2
          exit 1
        fi

        if [[ -d "${cfg.hostDirectory}/generators" ]]; then
          for generator in "${cfg.hostDirectory}/generators"/*; do
            [[ -d "$generator" ]] || continue
            files="$generator/files"
            [[ -d "$files" ]] || continue
            for file in "$files"/*; do
              [[ -e "$file" ]] || continue
              dir="$1/${cfg.targetDirectory}/$(basename "$generator")"
              mkdir -p "$dir"
              cp "$file" "$dir/$(basename "$file")"
            done
          done
        fi
      '';

      fileModule =
        { generator, name, ... }:
        {
          path = "${cfg.targetDirectory}/${generator.name}/${name}";
        };
    };
  };
}
