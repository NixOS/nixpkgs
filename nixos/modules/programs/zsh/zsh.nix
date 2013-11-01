# This module defines global configuration for the zshell.

{ config, pkgs, ... }:

with pkgs.lib;

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
          Whenever to configure Zsh as an interactive shell.
          Note that this tries to make Zsh the default
          <option>users.defaultUserShell</option>,
          which in turn means that you might need to explicitly
          set this variable if you have another shell configured
          with NixOS.
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
        ${cfge.interactiveShellInit}

        ${cfg.promptInit}
        ${zshAliases}

        # Some sane history defaults
        export SAVEHIST=2000
        export HISTSIZE=2000
        export HISTFILE=$HOME/.zsh_history

        setopt HIST_IGNORE_DUPS SHARE_HISTORY
      '';

    };

    environment.etc."zshenv".text =
      ''
        # /etc/zshenv: DO NOT EDIT -- this file has been generated automatically.
        # This file is read for all shells.

        # Only execute this file once per shell.
        if [ -n "$__ETC_ZSHENV_SOURCED" ]; then return; fi
        __ETC_ZSHENV_SOURCED=1

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

    environment.systemPackages = [ pkgs.zsh ];

    users.defaultUserShell = mkDefault "/run/current-system/sw/bin/zsh";

    environment.shells =
      [ "/run/current-system/sw/bin/zsh"
        "/var/run/current-system/sw/bin/zsh"
        "${pkgs.zsh}/bin/zsh"
      ];

  };

}
