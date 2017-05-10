{ config, lib, pkgs, ... }:

with lib;

let

  cfge = config.environment;

  cfg = config.programs.fish;

  fishAliases = concatStringsSep "\n" (
    mapAttrsFlatten (k: v: "alias ${k} '${v}'") cfg.shellAliases
  );

in

{

  options = {

    programs.fish = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to configure fish as an interactive shell.
        '';
        type = types.bool;
      };
      
      vendor.config.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether fish should source configuration snippets provided by other packages.
        '';
      };

      vendor.completions.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether fish should use completion files provided by other packages.
        '';
      };
      
      vendor.functions.enable = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether fish should autoload fish functions provided by other packages.
        '';
      };

      shellAliases = mkOption {
        default = config.environment.shellAliases;
        description = ''
          Set of aliases for fish shell. See <option>environment.shellAliases</option>
          for an option format description.
        '';
        type = types.attrs;
      };

      shellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during fish shell initialisation.
        '';
        type = types.lines;
      };

      loginShellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during fish login shell initialisation.
        '';
        type = types.lines;
      };

      interactiveShellInit = mkOption {
        default = "";
        description = ''
          Shell script code called during interactive fish shell initialisation.
        '';
        type = types.lines;
      };

      promptInit = mkOption {
        default = "";
        description = ''
          Shell script code used to initialise fish prompt.
        '';
        type = types.lines;
      };

    };

  };

  config = mkIf cfg.enable {

    environment.etc."fish/foreign-env/shellInit".text = cfge.shellInit;
    environment.etc."fish/foreign-env/loginShellInit".text = cfge.loginShellInit;
    environment.etc."fish/foreign-env/interactiveShellInit".text = cfge.interactiveShellInit;

    environment.etc."fish/nixos-env-preinit.fish".text = ''
      # avoid clobbering the environment if it's been set by a parent shell

      # This happens before $__fish_datadir/config.fish sets fish_function_path, so it is currently
      # unset. We set it and then completely erase it, leaving its configuration to $__fish_datadir/config.fish
      set fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions $__fish_datadir/functions
      
      # source the NixOS environment config
      fenv source ${config.system.build.setEnvironment}

      # clear fish_function_path so that it will be correctly set when we return to $__fish_datadir/config.fish
      set -e fish_function_path
    '';

    environment.etc."fish/config.fish".text = ''
      # /etc/fish/config.fish: DO NOT EDIT -- this file has been generated automatically.

      # if our parent shell didn't source the general config, do it
      if not set -q __fish_nixos_general_config_sourced
        set fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions $fish_function_path
        fenv source /etc/fish/foreign-env/shellInit > /dev/null
        set -e fish_function_path[1]
        
        ${cfg.shellInit}

        # and leave a note to our children to spare them the same work
        set -gx __fish_nixos_general_config_sourced 1
      end

      # if our parent shell didn't source the login config, do it
      status --is-login; and not set -q __fish_nixos_login_config_sourced
      and begin
        set fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions $fish_function_path
        fenv source /etc/fish/foreign-env/loginShellInit > /dev/null
        set -e fish_function_path[1]
        
        ${cfg.loginShellInit}

        # and leave a note to our children to spare them the same work
        set -gx __fish_nixos_login_config_sourced 1
      end

      # if our parent shell didn't source the interactive config, do it
      status --is-interactive; and not set -q __fish_nixos_interactive_config_sourced
      and begin
        ${fishAliases}
        

        set fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions $fish_function_path
        fenv source /etc/fish/foreign-env/interactiveShellInit > /dev/null
        set -e fish_function_path[1]
        
        ${cfg.promptInit}
        ${cfg.interactiveShellInit}

        # and leave a note to our children to spare them the same work
        set -gx __fish_nixos_interactive_config_sourced 1
      end
    '';

    # include programs that bring their own completions
    environment.pathsToLink = []
      ++ optional cfg.vendor.config.enable "/share/fish/vendor_conf.d"
      ++ optional cfg.vendor.completions.enable "/share/fish/vendor_completions.d"
      ++ optional cfg.vendor.functions.enable "/share/fish/vendor_functions.d";
    
    environment.systemPackages = [ pkgs.fish ];

    environment.shells = [
      "/run/current-system/sw/bin/fish"
      "/var/run/current-system/sw/bin/fish"
      "${pkgs.fish}/bin/fish"
    ];

  };

}
