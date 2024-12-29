{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.evremap;
  format = pkgs.formats.toml { };

  key = lib.types.strMatching "KEY_[[:upper:]]+" // {
    description = "key ID prefixed with KEY_";
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

      script = "${lib.getExe pkgs.evremap} remap ${format.generate "evremap.toml" cfg.settings}";

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
