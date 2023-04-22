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
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        export STARSHIP_CONFIG=${settingsFile}
        eval "$(${pkgs.starship}/bin/starship init bash)"
      fi
    '';

    programs.fish.${initOption} = ''
      if test "$TERM" != "dumb" -a \( -z "$INSIDE_EMACS" -o "$INSIDE_EMACS" = "vterm" \)
        set -x STARSHIP_CONFIG ${settingsFile}
        eval (${pkgs.starship}/bin/starship init fish)
      end
    '';

    programs.zsh.${initOption} = ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        export STARSHIP_CONFIG=${settingsFile}
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      fi
    '';
  };

  meta.maintainers = pkgs.starship.meta.maintainers;
}
