{ config, lib, pkgs, ... }:

let
  cfg = config.programs.iay;
  inherit (lib) mkEnableOption mkIf mkOption mkPackageOption optionalString types;
in {
  options.programs.iay = {
    enable = mkEnableOption (lib.mdDoc "iay");
    package = mkPackageOption pkgs "iay" {};

    minimalPrompt = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc "Use minimal one-liner prompt.";
    };
  };

  config = mkIf cfg.enable {
    programs.bash.promptInit = ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        PS1='$(iay ${optionalString cfg.minimalPrompt "-m"})'
      fi
    '';

    programs.zsh.promptInit = ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        autoload -Uz add-zsh-hook
        _iay_prompt() {
          PROMPT="$(iay -z ${optionalString cfg.minimalPrompt "-m"})"
        }
        add-zsh-hook precmd _iay_prompt
      fi
    '';
  };

  meta.maintainers = pkgs.iay.meta.maintainers;
}
