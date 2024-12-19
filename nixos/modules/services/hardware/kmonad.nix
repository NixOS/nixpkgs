{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kmonad;

  # Per-keyboard options:
  keyboard =
    { name, ... }:
    {
      options = {
        name = lib.mkOption {
          type = lib.types.str;
          example = "laptop-internal";
          description = "Keyboard name.";
        };

        device = lib.mkOption {
          type = lib.types.path;
          example = "/dev/input/by-id/some-dev";
          description = "Path to the keyboard's device file.";
        };

        extraGroups = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ ];
          description = ''
            Extra permission groups to attach to the KMonad instance for
            this keyboard.

            Since KMonad runs as an unprivileged user, it may sometimes
            need extra permissions in order to read the keyboard device
            file.  If your keyboard's device file isn't in the input
            group you'll need to list its group in this option.
          '';
        };

        defcfg = {
          enable = lib.mkEnableOption ''
            Automatically generate the defcfg block.

            When this is option is set to true the config option for
            this keyboard should not include a defcfg block.
          '';

          compose = {
            key = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = "ralt";
              description = "The (optional) compose key to use.";
            };

            delay = lib.mkOption {
              type = lib.types.int;
              default = 5;
              description = "The delay (in milliseconds) between compose key sequences.";
            };
          };

          fallthrough = lib.mkEnableOption "Re-emit unhandled key events.";

          allowCommands = lib.mkEnableOption "Allow keys to run shell commands.";
        };

        config = lib.mkOption {
          type = lib.types.lines;
          description = "Keyboard configuration.";
        };
      };

      config = {
        name = lib.mkDefault name;
      };
    };

  # Create a complete KMonad configuration file:
  mkCfg =
    keyboard:
    let
      defcfg = ''
        (defcfg
          input  (device-file "${keyboard.device}")
          output (uinput-sink "kmonad-${keyboard.name}")
          ${lib.optionalString (keyboard.defcfg.compose.key != null) ''
            cmp-seq ${keyboard.defcfg.compose.key}
            cmp-seq-delay ${toString keyboard.defcfg.compose.delay}
          ''}
          fallthrough ${lib.boolToString keyboard.defcfg.fallthrough}
          allow-cmd ${lib.boolToString keyboard.defcfg.allowCommands}
        )
      '';
    in
    pkgs.writeTextFile {
      name = "kmonad-${keyboard.name}.cfg";
      text = lib.optionalString keyboard.defcfg.enable (defcfg + "\n") + keyboard.config;
      checkPhase = "${cfg.package}/bin/kmonad -d $out";
    };

  # Build a systemd path config that starts the service below when a
  # keyboard device appears:
  mkPath =
    keyboard:
    let
      name = "kmonad-${keyboard.name}";
    in
    lib.nameValuePair name {
      description = "KMonad trigger for ${keyboard.device}";
      wantedBy = [ "paths.target" ];
      pathConfig = {
        Unit = "${name}.service";
        PathExists = keyboard.device;
      };
    };

  # Build a systemd service that starts KMonad:
  mkService =
    keyboard:
    let
      cmd =
        [
          (lib.getExe cfg.package)
          "--input"
          ''device-file "${keyboard.device}"''
        ]
        ++ cfg.extraArgs
        ++ [ "${mkCfg keyboard}" ];
    in
    lib.nameValuePair "kmonad-${keyboard.name}" {
      description = "KMonad for ${keyboard.device}";
      script = lib.escapeShellArgs cmd;
      unitConfig = {
        # Control rate limiting.
        # Stop the restart logic if we restart more than
        # StartLimitBurst times in a period of StartLimitIntervalSec.
        StartLimitIntervalSec = 2;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        Restart = "always";
        # Restart at increasing intervals from 2s to 1m
        RestartSec = 2;
        RestartSteps = 30;
        RestartMaxDelaySec = "1min";
        Nice = -20;
        DynamicUser = true;
        User = "kmonad";
        Group = "kmonad";
        SupplementaryGroups = [
          # These ensure that our dynamic user has access to the device node
          config.users.groups.input.name
          config.users.groups.uinput.name
        ] ++ keyboard.extraGroups;
      };
    };
in
{
  options.services.kmonad = {
    enable = lib.mkEnableOption "KMonad: An advanced keyboard manager.";

    package = lib.mkPackageOption pkgs "kmonad" { };

    keyboards = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule keyboard);
      default = { };
      description = "Keyboard configuration.";
    };

    extraArgs = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "--log-level"
        "debug"
      ];
      description = "Extra arguments to pass to KMonad.";
    };
  };

  config = lib.mkIf cfg.enable {
    hardware.uinput.enable = true;

    systemd = {
      paths = lib.mapAttrs' (_: mkPath) cfg.keyboards;
      services = lib.mapAttrs' (_: mkService) cfg.keyboards;
    };
  };
}
