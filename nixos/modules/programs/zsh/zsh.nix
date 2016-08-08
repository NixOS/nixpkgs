# This module defines global configuration for the zshell.

{ config, lib, pkgs, ... }:

with lib;

let

  cfge = config.environment;

  cfg = config.programs.zsh;

  zshAliases = concatStringsSep "\n" (
    mapAttrsFlatten (k: v: "alias ${k}='${v}'") cfg.shellAliases
  );

in

{

  options = {

    programs.zsh = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to configure zsh as an interactive shell.
        '';
        type = types.bool;
      };

      shellAliases = mkOption {
        default = config.environment.shellAliases;
        description = ''
          Set of aliases for zsh shell. See <option>environment.shellAliases</option>
          for an option format description.
        '';
        type = types.attrs; # types.attrsOf types.stringOrPath;
      };

      shellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during zsh shell initialisation.
        '';
        type = types.lines;
      };

      loginShellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during zsh login shell initialisation.
        '';
        type = types.lines;
      };

      interactiveShellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during interactive zsh shell initialisation.
        '';
        type = types.lines;
      };

      promptInit = mkOption {
        default = ''
          autoload -U promptinit && promptinit && prompt walters
        '';
        description = ''
          Shell script code used to initialise the zsh prompt.
        '';
        type = types.lines;
      };

      enableCompletion = mkOption {
        default = true;
        description = ''
          Enable zsh completion for all interactive zsh shells.
        '';
        type = types.bool;
      };

    };

  };

  config = mkIf cfg.enable {

    programs.zsh = {

      shellInit = ''
        . ${config.system.build.setEnvironment}

        ${cfge.shellInit}
      '';

      loginShellInit = cfge.loginShellInit;

      interactiveShellInit = ''
        # history defaults
        export SAVEHIST=2000
        export HISTSIZE=2000
        export HISTFILE=$HOME/.zsh_history

        setopt HIST_IGNORE_DUPS SHARE_HISTORY HIST_FCNTL_LOCK

        ${cfge.interactiveShellInit}

        ${cfg.promptInit}
        ${zshAliases}

        # Tell zsh how to find installed completions
        for p in ''${(z)NIX_PROFILES}; do
          fpath+=($p/share/zsh/site-functions $p/share/zsh/$ZSH_VERSION/functions)
        done

        ${if cfg.enableCompletion then "autoload -U compinit && compinit" else ""}

        HELPDIR="${pkgs.zsh}/share/zsh/$ZSH_VERSION/help"
      '';

    };

    environment.etc."zshenv".text =
      ''
        # /etc/zshenv: DO NOT EDIT -- this file has been generated automatically.
        # This file is read for all shells.

        # Only execute this file once per shell.
        # But don't clobber the environment of interactive non-login children!
        if [ -n "$__ETC_ZSHENV_SOURCED" ]; then return; fi
        export __ETC_ZSHENV_SOURCED=1

        ${cfg.shellInit}

        # Read system-wide modifications.
        if test -f /etc/zshenv.local; then
          . /etc/zshenv.local
        fi
      '';

    environment.etc."zprofile".text =
      ''
        # /etc/zprofile: DO NOT EDIT -- this file has been generated automatically.
        # This file is read for login shells.

        # Only execute this file once per shell.
        if [ -n "$__ETC_ZPROFILE_SOURCED" ]; then return; fi
        __ETC_ZPROFILE_SOURCED=1

        ${cfg.loginShellInit}

        # Read system-wide modifications.
        if test -f /etc/zprofile.local; then
          . /etc/zprofile.local
        fi
      '';

    environment.etc."zshrc".text =
      ''
        # /etc/zshrc: DO NOT EDIT -- this file has been generated automatically.
        # This file is read for interactive shells.

        # Only execute this file once per shell.
        if [ -n "$__ETC_ZSHRC_SOURCED" -o -n "$NOSYSZSHRC" ]; then return; fi
        __ETC_ZSHRC_SOURCED=1

        . /etc/zinputrc

        ${cfg.interactiveShellInit}

        # Read system-wide modifications.
        if test -f /etc/zshrc.local; then
          . /etc/zshrc.local
        fi
      '';

    environment.etc."zinputrc".source = ./zinputrc;

    environment.systemPackages = [ pkgs.zsh ]
      ++ optional cfg.enableCompletion pkgs.nix-zsh-completions;

    environment.pathsToLink = optional cfg.enableCompletion "/share/zsh";

    #users.defaultUserShell = mkDefault "/run/current-system/sw/bin/zsh";

    environment.shells =
      [ "/run/current-system/sw/bin/zsh"
        "/var/run/current-system/sw/bin/zsh"
        "${pkgs.zsh}/bin/zsh"
      ];

  };

}
