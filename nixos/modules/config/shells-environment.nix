# This module defines a global environment configuration and
# a common configuration for all shells.

{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.environment;

in

{

  options = {

    environment.variables = mkOption {
      default = {};
      description = ''
        A set of environment variables used in the global environment.
        The value of each variable can be either a string or a list of
        strings.  The latter is concatenated, interspersed with colon
        characters.
      '';
      type = types.attrsOf (mkOptionType {
        name = "a string or a list of strings";
        merge = xs:
          if isList (head xs) then concatLists xs
          else if builtins.lessThan 1 (length xs) then abort "variable in ‘environment.variables’ has multiple values"
          else if !builtins.isString (head xs) then abort "variable in ‘environment.variables’ does not have a string value"
          else head xs;
      });
      apply = mapAttrs (n: v: if isList v then concatStringsSep ":" v else v);
    };

    environment.profiles = mkOption {
      default = [];
      description = ''
        A list of profiles used to setup the global environment.
      '';
      type = types.listOf types.string;
    };

    environment.profileVariables = mkOption {
      default = (p: {});
      description = ''
        A function which given a profile path should give back
        a set of environment variables for that profile.
      '';
      # !!! this should be of the following type:
      #type = types.functionTo (types.attrsOf (types.optionSet envVar));
      # and envVar should be changed to something more like environOpts.
      # Having unique `value' _or_ multiple `list' is much more useful
      # than just sticking everything together with ':' unconditionally.
      # Anyway, to have this type mentioned above
      # types.optionSet needs to be transformed into a type constructor
      # (it has a !!! mark on that in nixpkgs)
      # for now we hack all this to be
      type = types.functionTo (types.attrsOf (types.listOf types.string));
    };

    # !!! isn't there a better way?
    environment.extraInit = mkOption {
      default = "";
      description = ''
        Shell script code called during global environment initialisation
        after all variables and profileVariables have been set.
        This code is asumed to be shell-independent, which means you should
        stick to pure sh without sh word split.
      '';
      type = types.lines;
    };

    environment.shellInit = mkOption {
      default = "";
      description = ''
        Shell script code called during shell initialisation.
        This code is asumed to be shell-independent, which means you should
        stick to pure sh without sh word split.
      '';
      type = types.lines;
    };

    environment.loginShellInit = mkOption {
      default = "";
      description = ''
        Shell script code called during login shell initialisation.
        This code is asumed to be shell-independent, which means you should
        stick to pure sh without sh word split.
      '';
      type = types.lines;
    };

    environment.interactiveShellInit = mkOption {
      default = "";
      description = ''
        Shell script code called during interactive shell initialisation.
        This code is asumed to be shell-independent, which means you should
        stick to pure sh without sh word split.
      '';
      type = types.lines;
    };

    environment.shellAliases = mkOption {
      default = {};
      example = { ll = "ls -l"; };
      description = ''
        An attribute set that maps aliases (the top level attribute names in
        this option) to command strings or directly to build outputs. The
        aliases are added to all users' shells.
      '';
      type = types.attrs; # types.attrsOf types.stringOrPath;
    };

    environment.binsh = mkOption {
      default = "${config.system.build.binsh}/bin/sh";
      example = "\${pkgs.dash}/bin/dash";
      type = types.path;
      description = ''
        The shell executable that is linked system-wide to
        <literal>/bin/sh</literal>. Please note that NixOS assumes all
        over the place that shell to be Bash, so override the default
        setting only if you know exactly what you're doing.
      '';
    };

    environment.shells = mkOption {
      default = [];
      example = [ "/run/current-system/sw/bin/zsh" ];
      description = ''
        A list of permissible login shells for user accounts.
        No need to mention <literal>/bin/sh</literal>
        here, it is placed into this list implicitly.
      '';
      type = types.listOf types.path;
    };

  };

  config = {

    system.build.binsh = pkgs.bashInteractive;

    environment.etc."shells".text =
      ''
        ${concatStringsSep "\n" cfg.shells}
        /bin/sh
      '';

    system.build.setEnvironment = pkgs.writeText "set-environment"
       ''
         ${concatStringsSep "\n" (
           (mapAttrsToList (n: v: ''export ${n}="${concatStringsSep ":" v}"'')
             # This line is a kind of a hack because of !!! note above
             (zipAttrsWith (const concatLists) ([ (mapAttrs (n: v: [ v ]) cfg.variables) ] ++ map cfg.profileVariables cfg.profiles))))}

         ${cfg.extraInit}

         # The setuid wrappers override other bin directories.
         export PATH="${config.security.wrapperDir}:$PATH"

         # ~/bin if it exists overrides other bin directories.
         export PATH="$HOME/bin:$PATH"
       '';

    system.activationScripts.binsh = stringAfter [ "stdio" ]
      ''
        # Create the required /bin/sh symlink; otherwise lots of things
        # (notably the system() function) won't work.
        mkdir -m 0755 -p /bin
        ln -sfn "${cfg.binsh}" /bin/.sh.tmp
        mv /bin/.sh.tmp /bin/sh # atomically replace /bin/sh
      '';

  };

}
