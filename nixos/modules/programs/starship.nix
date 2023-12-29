{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.starship;

  settingsFormat = pkgs.formats.toml { };

  settingsFile = settingsFormat.generate "starship.toml" cfg.settings;

  initOption =
    if cfg.interactiveOnly then
      "promptInit"
    else
      "shellInit";

in
{
  options.programs.starship = {
    enable = mkEnableOption (lib.mdDoc "the Starship shell prompt");

    interactiveOnly = mkOption {
      default = true;
      example = false;
      type = types.bool;
      description = lib.mdDoc ''
        Whether to enable starship only when the shell is interactive.
        Some plugins require this to be set to false to function correctly.
      '';
    };

    settings = mkOption {
      inherit (settingsFormat) type;
      default = { };
      description = lib.mdDoc ''
        Configuration included in `starship.toml`.

        See https://starship.rs/config/#prompt for documentation.
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.bash.${initOption} = ''
      if [[ $TERM != "dumb" ]]; then
        # don't set STARSHIP_CONFIG automatically if there's a user-specified
        # config file.  starship appears to use a hardcoded config location
        # rather than one inside an XDG folder:
        # https://github.com/starship/starship/blob/686bda1706e5b409129e6694639477a0f8a3f01b/src/configure.rs#L651
        if [[ ! -f "$HOME/.config/starship.toml" ]]; then
          export STARSHIP_CONFIG=${settingsFile}
        fi
        eval "$(${pkgs.starship}/bin/starship init bash)"
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
        eval (${pkgs.starship}/bin/starship init fish)
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
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      fi
    '';
  };

  meta.maintainers = pkgs.starship.meta.maintainers;
}
