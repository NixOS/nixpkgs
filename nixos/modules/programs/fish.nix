{ config, lib, pkgs, ... }:

let

  cfge = config.environment;

  cfg = config.programs.fish;

  fishAbbrs = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (k: v: "abbr -ag ${k} ${lib.escapeShellArg v}")
      cfg.shellAbbrs
  );

  fishAliases = lib.concatStringsSep "\n" (
    lib.mapAttrsToList (k: v: "alias ${k} ${lib.escapeShellArg v}")
      (lib.filterAttrs (k: v: v != null) cfg.shellAliases)
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
    pkgs.runCommand "${name}.fish" {
      preferLocalBuild = true;
      nativeBuildInputs = [ pkgs.babelfish ];
    } "babelfish < ${path} > $out;";

  fishIndent =
    name: text:
    pkgs.runCommand name {
      nativeBuildInputs = [ cfg.package ];
      inherit text;
      passAsFile = [ "text" ];
    } "env HOME=$(mktemp -d) fish_indent < $textPath > $out";

  functionModule = lib.types.submodule {
    options = {
      body = lib.mkOption {
        type = lib.types.lines;
        description = ''
          The function body.
        '';
      };

      argumentNames = lib.mkOption {
        type = with lib.types; nullOr (either str (listOf str));
        default = null;
        description = ''
          Assigns the value of successive command line arguments to the names
          given.
        '';
      };

      description = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          A description of what the function does, suitable as a completion
          description.
        '';
      };

      wraps = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Causes the function to inherit completions from the given wrapped
          command.
        '';
      };

      onEvent = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Tells fish to run this function when the specified named event is
          emitted. Fish internally generates named events e.g. when showing the
          prompt.
        '';
      };

      onVariable = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Tells fish to run this function when the specified variable changes
          value.
        '';
      };

      onJobExit = lib.mkOption {
        type = with lib.types; nullOr (either str int);
        default = null;
        description = ''
          Tells fish to run this function when the job with the specified group
          ID exits. Instead of a PID, the stringer `caller` can
          be specified. This is only legal when in a command substitution, and
          will result in the handler being triggered by the exit of the job
          which created this command substitution.
        '';
      };

      onProcessExit = lib.mkOption {
        type = with lib.types; nullOr (either str int);
        default = null;
        example = "$fish_pid";
        description = ''
          Tells fish to run this function when the fish child process with the
          specified process ID exits. Instead of a PID, for backwards
          compatibility, `%self` can be specified as an alias
          for `$fish_pid`, and the function will be run when
          the current fish instance exits.
        '';
      };

      onSignal = lib.mkOption {
        type = with lib.types; nullOr (either str int);
        default = null;
        example = [
          "SIGHUP"
          "HUP"
          1
        ];
        description = ''
          Tells fish to run this function when the specified signal is
          delievered. The signal can be a signal number or signal name.
        '';
      };

      noScopeShadowing = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Allows the function to access the variables of calling functions.
        '';
      };

      inheritVariable = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = ''
          Snapshots the value of the specified variable and defines a local
          variable with that same name and value when the function is defined.
        '';
      };
    };
  };

in

