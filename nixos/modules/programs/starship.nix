{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.starship;

  settingsFormat = pkgs.formats.toml { };

  settingsFile = settingsFormat.generate "starship.toml" cfg.settings;

in {
  options.programs.starship = {
    enable = mkEnableOption (lib.mdDoc "the Starship shell prompt");

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
    programs.bash.promptInit = ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        export STARSHIP_CONFIG=${settingsFile}
        eval "$(${pkgs.starship}/bin/starship init bash)"
      fi
    '';

    programs.fish.promptInit = ''
      if test "$TERM" != "dumb" -a \( -z "$INSIDE_EMACS" -o "$INSIDE_EMACS" = "vterm" \)
        set -x STARSHIP_CONFIG ${settingsFile}
        eval (${pkgs.starship}/bin/starship init fish)
      end
    '';

    programs.zsh.promptInit = ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        export STARSHIP_CONFIG=${settingsFile}
        eval "$(${pkgs.starship}/bin/starship init zsh)"
      fi
    '';
  };

  meta.maintainers = pkgs.starship.meta.maintainers;
}
