{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.programs.starship;

in {
  meta.maintainers = [ maintainers.imalison ];

  options.programs.starship = {
    enable = mkEnableOption "starship";

    package = mkOption {
      type = types.package;
      default = pkgs.starship;
      defaultText = literalExample "pkgs.starship";
      description = "The package to use for the starship binary.";
    };

    enableBashIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Bash integration.
      '';
    };

    enableZshIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Zsh integration.
      '';
    };

    enableFishIntegration = mkOption {
      default = true;
      type = types.bool;
      description = ''
        Whether to enable Fish integration.
      '';
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    programs.bash.promptInit = mkIf cfg.enableBashIntegration ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm" || ''${STARSHIP_INSIDE_EMACS-no} != "no") ]]; then
        eval "$(${cfg.package}/bin/starship init bash)"
      fi
    '';

    programs.zsh.promptInit = mkIf cfg.enableZshIntegration ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm" || ''${STARSHIP_INSIDE_EMACS-no} != "no") ]]; then
        eval "$(${cfg.package}/bin/starship init zsh)"
      fi
    '';
  };
}
