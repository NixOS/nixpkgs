# we use this vars backend as an example backend.
# this generates a script which creates the values at the expected path.
# this script has to be run manually (I guess after updating the system) to generate the required vars.
{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.vars.settings.on-machine;
  sortedGenerators =
    (lib.toposort (a: b: builtins.elem a.name b.dependencies) (lib.attrValues config.vars.generators))
    .result;

  promptCmd = {
    hidden = "read -sr prompt_value";
    line = "read -r prompt_value";
    multiline = ''
      echo 'press control-d to finish'
      prompt_value=$(cat)
    '';
  };
  generate-vars = pkgs.writeShellApplication {
    name = "generate-vars";
    text = ''
      set -efuo pipefail

      PATH=${lib.makeBinPath [ pkgs.coreutils ]}

      # make the output directory overridable
      OUT_DIR=''${OUT_DIR:-${cfg.fileLocation}}

      # check if all files are present or all files are missing
      # if not, they are in an inconsistent state and we bail out
      ${lib.concatMapStringsSep "\n" (gen: ''
        all_files_missing=true
        all_files_present=true
        ${lib.concatMapStringsSep "\n" (file: ''
          if test -e ${lib.escapeShellArg file.path} ; then
            all_files_missing=false
          else
            all_files_present=false
          fi
        '') (lib.attrValues gen.files)}

        if [ $all_files_missing = false ] && [ $all_files_present = false ] ; then
          echo "Inconsistent state for generator: {gen.name}"
          exit 1
        fi
        if [ $all_files_present = true ] ; then
          echo "All secrets for ${gen.name} are present"
        elif [ $all_files_missing = true ] ; then

          # prompts
          prompts=$(mktemp -d)
          trap 'rm -rf $prompts' EXIT
          export prompts
          mkdir -p "$prompts"
          ${lib.concatMapStringsSep "\n" (prompt: ''
            echo ${lib.escapeShellArg prompt.description}
            ${promptCmd.${prompt.type}}
            echo -n "$prompt_value" > "$prompts"/${prompt.name}
          '') (lib.attrValues gen.prompts)}
          echo "Generating vars for ${gen.name}"

          # dependencies
          in=$(mktemp -d)
          trap 'rm -rf $in' EXIT
          export in
          mkdir -p "$in"
          ${lib.concatMapStringsSep "\n" (input: ''
            mkdir -p "$in"/${input}
            ${lib.concatMapStringsSep "\n" (file: ''
              cp "$OUT_DIR"/${
                if file.secret then "secret" else "public"
              }/${input}/${file.name} "$in"/${input}/${file.name}
            '') (lib.attrValues config.vars.generators.${input}.files)}
          '') gen.dependencies}

          # outputs
          out=$(mktemp -d)
          trap 'rm -rf $out' EXIT
          export out
          mkdir -p "$out"

          (
            # prepare PATH
            unset PATH
            ${lib.optionalString (gen.runtimeInputs != [ ]) ''
              PATH=${lib.makeBinPath gen.runtimeInputs}
              export PATH
            ''}

            # actually run the generator
            ${gen.script}
          )

          # check if all files got generated
          ${lib.concatMapStringsSep "\n" (file: ''
            if ! test -e "$out"/${file.name} ; then
              echo 'generator ${gen.name} failed to generate ${file.name}'
              exit 1
            fi
          '') (lib.attrValues gen.files)}

          # move the files to the correct location
          ${lib.concatMapStringsSep "\n" (file: ''
            OUT_FILE="$OUT_DIR"/${if file.secret then "secret" else "public"}/${file.generator}/${file.name}
            mkdir -p "$(dirname "$OUT_FILE")"
            mv "$out"/${file.name} "$OUT_FILE"
          '') (lib.attrValues gen.files)}
          rm -rf "$out"
        fi
      '') sortedGenerators}
    '';
  };
in
{
  options.vars.settings.on-machine = {
    enable = lib.mkEnableOption "Enable on-machine vars backend";
    fileLocation = lib.mkOption {
      type = lib.types.str;
      default = "/etc/vars";
    };
  };
  config = lib.mkIf cfg.enable {
    vars.settings.fileModule = file: {
      path =
        if file.config.secret then
          "${cfg.fileLocation}/secret/${file.config.generator}/${file.config.name}"
        else
          "${cfg.fileLocation}/public/${file.config.generator}/${file.config.name}";
    };
    environment.systemPackages = [
      generate-vars
    ];
    system.build.generate-vars = generate-vars;
  };
}
