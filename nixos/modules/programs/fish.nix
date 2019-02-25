{ config, lib, pkgs, ... }:

with lib;

let

  cfge = config.environment;

  cfg = config.programs.fish;

  fishAliases = concatStringsSep "\n" (
    mapAttrsFlatten (k: v: "alias ${k} ${escapeShellArg v}")
      (filterAttrs (k: v: !isNull v) cfg.shellAliases)
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
        default = {};
        description = ''
          Set of aliases for fish shell, which overrides <option>environment.shellAliases</option>.
          See <option>environment.shellAliases</option> for an option format description.
        '';
        type = with types; attrsOf (nullOr (either str path));
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

    programs.fish.shellAliases = mapAttrs (name: mkDefault) cfge.shellAliases;

    environment.etc."fish/foreign-env/shellInit".text = cfge.shellInit;
    environment.etc."fish/foreign-env/loginShellInit".text = cfge.loginShellInit;
    environment.etc."fish/foreign-env/interactiveShellInit".text = cfge.interactiveShellInit;

    environment.etc."fish/nixos-env-preinit.fish".text = ''
      # This happens before $__fish_datadir/config.fish sets fish_function_path, so it is currently
      # unset. We set it and then completely erase it, leaving its configuration to $__fish_datadir/config.fish
      set fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions $__fish_datadir/functions

      # source the NixOS environment config
      if [ -z "$__NIXOS_SET_ENVIRONMENT_DONE" ]
          fenv source ${config.system.build.setEnvironment}
      end

      # clear fish_function_path so that it will be correctly set when we return to $__fish_datadir/config.fish
      set -e fish_function_path
    '';

    environment.etc."fish/config.fish".text = ''
      # /etc/fish/config.fish: DO NOT EDIT -- this file has been generated automatically.

      # if we haven't sourced the general config, do it
      if not set -q __fish_nixos_general_config_sourced
        set fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions $fish_function_path
        fenv source /etc/fish/foreign-env/shellInit > /dev/null
        set -e fish_function_path[1]

        ${cfg.shellInit}

        # and leave a note so we don't source this config section again from
        # this very shell (children will source the general config anew)
        set -g __fish_nixos_general_config_sourced 1
      end

      # if we haven't sourced the login config, do it
      status --is-login; and not set -q __fish_nixos_login_config_sourced
      and begin
        set fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions $fish_function_path
        fenv source /etc/fish/foreign-env/loginShellInit > /dev/null
        set -e fish_function_path[1]

        ${cfg.loginShellInit}

        # and leave a note so we don't source this config section again from
        # this very shell (children will source the general config anew)
        set -g __fish_nixos_login_config_sourced 1
      end

      # if we haven't sourced the interactive config, do it
      status --is-interactive; and not set -q __fish_nixos_interactive_config_sourced
      and begin
        ${fishAliases}

        set fish_function_path ${pkgs.fish-foreign-env}/share/fish-foreign-env/functions $fish_function_path
        fenv source /etc/fish/foreign-env/interactiveShellInit > /dev/null
        set -e fish_function_path[1]

        ${cfg.promptInit}
        ${cfg.interactiveShellInit}

        # and leave a note so we don't source this config section again from
        # this very shell (children will source the general config anew,
        # allowing configuration changes in, e.g, aliases, to propagate)
        set -g __fish_nixos_interactive_config_sourced 1
      end
    '';

    programs.fish.interactiveShellInit = ''
      # add completions generated by NixOS to $fish_complete_path
      begin
        # joins with null byte to acommodate all characters in paths, then respectively gets all paths before / after the first one including "generated_completions",
        # splits by null byte, and then removes all empty lines produced by using 'string'
        set -l prev (string join0 $fish_complete_path | string match --regex "^.*?(?=\x00[^\x00]*generated_completions.*)" | string split0 | string match -er ".")
        set -l post (string join0 $fish_complete_path | string match --regex "[^\x00]*generated_completions.*" | string split0 | string match -er ".")
        set fish_complete_path $prev "/etc/fish/generated_completions" $post
      end
    '';

    environment.etc."fish/generated_completions".source =
      let
        generateCompletions = package: pkgs.runCommand
          "${package.name}-fish-completions"
          (
            {
              src = package;
              nativeBuildInputs = [ pkgs.python3 ];
              buildInputs = [ pkgs.fish ];
              preferLocalBuild = true;
              allowSubstitutes = false;
            }
            // optionalAttrs (package ? meta.priority) { meta.priority = package.meta.priority; }
          )
          ''
            mkdir -p $out
            if [ -d $src/share/man ]; then
              find $src/share/man -type f | xargs python ${pkgs.fish}/share/fish/tools/create_manpage_completions.py --directory $out >/dev/null
            fi
          '';
      in
        pkgs.buildEnv {
          name = "system-fish-completions";
          paths = map generateCompletions config.environment.systemPackages;
        };

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
