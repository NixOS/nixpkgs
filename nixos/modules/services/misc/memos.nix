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
  options.services.memos = with lib; {
    enable = mkEnableOption "Memos note-taking";
    package = mkPackageOption pkgs "memos" { };

    openFirewall = mkEnableOption "opening the ports in the firewall";

    user = mkOption {
      type = types.str;
      description = "The user to run memos as";
      default = "memos";
    };

    group = mkOption {
      type = types.str;
      description = "The group to run memos as";
      default = "memos";
    };

    mode = mkOption {
      default = "prod";
      type = types.enum [
        "prod"
        "dev"
        "demo"
      ];
      description = ''
        Sets the mode of the server, influencing its runtime behavior and the database used
      '';
    };
    address = mkOption {
      default = "0.0.0.0";
      type = types.str;
      description = ''
        Specifies the address on which the server will listen for incoming connections
      '';
    };
    port = mkOption {
      default = 5230;
      type = types.port;
      description = ''
        Sets the port on which the server will be accessible
      '';
    };
    dataDir = mkOption {
      default = "/var/lib/memos/";
      type = types.path;
      description = ''
        Specifies the directory where Memos will store its data
      '';
    };
    driver = mkOption {
      default = "sqlite";
      type = types.enum [
        "sqlite"
        "postgres"
        "mysql"
      ];
      description = ''
        Sets the database driver to be used by Memos
      '';
    };
    dsn = mkOption {
      default = null;
      type = types.nullOr types.str;
      description = ''
        Specifies the database source name (DSN) for connecting to the database.
        Note that each database driver has its own format for specifying the DSN.
        See https://www.usememos.com/docs/install/database for more information.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      description = lib.mkDefault "Memos service user";
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.${cfg.group} = { };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [
      cfg.port
    ];

    systemd.tmpfiles.settings.memos = {
      "${cfg.dataDir}" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };
    };

    systemd.services.memos = {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      wants = [ "network.target" ];
      description = "Memos, a privacy-first, lightweight note-taking solution";
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        Type = "simple";
        RestartSec = 60;
        LimitNOFILE = 65536;
        NoNewPrivileges = true;
        LockPersonality = true;
        RemoveIPC = true;
        ReadWritePaths = [
          cfg.dataDir
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
        ExecStart = "${lib.getExe cfg.package} --mode ${cfg.mode} --addr ${cfg.address} --port ${toString cfg.port} --data ${cfg.dataDir} --driver ${cfg.driver} ${
          if cfg.dsn != null then " --dsn ${cfg.dsn}" else ""
        }";
      };
    };
  };

  meta = with lib; {
    maintainers = with maintainers; [ m0ustach3 ];
  };
}