{

  options = {

    programs.fish = {

      enable = lib.mkOption {
        default = false;
        description = ''
          Whether to configure fish as an interactive shell.
        '';
        type = lib.types.bool;
      };

      package = lib.mkPackageOption pkgs "fish" { };

      useBabelfish = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          If enabled, the configured environment will be translated to native fish using [babelfish](https://github.com/bouk/babelfish).
          Otherwise, [foreign-env](https://github.com/oh-my-fish/plugin-foreign-env) will be used.
        '';
      };

      vendor.config.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether fish should source configuration snippets provided by other packages.
        '';
      };

      vendor.completions.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether fish should use completion files provided by other packages.
        '';
      };

      vendor.functions.enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether fish should autoload fish functions provided by other packages.
        '';
      };

      shellAbbrs = lib.mkOption {
        default = {};
        example = {
          gco = "git checkout";
          npu = "nix-prefetch-url";
        };
        description = ''
          Set of fish abbreviations.
        '';
        type = with lib.types; attrsOf str;
      };

      shellAliases = lib.mkOption {
        default = {};
        description = ''
          Set of aliases for fish shell, which overrides {option}`environment.shellAliases`.
          See {option}`environment.shellAliases` for an option format description.
        '';
        type = with lib.types; attrsOf (nullOr (either str path));
      };

      shellInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code called during fish shell initialisation.
        '';
        type = lib.types.lines;
      };

      loginShellInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code called during fish login shell initialisation.
        '';
        type = lib.types.lines;
      };

      interactiveShellInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code called during interactive fish shell initialisation.
        '';
        type = lib.types.lines;
      };

      promptInit = lib.mkOption {
        default = "";
        description = ''
          Shell script code used to initialise fish prompt.
        '';
        type = lib.types.lines;
      };

      functions = lib.mkOption {
        type = with lib.types; attrsOf (either lines functionModule);
        default = { };
        example = ''
          {
            __fish_command_not_found_handler = {
              body = "__fish_default_command_not_found_handler $argv[1]";
              onEvent = "fish_command_not_found";
            };

            gitignore = "curl -sL https://www.gitignore.io/api/$argv";
          }
        '';
        description = ''
          Basic functions to add to fish. For more information see
          <https://fishshell.com/docs/current/cmds/function.html>.
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {

    programs.fish.shellAliases = lib.mapAttrs (name: lib.mkDefault) cfge.shellAliases;

    # Required for man completions
    documentation.man.generateCaches = lib.mkDefault true;

    environment = lib.mkMerge [
      (lib.mkIf cfg.useBabelfish
      {
        etc."fish/setEnvironment.fish".source = babelfishTranslate config.system.build.setEnvironment "setEnvironment";
        etc."fish/shellInit.fish".source = babelfishTranslate envShellInit "shellInit";
        etc."fish/loginShellInit.fish".source = babelfishTranslate envLoginShellInit "loginShellInit";
        etc."fish/interactiveShellInit.fish".source = babelfishTranslate envInteractiveShellInit "interactiveShellInit";
     })

      (lib.mkIf (!cfg.useBabelfish)
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
        etc = lib.mapAttrs' (name: def: {
          name = "fish/functions/${name}.fish";
          value.source =
            let
              modifierStr = n: v: lib.optional (v != null) ''--${n}="${toString v}"'';
              modifierStrs = n: v: lib.optional (v != null) "--${n}=${toString v}";
              modifierBool = n: v: lib.optional (v != null && v) "--${n}";

              mods =
                with def;
                modifierStr "description" description
                ++ modifierStr "wraps" wraps
                ++ modifierStr "on-event" onEvent
                ++ modifierStr "on-variable" onVariable
                ++ modifierStr "on-job-exit" onJobExit
                ++ modifierStr "on-process-exit" onProcessExit
                ++ modifierStr "on-signal" onSignal
                ++ modifierBool "no-scope-shadowing" noScopeShadowing
                ++ modifierStr "inherit-variable" inheritVariable
                ++ modifierStrs "argument-names" argumentNames;

              modifiers = if lib.isAttrs def then " ${toString mods}" else "";
              body = if lib.isAttrs def then def.body else def;
            in
            fishIndent "${name}.fish" ''
              function ${name}${modifiers}
                ${lib.strings.removeSuffix "\n" body}
              end
            '';
        }) cfg.functions;
      }

      {
        etc."fish/generated_completions".source =
        let
          patchedGenerator = pkgs.stdenv.mkDerivation {
            name = "fish_patched-completion-generator";
            srcs = [
              "${cfg.package}/share/fish/tools/create_manpage_completions.py"
              "${cfg.package}/share/fish/tools/deroff.py"
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
          generateCompletions = package: pkgs.runCommand
            ( with lib.strings; let
                storeLength = stringLength storeDir + 34; # Nix' StorePath::HashLen + 2 for the separating slash and dash
                pathName = substring storeLength (stringLength package - storeLength) package;
              in (package.name or pathName) + "_fish-completions")
            ( { inherit package;
                preferLocalBuild = true;
              } //
              lib.optionalAttrs (package ? meta.priority) { meta.priority = package.meta.priority; })
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
            paths = builtins.map generateCompletions config.environment.systemPackages;
          };
      }

      # include programs that bring their own completions
      {
        pathsToLink = []
        ++ lib.optional cfg.vendor.config.enable "/share/fish/vendor_conf.d"
        ++ lib.optional cfg.vendor.completions.enable "/share/fish/vendor_completions.d"
        ++ lib.optional cfg.vendor.functions.enable "/share/fish/vendor_functions.d";
      }

      { systemPackages = [ cfg.package ]; }

      {
        shells = [
          "/run/current-system/sw/bin/fish"
          (lib.getExe cfg.package)
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
  meta.maintainers = with lib.maintainers; [ sigmasquadron ];
}
