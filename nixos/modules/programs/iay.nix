{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.iay;
in
{
  options.programs.iay = {
    enable = lib.mkEnableOption "iay, a minimalistic shell prompt";
    package = lib.mkPackageOption pkgs "iay" { };

    minimalPrompt = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use minimal one-liner prompt.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.bash.promptInit = ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        PS1='$(iay ${lib.optionalString cfg.minimalPrompt "-m"})'
      fi
    '';

    programs.zsh.promptInit = ''
      if [[ $TERM != "dumb" && (-z $INSIDE_EMACS || $INSIDE_EMACS == "vterm") ]]; then
        autoload -Uz add-zsh-hook
        _iay_prompt() {
          PROMPT="$(iay -z ${lib.optionalString cfg.minimalPrompt "-m"})"
        }
        add-zsh-hook precmd _iay_prompt
      fi
    '';
  };

  meta.maintainers = pkgs.iay.meta.maintainers;
}
