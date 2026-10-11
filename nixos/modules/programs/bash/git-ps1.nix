{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.bash;
in
{
  options.programs.bash.gitPS1 = {
    enable = lib.mkEnableOption "Git branch indication for all interactive bash shells' PS1";
    package =
      lib.mkPackageOption pkgs "git" {
        extraDescription = "Will default to the value of [](#opt-programs.git.package).";
      }
      // {
        default = config.programs.git.package;
      };
  };

  config = lib.mkIf cfg.gitPS1.enable {
    programs.bash.promptInit = lib.mkForce ''
      # Provide a nice prompt if the terminal supports it.
      if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        ((UID)) && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        else
          PS1='\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w$(source ${pkgs.git}/share/bash-completion/completions/git-prompt.sh; __git_ps1 " (%s)")]\\$\[\033[0m\] '
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    '';
  };

  meta.maintainers = with lib.maintainers; [ yiyu ];
}
