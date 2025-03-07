# This module defines global configuration for the zshell.

{ config, lib, options, pkgs, ... }:

let

  cfge = config.environment;

  cfg = config.programs.zsh;
  opt = options.programs.zsh;

  zshAliases = builtins.concatStringsSep "\n" (
    lib.mapAttrsFlatten (k: v: "alias -- ${k}=${lib.escapeShellArg v}")
      (lib.filterAttrs (k: v: v != null) cfg.shellAliases)
  );

  zshStartupNotes = ''
    # Note that generated /etc/zprofile and /etc/zshrc files do a lot of
    # non-standard setup to make zsh usable with no configuration by default.
    #
    # Which means that unless you explicitly meticulously override everything
    # generated, interactions between your ~/.zshrc and these files are likely
    # to be rather surprising.
    #
    # Note however, that you can disable loading of the generated /etc/zprofile
    # and /etc/zshrc (you can't disable loading of /etc/zshenv, but it is
    # designed to not set anything surprising) by setting `no_global_rcs` option
    # in ~/.zshenv:
    #
    #   echo setopt no_global_rcs >> ~/.zshenv
    #
    # See "STARTUP/SHUTDOWN FILES" section of zsh(1) for more info.
  '';

in

{

  options = {

    programs.zsh = {

      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to configure zsh as an interactive shell. To enable zsh for
          a particular user, use the {option}`users.users.<name?>.shell`
          option for that user. To enable zsh system-wide use the
          {option}`users.defaultUserShell` option.
        '';
        type = lib.types.bool;
      };

      shellAliases = lib.mkOption {
        default = { };
        description = ''
          Set of aliases for zsh shell, which overrides {option}`environment.shellAliases`.
          See {option}`environment.shellAliases` for an option format description.
        '';
        type = with lib.types; attrsOf (nullOr (either str path));
      };

      shellInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code called during zsh shell initialisation.
        '';
        type = lib.types.lines;
      };

      loginShellInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code called during zsh login shell initialisation.
        '';
        type = lib.types.lines;
      };

      interactiveShellInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code called during interactive zsh shell initialisation.
        '';
        type = lib.types.lines;
      };

      promptInit = lib.mkOption {
        default = ''
          # Note that to manually override this in ~/.zshrc you should run `prompt off`
          # before setting your PS1 and etc. Otherwise this will likely to interact with
          # your ~/.zshrc configuration in unexpected ways as the default prompt sets
          # a lot of different prompt variables.
          autoload -U promptinit && promptinit && prompt suse && setopt prompt_sp
        '';
        description = ''
          Shell script code used to initialise the zsh prompt.
        '';
        type = lib.types.lines;
      };

      histSize = lib.mkOption {
        default = 2000;
        description = ''
          Change history size.
        '';
        type = lib.types.int;
      };

      histFile = lib.mkOption {
        default = "$HOME/.zsh_history";
        description = ''
          Change history file.
        '';
        type = lib.types.str;
      };

      setOptions = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "HIST_IGNORE_DUPS"
          "SHARE_HISTORY"
          "HIST_FCNTL_LOCK"
        ];
        example = [ "EXTENDED_HISTORY" "RM_STAR_WAIT" ];
        description = ''
          Configure zsh options. See
          {manpage}`zshoptions(1)`.
        '';
      };

      enableCompletion = lib.mkOption {
        default = true;
        description = ''
          Enable zsh completion for all interactive zsh shells.
        '';
        type = lib.types.bool;
      };

      enableBashCompletion = lib.mkOption {
        default = false;
        description = ''
          Enable compatibility with bash's programmable completion system.
        '';
        type = lib.types.bool;
      };

      enableGlobalCompInit = lib.mkOption {
        default = cfg.enableCompletion;
        defaultText = lib.literalExpression "config.${opt.enableCompletion}";
        description = ''
          Enable execution of compinit call for all interactive zsh shells.

          This option can be disabled if the user wants to extend its
          `fpath` and a custom `compinit`
          call in the local config is required.
        '';
        type = lib.types.bool;
      };

      enableLsColors = lib.mkOption {
        default = true;
        description = ''
          Enable extra colors in directory listings (used by `ls` and `tree`).
        '';
        type = lib.types.bool;
      };

    };

  };

  config = lib.mkIf cfg.enable {

    programs.zsh.shellAliases = builtins.mapAttrs (name: lib.mkDefault) cfge.shellAliases;

    environment.etc.zshenv.text =
      ''
        # /etc/zshenv: DO NOT EDIT -- this file has been generated automatically.
        # This file is read for all shells.

        # Only execute this file once per shell.
        if [ -n "''${__ETC_ZSHENV_SOURCED-}" ]; then return; fi
        __ETC_ZSHENV_SOURCED=1

        if [ -z "''${__NIXOS_SET_ENVIRONMENT_DONE-}" ]; then
            . ${config.system.build.setEnvironment}
        fi

        HELPDIR="${pkgs.zsh}/share/zsh/$ZSH_VERSION/help"

        # Tell zsh how to find installed completions.
        for p in ''${(z)NIX_PROFILES}; do
            fpath=($p/share/zsh/site-functions $p/share/zsh/$ZSH_VERSION/functions $p/share/zsh/vendor-completions $fpath)
        done

        # Setup custom shell init stuff.
        ${cfge.shellInit}

        ${cfg.shellInit}

        # Read system-wide modifications.
        if test -f /etc/zshenv.local; then
            . /etc/zshenv.local
        fi
      '';

    environment.etc.zprofile.text =
      ''
        # /etc/zprofile: DO NOT EDIT -- this file has been generated automatically.
        # This file is read for login shells.
        #
        ${zshStartupNotes}

        # Only execute this file once per shell.
        if [ -n "''${__ETC_ZPROFILE_SOURCED-}" ]; then return; fi
        __ETC_ZPROFILE_SOURCED=1

        # Setup custom login shell init stuff.
        ${cfge.loginShellInit}

        ${cfg.loginShellInit}

        # Read system-wide modifications.
        if test -f /etc/zprofile.local; then
            . /etc/zprofile.local
        fi
      '';

    environment.etc.zshrc.text =
      ''
        # /etc/zshrc: DO NOT EDIT -- this file has been generated automatically.
        # This file is read for interactive shells.
        #
        ${zshStartupNotes}

        # Only execute this file once per shell.
        if [ -n "$__ETC_ZSHRC_SOURCED" -o -n "$NOSYSZSHRC" ]; then return; fi
        __ETC_ZSHRC_SOURCED=1

        ${lib.optionalString (cfg.setOptions != []) ''
          # Set zsh options.
          setopt ${builtins.concatStringsSep " " cfg.setOptions}
        ''}

        # Alternative method of determining short and full hostname.
        HOST=${config.networking.fqdnOrHostName}

        # Setup command line history.
        # Don't export these, otherwise other shells (bash) will try to use same HISTFILE.
        SAVEHIST=${builtins.toString cfg.histSize}
        HISTSIZE=${builtins.toString cfg.histSize}
        HISTFILE=${cfg.histFile}

        # Configure sane keyboard defaults.
        . /etc/zinputrc

        ${lib.optionalString cfg.enableGlobalCompInit ''
          # Enable autocompletion.
          autoload -U compinit && compinit
        ''}

        ${lib.optionalString cfg.enableBashCompletion ''
          # Enable compatibility with bash's completion system.
          autoload -U bashcompinit && bashcompinit
        ''}

        # Setup custom interactive shell init stuff.
        ${cfge.interactiveShellInit}

        ${cfg.interactiveShellInit}

        ${lib.optionalString cfg.enableLsColors ''
          # Extra colors for directory listings.
          eval "$(${pkgs.coreutils}/bin/dircolors -b)"
        ''}

        # Setup aliases.
        ${zshAliases}

        # Setup prompt.
        ${cfg.promptInit}

        # Disable some features to support TRAMP.
        if [ "$TERM" = dumb ]; then
            unsetopt zle prompt_cr prompt_subst
            unset RPS1 RPROMPT
            PS1='$ '
            PROMPT='$ '
        fi

        # Read system-wide modifications.
        if test -f /etc/zshrc.local; then
            . /etc/zshrc.local
        fi
      '';

    # Bug in nix flakes:
    # If we use `.source` here the path is garbage collected also we point to it with a symlink
    # see https://github.com/NixOS/nixpkgs/issues/132732
    environment.etc.zinputrc.text = builtins.readFile ./zinputrc;

    environment.systemPackages = [ pkgs.zsh ]
      ++ lib.optional cfg.enableCompletion pkgs.nix-zsh-completions;

    environment.pathsToLink = lib.optional cfg.enableCompletion "/share/zsh";

    #users.defaultUserShell = lib.mkDefault "/run/current-system/sw/bin/zsh";

    environment.shells =
      [
        "/run/current-system/sw/bin/zsh"
        "${pkgs.zsh}/bin/zsh"
      ];

  };

}
