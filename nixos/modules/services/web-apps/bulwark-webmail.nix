{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.services.bulwark-webmail;
  dataDir = "/var/lib/bulwark-webmail";
in
{
  options.services.bulwark-webmail = {
    enable = lib.mkEnableOption "Bulwark Webmail";
    package = lib.mkPackageOption pkgs "bulwark-webmail" { };
    environmentFile = lib.mkOption {
      description = ''
        Path to a file containing environment variables.

        Use this option to pass secrets.
      '';
      default = "";
      type = lib.types.oneOf [
        lib.types.path
        lib.types.str
      ];
    };
    environment = lib.mkOption {
      description = ''
        Configuration for Bulwark Webmail.

        See [the envfile example](https://github.com/bulwarkmail/webmail/blob/main/.env.example)
        for possible variables.

        Use {option}`services.bulwark-webmail.environmentFile` to specify secrets.
      '';
      default = { };
      type = lib.types.attrsOf lib.types.str;
    };
    dataDir = lib.mkOption {
      description = ''
        Path to the directory where the data should be stored.
      '';
      default = dataDir;
      type = lib.types.str;
    };

  };
  config = lib.mkIf cfg.enable {
    systemd.services.bulwark-webmail = {
      description = "Bulwark Webmail";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        NODE_ENV = "production";
        BULWARK_TELEMETRY = "off";
        BULWARK_UPDATE_CHECK = "off";
        ADMIN_CONFIG_DIR = "${cfg.dataDir}/admin";
        ADMIN_STATE_DIR = "${cfg.dataDir}/admin-state";
        SETTINGS_DATA_DIR = "${cfg.dataDir}/settings";
        TELEMETRY_DATA_DIR = "${cfg.dataDir}/telemetry";
        VERSION_CHECK_DATA_DIR = "${cfg.dataDir}/version-check";
      }
      // cfg.environment;
      serviceConfig = {
        ExecStart = "${lib.getExe cfg.package}";
        Restart = "always";
        DynamicUser = true;
        StateDirectory = lib.mkIf (cfg.dataDir == dataDir) "bulwark-webmail";
        WorkingDirectory = lib.mkIf (cfg.dataDir == dataDir) "%S/bulwark-webmail";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != "") cfg.environmentFile;
        # Hardening
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateMounts = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RemoveIPC = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        CapabilityBoundingSet = "";
        AmbientCapabilities = "CAP_NET_BIND_SERVICE";
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "~@clock"
          "~@cpu-emulation"
          "~@debug"
          "~@module"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@raw-io"
          "~@reboot"
          "~@resources"
          "~@swap"
        ];
        UMask = "0077";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [
    ungeskriptet
  ];
}
