# This module defines global configuration for the Bash shell, in
# particular /etc/bashrc and /etc/profile.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.environment;

  initBashCompletion = optionalString cfg.enableBashCompletion ''
    # Check whether we're running a version of Bash that has support for
    # programmable completion. If we do, enable all modules installed in
    # the system (and user profile).
    if shopt -q progcomp &>/dev/null; then
      . "${pkgs.bashCompletion}/etc/profile.d/bash_completion.sh"
      nullglobStatus=$(shopt -p nullglob)
      shopt -s nullglob
      for p in $NIX_PROFILES; do
        for m in "$p/etc/bash_completion.d/"* "$p/share/bash-completion/completions/"*; do
          . $m
        done
      done
      eval "$nullglobStatus"
      unset nullglobStatus p m
    fi
  '';

  shellAliases = concatStringsSep "\n" (
    mapAttrsFlatten (k: v: "alias ${k}='${v}'") cfg.shellAliases
  );

in

{
  options = {

    environment.promptInit = mkOption {
      default = ''
        # Provide a nice prompt.
        PROMPT_COLOR="1;31m"
        let $UID && PROMPT_COLOR="1;32m"
        PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      '';
      description = ''
        Shell script code used to initialise the shell prompt.
      '';
      type = types.lines;
    };

    environment.shellInit = mkOption {
      default = "";
      example = ''export PATH=/godi/bin/:$PATH'';
      description = ''
        Shell script code called during login shell initialisation.
      '';
      type = types.lines;
    };

    environment.interactiveShellInit = mkOption {
      default = "";
      example = ''export PATH=/godi/bin/:$PATH'';
      description = ''
        Shell script code called during interactive shell initialisation.
      '';
      type = types.lines;
    };

    environment.enableBashCompletion = mkOption {
      default = false;
      description = "Enable Bash completion for all interactive shells.";
      type = types.bool;
    };

    environment.binsh = mkOption {
      default = "${config.system.build.binsh}/bin/sh";
      example = "\${pkgs.dash}/bin/dash";
      type = types.path;
      description = ''
        Select the shell executable that is linked system-wide to
        <literal>/bin/sh</literal>. Please note that NixOS assumes all
        over the place that shell to be Bash, so override the default
        setting only if you know exactly what you're doing.
      '';
    };

  };


  config = {

    # Script executed when the shell starts as a login shell.
    environment.etc."profile".source =
      pkgs.substituteAll {
        src = ./profile.sh;
        wrapperDir = config.security.wrapperDir;
        inherit (cfg) shellInit;
      };

    # /etc/bashrc: executed every time an interactive bash
    # starts. Sources /etc/profile to ensure that the system
    # environment is configured properly.
    environment.etc."bashrc".source =
      pkgs.substituteAll {
        src = ./bashrc.sh;
        inherit (cfg) interactiveShellInit;
      };

    # Configuration for readline in bash.
    environment.etc."inputrc".source = ./inputrc;

    environment.shellAliases =
      { ls = "ls --color=tty";
        ll = "ls -l";
        l = "ls -alh";
        which = "type -P";
      };

    environment.interactiveShellInit =
      ''
        # Check the window size after every command.
        shopt -s checkwinsize

        ${cfg.promptInit}
        ${initBashCompletion}
        ${shellAliases}

        # Disable hashing (i.e. caching) of command lookups.
        set +h
      '';

    system.build.binsh = pkgs.bashInteractive;

    system.activationScripts.binsh = stringAfter [ "stdio" ]
      ''
        # Create the required /bin/sh symlink; otherwise lots of things
        # (notably the system() function) won't work.
        mkdir -m 0755 -p /bin
        ln -sfn "${cfg.binsh}" /bin/.sh.tmp
        mv /bin/.sh.tmp /bin/sh # atomically replace /bin/sh
      '';

    environment.pathsToLink = optionals cfg.enableBashCompletion [
      "/etc/bash_completion.d"
      "/share/bash-completion"
    ];

  };

}
