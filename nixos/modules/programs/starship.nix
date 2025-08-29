{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.starship;

  settingsFormat = pkgs.formats.toml { };

  userSettingsFile = settingsFormat.generate "starship.toml" cfg.settings;

  settingsFile =
    if cfg.presets == [ ] then
      userSettingsFile
    else
      pkgs.runCommand "starship.toml"
        {
          nativeBuildInputs = [ pkgs.yq ];
        }
        ''
          tomlq -s -t 'reduce .[] as $item ({}; . * $item)' \
            ${
              lib.concatStringsSep " " (map (f: "${cfg.package}/share/starship/presets/${f}.toml") cfg.presets)
            } \
            ${userSettingsFile} \
            > $out
        '';

  initOption = if cfg.interactiveOnly then "promptInit" else "shellInit";

in
{
  options.programs.starship = {
    enable = lib.mkEnableOption "the Starship shell prompt";

    package = lib.mkPackageOption pkgs "starship" { };

    interactiveOnly =
      lib.mkEnableOption ''
        starship only when the shell is interactive.
        Some plugins require this to be set to false to function correctly
      ''
      // {
        default = true;
      };

    presets = lib.mkOption {
      default = [ ];
      example = [ "nerd-font-symbols" ];
      type = with lib.types; listOf str;
      description = ''
        Presets files to be merged with settings in order.
      '';
    };

    settings = lib.mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = ''
        Configuration included in `starship.toml`.

        See <https://starship.rs/config/#prompt> for documentation.
      '';
    };

    transientPrompt =
      let
        mkTransientPromptOption =
          side:
          lib.mkOption {
            type =
              with lib.types;
              nullOr (str // { description = "Fish shell code concatenated with \"\\n\""; });
            description =
              let
                function = "`starship_transient_${lib.optionalString (side == "right") "r"}prompt_func` function";
              in
              ''
                Fish code composing the body of the ${function}. The output of
                this code will become the ${side} side of the transient prompt.

                Not setting this option (or setting it to `null`) will prevent
                the ${function} from being generated. By default, the ${side}
                prompt is ${if (side == "right") then "empty" else "a bold-green '❯' character"}.
              '';
            example = "starship module ${if (side == "right") then "time" else "character"}";
            default = null;
          };
      in
      {
        enable = lib.mkEnableOption ''
          Starship's [transient prompt](https://starship.rs/advanced-config/#transientprompt-and-transientrightprompt-in-fish)
          feature in `fish` shells. After a command has been entered, Starship
          replaces the usual prompt with the terminal output of the commands
          defined in the `programs.starship.transientPrompt.left`
          and `programs.starship.transientPrompt.right` options.

          This option only works with `fish`, as `bash` requires a
          [custom configuration](https://starship.rs/advanced-config/#transientprompt-and-transientrightprompt-in-bash)
          involving [Ble.sh](https://github.com/akinomyoga/ble.sh), which can be
          enabled with `programs.bash.blesh.enable`, but not configured using NixOS
        '';
        left = mkTransientPromptOption "left";
        right = mkTransientPromptOption "right";
      };
  };

  config = lib.mkIf cfg.enable {
    programs.bash.${initOption} = ''
      if [[ $TERM != "dumb" ]]; then
        # don't set STARSHIP_CONFIG automatically if there's a user-specified
        # config file.  starship appears to use a hardcoded config location
        # rather than one inside an XDG folder:
        # https://github.com/starship/starship/blob/686bda1706e5b409129e6694639477a0f8a3f01b/src/configure.rs#L651
        if [[ ! -f "$HOME/.config/starship.toml" ]]; then
          export STARSHIP_CONFIG=${settingsFile}
        fi
        eval "$(${cfg.package}/bin/starship init bash)"
      fi
    '';

    programs.fish.${initOption} = ''
      if test "$TERM" != "dumb"
        # don't set STARSHIP_CONFIG automatically if there's a user-specified
        # config file.  starship appears to use a hardcoded config location
        # rather than one inside an XDG folder:
        # https://github.com/starship/starship/blob/686bda1706e5b409129e6694639477a0f8a3f01b/src/configure.rs#L651
        if not test -f "$HOME/.config/starship.toml";
          set -x STARSHIP_CONFIG ${settingsFile}
        end
        ${lib.optionalString (!isNull cfg.transientPrompt.left) ''
          function starship_transient_prompt_func
            ${cfg.transientPrompt.left}
          end
        ''}
        ${lib.optionalString (!isNull cfg.transientPrompt.right) ''
          function starship_transient_rprompt_func
            ${cfg.transientPrompt.right}
          end
        ''}
        eval (${cfg.package}/bin/starship init fish)
        ${lib.optionalString cfg.transientPrompt.enable "enable_transience"}
      end
    '';

    programs.zsh.${initOption} = ''
      if [[ $TERM != "dumb" ]]; then
        # don't set STARSHIP_CONFIG automatically if there's a user-specified
        # config file.  starship appears to use a hardcoded config location
        # rather than one inside an XDG folder:
        # https://github.com/starship/starship/blob/686bda1706e5b409129e6694639477a0f8a3f01b/src/configure.rs#L651
        if [[ ! -f "$HOME/.config/starship.toml" ]]; then
          export STARSHIP_CONFIG=${settingsFile}
        fi
        eval "$(${cfg.package}/bin/starship init zsh)"
      fi
    '';

    # use `config` instead of `${initOption}` because `programs.xonsh` doesn't have `shellInit` or `promptInit`
    programs.xonsh.config = ''
      if $TERM != "dumb":
        # don't set STARSHIP_CONFIG automatically if there's a user-specified
        # config file.  starship appears to use a hardcoded config location
        # rather than one inside an XDG folder:
        # https://github.com/starship/starship/blob/686bda1706e5b409129e6694639477a0f8a3f01b/src/configure.rs#L651
        if not `$HOME/.config/starship.toml`:
          $STARSHIP_CONFIG = ('${settingsFile}')
        execx($(${cfg.package}/bin/starship init xonsh))
    '';
  };

  meta.maintainers = pkgs.starship.meta.maintainers;
}
