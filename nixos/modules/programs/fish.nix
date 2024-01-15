{ config, lib, pkgs, ... }:

with lib;

let

  cfge = config.environment;

  cfg = config.programs.fish;

  fishAbbrs = concatStringsSep "\n" (
    mapAttrsFlatten (k: v: "abbr -ag ${k} ${escapeShellArg v}")
      cfg.shellAbbrs
  );

  fishAliases = concatStringsSep "\n" (
    mapAttrsFlatten (k: v: "alias ${k} ${escapeShellArg v}")
      (filterAttrs (k: v: v != null) cfg.shellAliases)
  );

  envShellInit = pkgs.writeText "shellInit" cfge.shellInit;

  envLoginShellInit = pkgs.writeText "loginShellInit" cfge.loginShellInit;

  envInteractiveShellInit = pkgs.writeText "interactiveShellInit" cfge.interactiveShellInit;

  sourceEnv = file:
  if cfg.useBabelfish then
    "source /etc/fish/${file}.fish"
  else
    ''
      set fish_function_path ${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d $fish_function_path
      fenv source /etc/fish/foreign-env/${file} > /dev/null
      set -e fish_function_path[1]
    '';

  babelfishTranslate = path: name:
    pkgs.runCommandLocal "${name}.fish" {
      nativeBuildInputs = [ pkgs.babelfish ];
    } "babelfish < ${path} > $out;";

in

{

  options = {

    programs.fish = {

      enable = mkOption {
        default = false;
        description = lib.mdDoc ''
          Whether to configure fish as an interactive shell.
        '';
        type = types.bool;
      };

      useBabelfish = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          If enabled, the configured environment will be translated to native fish using [babelfish](https://github.com/bouk/babelfish).
          Otherwise, [foreign-env](https://github.com/oh-my-fish/plugin-foreign-env) will be used.
        '';
      };

      vendor.config.enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether fish should source configuration snippets provided by other packages.
        '';
      };

      vendor.completions.enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether fish should use completion files provided by other packages.
        '';
      };

      vendor.functions.enable = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Whether fish should autoload fish functions provided by other packages.
        '';
      };

      shellAbbrs = mkOption {
        default = {};
        example = {
          gco = "git checkout";
          npu = "nix-prefetch-url";
        };
        description = lib.mdDoc ''
          Set of fish abbreviations.
        '';
        type = with types; attrsOf str;
      };

      shellAliases = mkOption {
        default = {};
        description = lib.mdDoc ''
          Set of aliases for fish shell, which overrides {option}`environment.shellAliases`.
          See {option}`environment.shellAliases` for an option format description.
        '';
        type = with types; attrsOf (nullOr (either str path));
      };

      shellInit = mkOption {
        default = "";
        description = lib.mdDoc ''
          Shell script code called during fish shell initialisation.
        '';
        type = types.lines;
      };

      loginShellInit = mkOption {
        default = "";
        description = lib.mdDoc ''
          Shell script code called during fish login shell initialisation.
        '';
        type = types.lines;
      };

      interactiveShellInit = mkOption {
        default = "";
        description = lib.mdDoc ''
          Shell script code called during interactive fish shell initialisation.
        '';
        type = types.lines;
      };

      promptInit = mkOption {
        default = "";
        description = lib.mdDoc ''
          Shell script code used to initialise fish prompt.
        '';
        type = types.lines;
      };

    };

  };

  config = mkIf cfg.enable {

    programs.fish.shellAliases = mapAttrs (name: mkDefault) cfge.shellAliases;

    # Required for man completions
    documentation.man.generateCaches = lib.mkDefault true;

    environment = mkMerge [
      (mkIf cfg.useBabelfish
      {
        etc."fish/setEnvironment.fish".source = babelfishTranslate config.system.build.setEnvironment "setEnvironment";
        etc."fish/shellInit.fish".source = babelfishTranslate envShellInit "shellInit";
        etc."fish/loginShellInit.fish".source = babelfishTranslate envLoginShellInit "loginShellInit";
        etc."fish/interactiveShellInit.fish".source = babelfishTranslate envInteractiveShellInit "interactiveShellInit";
     })

      (mkIf (!cfg.useBabelfish)
      {
        etc."fish/foreign-env/shellInit".source = envShellInit;
        etc."fish/foreign-env/loginShellInit".source = envLoginShellInit;
        etc."fish/foreign-env/interactiveShellInit".source = envInteractiveShellInit;
      })

      {
        etc."fish/nixos-env-preinit.fish".text =
        if cfg.useBabelfish
        then ''
          # source the NixOS environment config
          if [ -z "$__NIXOS_SET_ENVIRONMENT_DONE" ]
            source /etc/fish/setEnvironment.fish
          end
        ''
        else ''
          # This happens before $__fish_datadir/config.fish sets fish_function_path, so it is currently
          # unset. We set it and then completely erase it, leaving its configuration to $__fish_datadir/config.fish
          set fish_function_path ${pkgs.fishPlugins.foreign-env}/share/fish/vendor_functions.d $__fish_datadir/functions

          # source the NixOS environment config
          if [ -z "$__NIXOS_SET_ENVIRONMENT_DONE" ]
            fenv source ${config.system.build.setEnvironment}
          end

          # clear fish_function_path so that it will be correctly set when we return to $__fish_datadir/config.fish
          set -e fish_function_path
        '';
      }

      {
        etc."fish/config.fish".text = ''
        # /etc/fish/config.fish: DO NOT EDIT -- this file has been generated automatically.

        # if we haven't sourced the general config, do it
        if not set -q __fish_nixos_general_config_sourced
          ${sourceEnv "shellInit"}

          ${cfg.shellInit}

          # and leave a note so we don't source this config section again from
          # this very shell (children will source the general config anew)
          set -g __fish_nixos_general_config_sourced 1
        end

        # if we haven't sourced the login config, do it
        status is-login; and not set -q __fish_nixos_login_config_sourced
        and begin
          ${sourceEnv "loginShellInit"}

          ${cfg.loginShellInit}

          # and leave a note so we don't source this config section again from
          # this very shell (children will source the general config anew)
          set -g __fish_nixos_login_config_sourced 1
        end

        # if we haven't sourced the interactive config, do it
        status is-interactive; and not set -q __fish_nixos_interactive_config_sourced
        and begin
          ${fishAbbrs}
          ${fishAliases}

          ${sourceEnv "interactiveShellInit"}

          ${cfg.promptInit}
          ${cfg.interactiveShellInit}

          # and leave a note so we don't source this config section again from
          # this very shell (children will source the general config anew,
          # allowing configuration changes in, e.g, aliases, to propagate)
          set -g __fish_nixos_interactive_config_sourced 1
        end
      '';
      }

      {
        etc."fish/generated_completions".source =
        let
          patchedGenerator = pkgs.stdenv.mkDerivation {
            name = "fish_patched-completion-generator";
            srcs = [
              "${pkgs.fish}/share/fish/tools/create_manpage_completions.py"
              "${pkgs.fish}/share/fish/tools/deroff.py"
            ];
            unpackCmd = "cp $curSrc $(basename $curSrc)";
            sourceRoot = ".";
            patches = [ ./fish_completion-generator.patch ]; # to prevent collisions of identical completion files
            dontBuild = true;
            installPhase = ''
              mkdir -p $out
              cp * $out/
            '';
            preferLocalBuild = true;
            allowSubstitutes = false;
          };
          generateCompletions = package: pkgs.runCommandLocal
            ( with lib.strings; let
                storeLength = stringLength storeDir + 34; # Nix' StorePath::HashLen + 2 for the separating slash and dash
                pathName = substring storeLength (stringLength package - storeLength) package;
              in (package.name or pathName) + "_fish-completions")
            ( { inherit package; } //
              optionalAttrs (package ? meta.priority) { meta.priority = package.meta.priority; })
            ''
              mkdir -p $out
              if [ -d $package/share/man ]; then
                find $package/share/man -type f | xargs ${pkgs.python3.pythonOnBuildForHost.interpreter} ${patchedGenerator}/create_manpage_completions.py --directory $out >/dev/null
              fi
            '';
        in
          pkgs.buildEnv {
            name = "system_fish-completions";
            ignoreCollisions = true;
            paths = map generateCompletions config.environment.systemPackages;
          };
      }

      # include programs that bring their own completions
      {
        pathsToLink = []
        ++ optional cfg.vendor.config.enable "/share/fish/vendor_conf.d"
        ++ optional cfg.vendor.completions.enable "/share/fish/vendor_completions.d"
        ++ optional cfg.vendor.functions.enable "/share/fish/vendor_functions.d";
      }

      { systemPackages = [ pkgs.fish ]; }

      {
        shells = [
          "/run/current-system/sw/bin/fish"
          "${pkgs.fish}/bin/fish"
        ];
      }
    ];

    programs.fish.interactiveShellInit = ''
      # add completions generated by NixOS to $fish_complete_path
      begin
        # joins with null byte to accommodate all characters in paths, then respectively gets all paths before (exclusive) / after (inclusive) the first one including "generated_completions",
        # splits by null byte, and then removes all empty lines produced by using 'string'
        set -l prev (string join0 $fish_complete_path | string match --regex "^.*?(?=\x00[^\x00]*generated_completions.*)" | string split0 | string match -er ".")
        set -l post (string join0 $fish_complete_path | string match --regex "[^\x00]*generated_completions.*" | string split0 | string match -er ".")
        set fish_complete_path $prev "/etc/fish/generated_completions" $post
      end
      # prevent fish from generating completions on first run
      if not test -d $__fish_user_data_dir/generated_completions
        ${pkgs.coreutils}/bin/mkdir $__fish_user_data_dir/generated_completions
      end
    '';

  };

}
