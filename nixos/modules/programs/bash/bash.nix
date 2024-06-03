# This module defines global configuration for the Bash shell, in
# particular /etc/bashrc and /etc/profile.

{ config, lib, pkgs, ... }:

let

  cfge = config.environment;

  cfg = config.programs.bash;

  bashAliases = builtins.concatStringsSep "\n" (
    lib.mapAttrsFlatten (k: v: "alias -- ${k}=${lib.escapeShellArg v}")
      (lib.filterAttrs (k: v: v != null) cfg.shellAliases)
  );

in

{
  imports = [
    (lib.mkRemovedOptionModule [ "programs" "bash" "enable" ] "")
  ];

  options = {

    programs.bash = {

      /*
      enable = lib.mkOption {
        default = true;
        description = ''
          Whenever to configure Bash as an interactive shell.
          Note that this tries to make Bash the default
          {option}`users.defaultUserShell`,
          which in turn means that you might need to explicitly
          set this variable if you have another shell configured
          with NixOS.
        '';
        type = lib.types.bool;
      };
      */

      shellAliases = lib.mkOption {
        default = {};
        description = ''
          Set of aliases for bash shell, which overrides {option}`environment.shellAliases`.
          See {option}`environment.shellAliases` for an option format description.
        '';
        type = with lib.types; attrsOf (nullOr (either str path));
      };

      shellInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code called during bash shell initialisation.
        '';
        type = lib.types.lines;
      };

      loginShellInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code called during login bash shell initialisation.
        '';
        type = lib.types.lines;
      };

      interactiveShellInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code called during interactive bash shell initialisation.
        '';
        type = lib.types.lines;
      };

      promptInit = lib.mkOption {
        default = ''
          # Provide a nice prompt if the terminal supports it.
          if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
            PROMPT_COLOR="1;31m"
            ((UID)) && PROMPT_COLOR="1;32m"
            if [ -n "$INSIDE_EMACS" ]; then
              # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
              PS1="\n\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
            else
              PS1="\n\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
            fi
            if test "$TERM" = "xterm"; then
              PS1="\[\033]2;\h:\u:\w\007\]$PS1"
            fi
          fi
        '';
        description = ''
          Shell script code used to initialise the bash prompt.
        '';
        type = lib.types.lines;
      };

      promptPluginInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code used to initialise bash prompt plugins.
        '';
        type = lib.types.lines;
        internal = true;
      };

    };

  };

  config = /* lib.mkIf cfg.enable */ {

    programs.bash = {

      shellAliases = builtins.mapAttrs (name: lib.mkDefault) cfge.shellAliases;

      shellInit = ''
        if [ -z "$__NIXOS_SET_ENVIRONMENT_DONE" ]; then
            . ${config.system.build.setEnvironment}
        fi

        ${cfge.shellInit}
      '';

      loginShellInit = cfge.loginShellInit;

      interactiveShellInit = ''
        # Check the window size after every command.
        shopt -s checkwinsize

        # Disable hashing (i.e. caching) of command lookups.
        set +h

        ${cfg.promptInit}
        ${cfg.promptPluginInit}
        ${bashAliases}

        ${cfge.interactiveShellInit}
      '';

    };

    environment.etc.profile.text =
      ''
        # /etc/profile: DO NOT EDIT -- this file has been generated automatically.
        # This file is read for login shells.

        # Only execute this file once per shell.
        if [ -n "$__ETC_PROFILE_SOURCED" ]; then return; fi
        __ETC_PROFILE_SOURCED=1

        # Prevent this file from being sourced by interactive non-login child shells.
        export __ETC_PROFILE_DONE=1

        ${cfg.shellInit}
        ${cfg.loginShellInit}

        # Read system-wide modifications.
        if test -f /etc/profile.local; then
            . /etc/profile.local
        fi

        if [ -n "''${BASH_VERSION:-}" ]; then
            . /etc/bashrc
        fi
      '';

    environment.etc.bashrc.text =
      ''
        # /etc/bashrc: DO NOT EDIT -- this file has been generated automatically.

        # Only execute this file once per shell.
        if [ -n "$__ETC_BASHRC_SOURCED" ] || [ -n "$NOSYSBASHRC" ]; then return; fi
        __ETC_BASHRC_SOURCED=1

        # If the profile was not loaded in a parent process, source
        # it.  But otherwise don't do it because we don't want to
        # clobber overridden values of $PATH, etc.
        if [ -z "$__ETC_PROFILE_DONE" ]; then
            . /etc/profile
        fi

        # We are not always an interactive shell.
        if [ -n "$PS1" ]; then
            ${cfg.interactiveShellInit}
        fi

        # Read system-wide modifications.
        if test -f /etc/bashrc.local; then
            . /etc/bashrc.local
        fi
      '';

    # Configuration for readline in bash. We use "option default"
    # priority to allow user override using both .text and .source.
    environment.etc.inputrc.source = lib.mkOptionDefault ./inputrc;

    users.defaultUserShell = lib.mkDefault pkgs.bashInteractive;

    environment.pathsToLink = lib.optionals cfg.enableCompletion [
      "/etc/bash_completion.d"
      "/share/bash-completion"
    ];

    environment.shells =
      [ "/run/current-system/sw/bin/bash"
        "/run/current-system/sw/bin/sh"
        "${pkgs.bashInteractive}/bin/bash"
        "${pkgs.bashInteractive}/bin/sh"
      ];

  };

}
