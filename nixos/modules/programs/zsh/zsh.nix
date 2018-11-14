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
          Whether to configure zsh as an interactive shell. To enable zsh for
          a particular user, use the <option>users.users.&lt;name?&gt;.shell</option>
          option for that user. To enable zsh system-wide use the
          <option>users.defaultUserShell</option> option.
        '';
        type = types.bool;
      };

      shellAliases = mkOption {
        default = config.environment.shellAliases;
        description = ''
          Set of aliases for zsh shell. Overrides the default value taken from
           <option>environment.shellAliases</option>.
          See <option>environment.shellAliases</option> for an option format description.
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
          if [ "$TERM" != dumb ]; then
              autoload -U promptinit && promptinit && prompt walters
          fi
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


      enableGlobalCompInit = mkOption {
        default = cfg.enableCompletion;
        description = ''
          Enable execution of compinit call for all interactive zsh shells.

          This option can be disabled if the user wants to extend its
          <literal>fpath</literal> and a custom <literal>compinit</literal>
          call in the local config is required.
        '';
        type = types.bool;
      };

    };

  };

  config = mkIf cfg.enable {

    environment.etc."zshenv".text =
      ''
        # /etc/zshenv: DO NOT EDIT -- this file has been generated automatically.
        # This file is read for all shells.

        # Only execute this file once per shell.
        # But don't clobber the environment of interactive non-login children!
        if [ -n "$__ETC_ZSHENV_SOURCED" ]; then return; fi
        export __ETC_ZSHENV_SOURCED=1

        if [ -z "$__NIXOS_SET_ENVIRONMENT_DONE" ]; then
            . ${config.system.build.setEnvironment}
        fi

        ${cfge.shellInit}

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

        ${cfge.loginShellInit}

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

        # history defaults
        SAVEHIST=2000
        HISTSIZE=2000
        HISTFILE=$HOME/.zsh_history

        setopt HIST_IGNORE_DUPS SHARE_HISTORY HIST_FCNTL_LOCK

        HELPDIR="${pkgs.zsh}/share/zsh/$ZSH_VERSION/help"

        # Tell zsh how to find installed completions
        for p in ''${(z)NIX_PROFILES}; do
            fpath+=($p/share/zsh/site-functions $p/share/zsh/$ZSH_VERSION/functions $p/share/zsh/vendor-completions)
        done

        ${optionalString cfg.enableGlobalCompInit "autoload -U compinit && compinit"}

        ${cfge.interactiveShellInit}

        ${cfg.interactiveShellInit}

        ${zshAliases}

        ${cfg.promptInit}

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
