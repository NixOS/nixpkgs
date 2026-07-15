{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    getExe
    mkIf
    mkEnableOption
    mkOption
    mkPackageOption
    types
    ;
  cfg = config.services.zwave-js-ui;
in
{
  options.services.zwave-js-ui = {
    enable = mkEnableOption "zwave-js-ui";

    package = mkPackageOption pkgs "zwave-js-ui" { };

    serialPort = mkOption {
      type = types.path;
      description = ''
        Serial port for the Z-Wave controller.

        Only used to grant permissions to the device; must be additionally configured in the application
      '';
      example = "/dev/serial/by-id/usb-example";
    };

    settings = mkOption {
      type = types.submodule {
        freeformType =
          with types;
          attrsOf (
            nullOr (oneOf [
              str
              path
              package
            ])
          );

        options = {
          STORE_DIR = mkOption {
            type = types.str;
            default = "%S/zwave-js-ui";
            visible = false;
            readOnly = true;
          };

          ZWAVEJS_EXTERNAL_CONFIG = mkOption {
            type = types.str;
            default = "%S/zwave-js-ui/.config-db";
            visible = false;
            readOnly = true;
          };
        };
      };

      description = ''
        Extra environment variables passed to the zwave-js-ui process.

        Check <https://zwave-js.github.io/zwave-js-ui/#/guide/env-vars> for possible options
      '';
      example = {
        HOST = "::";
        PORT = "8091";
      };
    };
  };
  config = mkIf cfg.enable {
    systemd.services.zwave-js-ui = {
      environment = cfg.settings;
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        ExecStart = getExe cfg.package;
        RuntimeDirectory = "zwave-js-ui";
        StateDirectory = "zwave-js-ui";
        RootDirectory = "%t/zwave-js-ui";
        BindReadOnlyPaths = [
          "/nix/store"
        ];
        DeviceAllow = [ cfg.serialPort ];
        DynamicUser = true;
        SupplementaryGroups = [ "dialout" ];
        CapabilityBoundingSet = [ "" ];
        RestrictAddressFamilies = "AF_INET AF_INET6";
        DevicePolicy = "closed";
        LockPersonality = true;
        MemoryDenyWriteExecute = false;
        NoNewPrivileges = true;
        PrivateUsers = true;
        PrivateTmp = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        RemoveIPC = true;
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service @pkey"
          "~@privileged @resources"
          "@chown"
        ];
        UMask = "0077";
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ cdombroski ];
}
