{
  config,
  lib,
  pkgs,
  utils,
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
          default = name;
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
            group, you'll need to list its group in this option.
          '';
        };

        enableHardening = lib.mkOption {
          type = lib.types.bool;
          default = true;
          example = false;
          description = ''
            Whether to enable systemd hardening.

            ::: {.note}
            If KMonad is used to execute shell commands, hardening may make some of them fail.
            :::
          '';
        };

        defcfg = {
          enable = lib.mkEnableOption ''
            automatic generation of the defcfg block.

            When this option is set to true, the config option for
            this keyboard should not include a defcfg block
          '';

          compose = {
            key = lib.mkOption {
              type = lib.types.nullOr lib.types.str;
              default = "ralt";
              description = "The (optional) compose key to use.";
            };

            delay = lib.mkOption {
              type = lib.types.ints.unsigned;
              default = 5;
              description = "The delay (in milliseconds) between compose key sequences.";
            };
          };

          fallthrough = lib.mkEnableOption "re-emitting unhandled key events";

          allowCommands = lib.mkEnableOption "keys to run shell commands";
        };

        config = lib.mkOption {
          type = lib.types.lines;
          description = "Keyboard configuration.";
        };
      };
    };

  mkName = name: "kmonad-" + name;

  # Create a complete KMonad configuration file:
  mkCfg =
    keyboard:
    let
      defcfg = ''
        (defcfg
          input  (device-file "${keyboard.device}")
          output (uinput-sink "${mkName keyboard.name}")
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
      name = "${mkName keyboard.name}.kbd";
      text = lib.optionalString keyboard.defcfg.enable (defcfg + "\n") + keyboard.config;
      checkPhase = "${lib.getExe cfg.package} -d $out";
    };

  # Build a systemd path config that starts the service below when a
  # keyboard device appears:
  mkPath =
    keyboard:
    let
      name = mkName keyboard.name;
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
    lib.nameValuePair (mkName keyboard.name) {
      description = "KMonad for ${keyboard.device}";
      unitConfig = {
        # Control rate limiting.
        # Stop the restart logic if we restart more than
        # StartLimitBurst times in a period of StartLimitIntervalSec.
        StartLimitIntervalSec = 2;
        StartLimitBurst = 5;
      };
      serviceConfig = {
        ExecStart = ''
          ${lib.getExe cfg.package} ${mkCfg keyboard} \
            ${utils.escapeSystemdExecArgs cfg.extraArgs}
        '';
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
        ]
        ++ keyboard.extraGroups;
      }
      // lib.optionalAttrs keyboard.enableHardening {
        DeviceAllow = [
          "/dev/uinput w"
          "char-input r"
        ];
        CapabilityBoundingSet = [ "" ];
        DevicePolicy = "closed";
        IPAddressDeny = [ "any" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        PrivateNetwork = true;
        PrivateUsers = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        RestrictAddressFamilies = [ "none" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        SystemCallArchitectures = [ "native" ];
        SystemCallErrorNumber = "EPERM";
        SystemCallFilter = [
          "@system-service"
          "~@privileged"
          "~@resources"
        ];
        UMask = "0077";
      };
      # make sure the new config is used after nixos-rebuild switch
      # stopIfChanged controls[0] how a service is "restarted" during
      # nixos-rebuild switch.  By default, stopIfChanged is true, which stops
      # the old service and then starts the new service after config updates.
      # Since we use path-based activation[1] here, the service unit will
      # immediately[2] be started by the path unit.  Probably that start is
      # before config updates, which causes the service unit to use the old
      # config after nixos-rebuild switch.  Setting stopIfChanged to false works
      # around this issue by restarting the service after config updates.
      # [0]: https://nixos.org/manual/nixos/unstable/#sec-switching-systems
      # [1]: man 7 daemon
      # [2]: man 5 systemd.path
      stopIfChanged = false;
    };
in
{
  options.services.kmonad = {
    enable = lib.mkEnableOption "KMonad: an advanced keyboard manager";

    package = lib.mkPackageOption pkgs "KMonad" { default = "kmonad"; };

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

    services.udev.extraRules =
      let
        mkRule = name: ''
          ACTION=="add", KERNEL=="event*", SUBSYSTEM=="input", ATTRS{name}=="${name}", ATTRS{id/product}=="5679", ATTRS{id/vendor}=="1235", SYMLINK+="input/by-id/${name}"
        '';
      in
      lib.foldlAttrs (
        rules: _: keyboard:
        rules + "\n" + mkRule (mkName keyboard.name)
      ) "" cfg.keyboards;

    systemd = {
      paths = lib.mapAttrs' (_: mkPath) cfg.keyboards;
      services = lib.mapAttrs' (_: mkService) cfg.keyboards;
    };
  };

  meta = {
    maintainers = with lib.maintainers; [
      linj
      rvdp
    ];
  };
}
