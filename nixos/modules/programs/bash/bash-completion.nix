{ config, lib, pkgs, ... }:

let
  cfg = config.programs.bash;
in
{
  options.programs.bash = {
    enableCompletion = lib.mkEnableOption (lib.mdDoc "Bash completion for all interactive bash shells") // {
      default = true;
    };

    completionPackage = lib.mkPackageOption pkgs "bash-completion" { };
  };

  config = lib.mkIf cfg.enableCompletion {
    programs.bash.promptPluginInit = ''
      # Check whether we're running a version of Bash that has support for
      # programmable completion. If we do, enable all modules installed in
      # the system and user profile in obsolete /etc/bash_completion.d/
      # directories. Bash loads completions in all
      # $XDG_DATA_DIRS/bash-completion/completions/
      # on demand, so they do not need to be sourced here.
      if shopt -q progcomp &>/dev/null; then
        . "${cfg.completionPackage}/etc/profile.d/bash_completion.sh"
        nullglobStatus=$(shopt -p nullglob)
        shopt -s nullglob
        for p in $NIX_PROFILES; do
          for m in "$p/etc/bash_completion.d/"*; do
            . "$m"
          done
        done
        eval "$nullglobStatus"
        unset nullglobStatus p m
      fi
    '';
  };
}
