{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.evremap;
  format = pkgs.formats.toml { };
  settings = lib.attrsets.filterAttrs (n: v: v != null) cfg.settings;
  configFile = format.generate "evremap.toml" settings;

  key = lib.types.strMatching "(BTN|KEY)_[[:upper:]]+" // {
    description = "key ID prefixed with BTN_ or KEY_";
  };

  mkKeyOption =
    description:
    lib.mkOption {
      type = key;
      description = ''
        ${description}

        You can get a list of keys by running `evremap list-keys`.
      '';
    };
  mkKeySeqOption =
    description:
    (mkKeyOption description)
    // {
      type = lib.types.listOf key;
    };

  dualRoleModule = lib.types.submodule {
    options = {
      input = mkKeyOption "The key that should be remapped.";
      hold = mkKeySeqOption "The key sequence that should be output when the input key is held.";
      tap = mkKeySeqOption "The key sequence that should be output when the input key is tapped.";
    };
  };

  remapModule = lib.types.submodule {
    options = {
      input = mkKeySeqOption "The key sequence that should be remapped.";
      output = mkKeySeqOption "The key sequence that should be output when the input sequence is entered.";
    };
  };
in
{
  options.services.evremap = {
    enable = lib.mkEnableOption "evremap, a keyboard input remapper for Linux/Wayland systems";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;

        options = {
          device_name = lib.mkOption {
            type = lib.types.str;
            example = "AT Translated Set 2 keyboard";
            description = ''
              The name of the device that should be remapped.

              You can get a list of devices by running `evremap list-devices` with elevated permissions.
            '';
          };

          phys = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            example = "usb-0000:07:00.3-2.1.1/input0";
            description = ''
              The physical device name to listen on.

              This attribute may be specified to disambiguate multiple devices with the same device name.
              The physical device names of each device can be obtained by running `evremap list-devices` with elevated permissions.
            '';
          };

          dual_role = lib.mkOption {
            type = lib.types.listOf dualRoleModule;
            default = [ ];
            example = [
              {
                input = "KEY_CAPSLOCK";
                hold = [ "KEY_LEFTCTRL" ];
                tap = [ "KEY_ESC" ];
              }
            ];
            description = ''
              List of dual-role remappings that output different key sequences based on whether the
              input key is held or tapped.
            '';
          };

          remap = lib.mkOption {
            type = lib.types.listOf remapModule;
            default = [ ];
            example = [
              {
                input = [
                  "KEY_LEFTALT"
                  "KEY_UP"
                ];
                output = [ "KEY_PAGEUP" ];
              }
            ];
            description = ''
              List of remappings.
            '';
          };
        };
      };

      description = ''
        Settings for evremap.

        See the [upstream documentation](https://github.com/wez/evremap/blob/master/README.md#configuration)
        for how to configure evremap.
      '';
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.evremap ];

    hardware.uinput.enable = true;

    systemd.services.evremap = {
      description = "evremap - keyboard input remapper";
      wantedBy = [ "multi-user.target" ];

      script = "${lib.getExe pkgs.evremap} remap ${configFile}";

      serviceConfig = {
        DynamicUser = true;
        User = "evremap";
        SupplementaryGroups = [
          config.users.groups.input.name
          config.users.groups.uinput.name
        ];
        Restart = "on-failure";
        RestartSec = 5;
        TimeoutSec = 20;

        # Hardening
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        ProtectKernelModules = true;
        ProtectHostname = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectHome = true;
        ProcSubset = "pid";

        PrivateTmp = true;
        PrivateNetwork = true;
        PrivateUsers = true;

        RestrictRealtime = true;
        RestrictNamespaces = true;
        RestrictAddressFamilies = "none";

        MemoryDenyWriteExecute = true;
        LockPersonality = true;
        IPAddressDeny = "any";
        AmbientCapabilities = "";
        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@resources"
          "~@privileged"
        ];
        UMask = "0027";
      };
    };
  };
}
