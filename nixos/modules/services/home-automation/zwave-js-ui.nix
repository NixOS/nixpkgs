{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkOption
    types
    ;
  cfg = config.services.zwave-js-ui;
in
{
  options.services.zwave-js-ui = {
    enable = mkEnableOption "zwave-js-ui";
    serialPort = mkOption {
      type = types.path;
      description = ''
        Serial port for the Z-Wave controller.

        Used for permissions only; must be additionally set in the application
      '';
      example = "/dev/ttyUSB0";
    };
  };
  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !config.services.zwave-js.enable;
        message = "zwave-js-ui conflicts with zwave-js";
      }
    ];
    systemd.services.zwave-js-ui = {
      environment = {
        STORE_DIR = "/var/lib/zwave-js-ui";
        ZWAVEJS_EXTERNAL_CONFIG = "/var/lib/zwave-js-ui/.config-db";
      };
      script = "${pkgs.zwave-js-ui}/bin/zwave-js-ui";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        RuntimeDirectory = "zwave-js-ui";
        StateDirectory = "zwave-js-ui";
        RootDirectory = "/run/zwave-js-ui";
        BindReadOnlyPaths = [
          "/etc"
          "/nix/store"
        ];
        BindPaths = [ "/var/lib/zwave-js-ui" ];
        DeviceAllow = [ cfg.serialPort ];
        DynamicUser = true;
        SupplementaryGroups = [ "dialout" ];
        CapabilityBoundingSet = "";
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
        ProtectKernalTunables = true;
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
        ];
        UMask = "0077";
      };
    };
  };
  meta.maintainers = with lib.maintainers; [ cdombroski ];
}
