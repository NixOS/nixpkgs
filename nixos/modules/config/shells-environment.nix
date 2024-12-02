# This module defines a global environment configuration and
# a common configuration for all shells.
{ config, lib, utils, pkgs, ... }:
let

  cfg = config.environment;

  exportedEnvVars =
    let
      absoluteVariables =
        lib.mapAttrs (n: lib.toList) cfg.variables;

      suffixedVariables =
        lib.flip lib.mapAttrs cfg.profileRelativeEnvVars (envVar: listSuffixes:
          lib.concatMap (profile: map (suffix: "${profile}${suffix}") listSuffixes) cfg.profiles
        );

      allVariables =
        lib.zipAttrsWith (n: lib.concatLists) [ absoluteVariables suffixedVariables ];

      exportVariables =
        lib.mapAttrsToList (n: v: ''export ${n}="${lib.concatStringsSep ":" v}"'') allVariables;
    in
      lib.concatStringsSep "\n" exportVariables;
in

{

  options = {

    environment.variables = lib.mkOption {
      default = {};
      example = { EDITOR = "nvim"; VISUAL = "nvim"; };
      description = ''
        A set of environment variables used in the global environment.
        These variables will be set on shell initialisation (e.g. in /etc/profile).
        The value of each variable can be either a string or a list of
        strings.  The latter is concatenated, interspersed with colon
        characters.
      '';
      type = with lib.types; attrsOf (oneOf [ (listOf (oneOf [ int str path ])) int str path ]);
      apply = let
        toStr = v: if lib.isPath v then "${v}" else toString v;
      in lib.mapAttrs (n: v: if lib.isList v then lib.concatMapStringsSep ":" toStr v else toStr v);
    };

    environment.profiles = lib.mkOption {
      default = [];
      description = ''
        A list of profiles used to setup the global environment.
      '';
      type = lib.types.listOf lib.types.str;
    };

    environment.profileRelativeEnvVars = lib.mkOption {
      type = lib.types.attrsOf (lib.types.listOf lib.types.str);
      example = { PATH = [ "/bin" ]; MANPATH = [ "/man" "/share/man" ]; };
      description = ''
        Attribute set of environment variable.  Each attribute maps to a list
        of relative paths.  Each relative path is appended to the each profile
        of {option}`environment.profiles` to form the content of the
        corresponding environment variable.
      '';
    };

    # !!! isn't there a better way?
    environment.extraInit = lib.mkOption {
      default = "";
      description = ''
        Shell script code called during global environment initialisation
        after all variables and profileVariables have been set.
        This code is assumed to be shell-independent, which means you should
        stick to pure sh without sh word split.
      '';
      type = lib.types.lines;
    };

    environment.shellInit = lib.mkOption {
      default = "";
      description = ''
        Shell script code called during shell initialisation.
        This code is assumed to be shell-independent, which means you should
        stick to pure sh without sh word split.
      '';
      type = lib.types.lines;
    };

    environment.loginShellInit = lib.mkOption {
      default = "";
      description = ''
        Shell script code called during login shell initialisation.
        This code is assumed to be shell-independent, which means you should
        stick to pure sh without sh word split.
      '';
      type = lib.types.lines;
    };

    environment.interactiveShellInit = lib.mkOption {
      default = "";
      description = ''
        Shell script code called during interactive shell initialisation.
        This code is assumed to be shell-independent, which means you should
        stick to pure sh without sh word split.
      '';
      type = lib.types.lines;
    };

    environment.shellAliases = lib.mkOption {
      example = { l = null; ll = "ls -l"; };
      description = ''
        An attribute set that maps aliases (the top level attribute names in
        this option) to command strings or directly to build outputs. The
        aliases are added to all users' shells.
        Aliases mapped to `null` are ignored.
      '';
      type = with lib.types; attrsOf (nullOr (either str path));
    };

    environment.homeBinInPath = lib.mkOption {
      description = ''
        Include ~/bin/ in $PATH.
      '';
      default = false;
      type = lib.types.bool;
    };

    environment.localBinInPath = lib.mkOption {
      description = ''
        Add ~/.local/bin/ to $PATH
      '';
      default = false;
      type = lib.types.bool;
    };

    environment.binsh = lib.mkOption {
      default = "${config.system.build.binsh}/bin/sh";
      defaultText = lib.literalExpression ''"''${config.system.build.binsh}/bin/sh"'';
      example = lib.literalExpression ''"''${pkgs.dash}/bin/dash"'';
      type = lib.types.path;
      visible = false;
      description = ''
        The shell executable that is linked system-wide to
        `/bin/sh`. Please note that NixOS assumes all
        over the place that shell to be Bash, so override the default
        setting only if you know exactly what you're doing.
      '';
    };

    environment.shells = lib.mkOption {
      default = [];
      example = lib.literalExpression "[ pkgs.bashInteractive pkgs.zsh ]";
      description = ''
        A list of permissible login shells for user accounts.
        No need to mention `/bin/sh`
        here, it is placed into this list implicitly.
      '';
      type = lib.types.listOf (lib.types.either lib.types.shellPackage lib.types.path);
    };

  };

  config = {

    system.build.binsh = pkgs.bashInteractive;

    # Set session variables in the shell as well. This is usually
    # unnecessary, but it allows changes to session variables to take
    # effect without restarting the session (e.g. by opening a new
    # terminal instead of logging out of X11).
    environment.variables = config.environment.sessionVariables;

    environment.profileRelativeEnvVars = config.environment.profileRelativeSessionVariables;

    environment.shellAliases = lib.mapAttrs (name: lib.mkDefault) {
      ls = "ls --color=tty";
      ll = "ls -l";
      l  = "ls -alh";
    };

    environment.etc.shells.text =
      ''
        ${lib.concatStringsSep "\n" (map utils.toShellPath cfg.shells)}
        /bin/sh
      '';

    # For resetting environment with `. /etc/set-environment` when needed
    # and discoverability (see motivation of #30418).
    environment.etc.set-environment.source = config.system.build.setEnvironment;

    system.build.setEnvironment = pkgs.writeText "set-environment"
      ''
        # DO NOT EDIT -- this file has been generated automatically.

        # Prevent this file from being sourced by child shells.
        export __NIXOS_SET_ENVIRONMENT_DONE=1

        ${exportedEnvVars}

        ${cfg.extraInit}

        ${lib.optionalString cfg.homeBinInPath ''
          # ~/bin if it exists overrides other bin directories.
          export PATH="$HOME/bin:$PATH"
        ''}

        ${lib.optionalString cfg.localBinInPath ''
          export PATH="$HOME/.local/bin:$PATH"
        ''}
      '';

    system.activationScripts.binsh = lib.stringAfter [ "stdio" ]
      ''
        # Create the required /bin/sh symlink; otherwise lots of things
        # (notably the system() function) won't work.
        mkdir -p /bin
        chmod 0755 /bin
        ln -sfn "${cfg.binsh}" /bin/.sh.tmp
        mv /bin/.sh.tmp /bin/sh # atomically replace /bin/sh
      '';

  };

}
