{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.memos;
in
{
  options.services.memos = {
    enable = lib.mkEnableOption "Memo, an open-source, self-hosted note-taking service.";

    package = lib.mkPackageOption pkgs "Memos" { default = "memos"; };

    openFirewall = lib.mkEnableOption "Open ports in the firewall for the Memos web interface.";

    user = lib.mkOption {
      type = lib.types.str;
      default = "memos";
      description = "User under which Memos runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "memos";
      description = "Group under which Memos runs.";
    };

    settings = {
      mode = lib.mkOption {
        type = lib.types.enum [
          "prod"
          "dev"
        ];
        default = "prod";
        description = "Mode of server (MEMOS_MODE).";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 8081;
        description = "HTTP port to listen on (MEMOS_PORT).";
      };

      address = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Bind address, empty means all interfaces (MEMOS_ADDR).";
      };

      unixSocket = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Path to the unix socket (MEMOS_UNIX_SOCK). Overrides MEMOS_ADDR and MEMOS_PORT.";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/memos";
        description = "Data directory (MEMOS_DATA).";
      };

      databaseDriver = lib.mkOption {
        type = lib.types.enum [
          "sqlite"
          "mysql"
          "postgres"
        ];
        default = "sqlite";
        description = "Database driver (MEMOS_DRIVER).";
      };

      databaseSourceName = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Database connection string (MEMOS_DSN).";
      };

      instanceUrl = lib.mkOption {
        type = with lib.types; nullOr str;
        default = null;
        description = "Instance base URL (MEMOS_INSTANCE_URL).";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd = {
      tmpfiles.settings."10-memos"."${cfg.settings.dataDir}".d = {
        inherit (cfg) user group;
        mode = "0750";
      };

      services.memos = {
        description = "Memos, a privacy-first, lightweight note-taking solution";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = {
          MEMOS_MODE = cfg.settings.mode;
          MEMOS_PORT = toString cfg.settings.port;
          MEMOS_ADDR = lib.mkIf (cfg.settings.address != null) cfg.settings.address;
          MEMOS_UNIX_SOCK = lib.mkIf (cfg.settings.unixSocket != null) cfg.settings.unixSocket;
          MEMOS_DATA = toString cfg.settings.dataDir;
          MEMOS_DRIVER = cfg.settings.databaseDriver;
          MEMOS_DSN = lib.mkIf (cfg.settings.databaseSourceName != null) cfg.settings.databaseSourceName;
          MEMOS_INSTANCE_URL = lib.mkIf (cfg.settings.instanceUrl != null) cfg.settings.instanceUrl;
        };
        serviceConfig = {
          User = cfg.user;
          Group = cfg.group;
          Type = "simple";
          Restart = "always";
          RestartSec = 3;
          ExecStart = "${lib.getExe cfg.package}";
          LimitNOFILE = 65536;
          NoNewPrivileges = true;
          LockPersonality = true;
          RemoveIPC = true;
          ReadWritePaths = [
            cfg.settings.dataDir
          ];
          ProtectSystem = "strict";
          PrivateUsers = true;
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectHostname = true;
          ProtectClock = true;
          UMask = "0077";
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          ProtectProc = "invisible";
          SystemCallFilter = [
            " " # This is needed to clear the SystemCallFilter existing definitions
            "~@reboot"
            "~@swap"
            "~@obsolete"
            "~@mount"
            "~@module"
            "~@debug"
            "~@cpu-emulation"
            "~@clock"
            "~@raw-io"
            "~@privileged"
            "~@resources"
          ];
          CapabilityBoundingSet = [
            " " # Reset all capabilities to an empty set
          ];
          RestrictAddressFamilies = [
            " " # This is needed to clear the RestrictAddressFamilies existing definitions
            "none" # Remove all addresses families
            "AF_UNIX"
            "AF_INET"
            "AF_INET6"
          ];
          DevicePolicy = "closed";
          ProtectKernelLogs = true;
          SystemCallArchitectures = "native";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        };
      };
    };

    users.users = lib.mkIf (cfg.user == "memos") {
      memos = {
        inherit (cfg) group;
        isSystemUser = true;
      };
    };

    users.groups = lib.mkIf (cfg.group == "memos") {
      memos = { };
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.settings.port
    ];
  };

  meta.maintainers = [ lib.maintainers.m0ustach3 ];
}
