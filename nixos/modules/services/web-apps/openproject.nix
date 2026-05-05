{
  lib,
  config,
  pkgs,
  ...
}:

with lib;

let

  pgVersion = lib.head (lib.splitString "." config.services.postgresql.package.version);
  cfg = config.services.openproject;
  stateDir = "/var/lib/openproject";
  configEnv = concatMapAttrs (
    name: value:
    optionalAttrs (value != null) {
      ${name} = if isBool value then boolToString value else toString value;
    }
  ) cfg.settings;

  pkg = pkgs.openproject.override {
    openprojectStatePath = stateDir;
  };

in
{
  options.services.openproject = {

    enable = mkEnableOption "OpenProject modern project management web app";

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = types.attrsOf (
          types.nullOr (types.oneOf [
            types.str
            types.bool
            types.int
            types.port
            types.path
          ])
        );
        options = {
          OPENPROJECT_HOST__NAME = mkOption {
            type = lib.types.str;
            default = "localhost";
            description = "Hostname to use";
          };
          PORT = mkOption {
            type = lib.types.port;
            default = 6346;
            description = "IP address and port to bind to";
            example = "127.0.0.1:8080";
          };
          DATABASE_URL = mkOption {
            type = lib.types.str;
            default = "postgres:///openproject?host=/run/postgresql&username=openproject&pool=20&encoding=unicode&reconnect=true";
            description = ''
              Database connection scheme. The default specifies the
              connection through a local socket.
            '';
          };
        };
      };
      default = { };
      description = ''
        Extra configuration options to append or override.
        For available and default option values see
        [upstream configuration file](https://www.openproject.org/docs/installation-and-operations/configuration/environment/).
      '';
    };

    secrets.keyBaseFile = mkOption {
      type = types.str;
      description = "TODO";
    };
    secrets.environmentFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "TODO";
    };
    secrets.extraSeedEnvironmentFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "TODO";
    };
  };

  config = mkIf cfg.enable {

    services.openproject.settings = lib.mkMerge [
      {
        OPENPROJECT_RAILS_CACHE_STORE = "memcache";
        OPENPROJECT_CACHE__MEMCACHE__SERVER = "unix:///run/memcached/memcached.sock";
        OPENPROJECT_CACHE__NAMESPACE = "openproject";
        RAILS_ENV = "production";
        BUNDLE_WITHOUT = "development:test";
        PGVERSION = pgVersion;
        CURRENT_PGVERSION = pgVersion;
        NEXT_PGVERSION = pgVersion;
        SECRET_KEY_BASE_FILE = cfg.secrets.keyBaseFile;
        LD_PRELOAD = "${pkgs.jemalloc}/lib/libjemalloc.so";
      }
    ];

    systemd.services."openproject-seeder" = {
      serviceConfig = {
        Type = "oneshot";
        User = "openproject";
        RemainAfterExit = true;
        WorkingDirectory = "/var/lib/openproject";
        StateDirectory = "openproject";
        EnvironmentFile = remove null [
          cfg.secrets.extraSeedEnvironmentFile
          cfg.secrets.environmentFile
        ];
        ExecStart = "${lib.getExe' pkg "openproject-seeder"} openproject";

        # hardening
        # AmbientCapabilities = "";
        # CapabilityBoundingSet = "";
        # DevicePolicy = "closed";
        # DynamicUser = true;
        # LockPersonality = true;
        # MemoryDenyWriteExecute = true;
        # NoNewPrivileges = true;
        # PrivateDevices = true;
        # PrivateTmp = true;
        # PrivateUsers = true;
        # ProcSubset = "pid";
        # ProtectClock = true;
        # ProtectControlGroups = true;
        # ProtectHome = true;
        # ProtectHostname = true;
        # ProtectKernelLogs = true;
        # ProtectKernelModules = true;
        # ProtectKernelTunables = true;
        # ProtectProc = "invisible";
        # ProtectSystem = "strict";
        # RemoveIPC = true;
        # RestrictAddressFamilies = [
        #   "AF_INET"
        #   "AF_INET6"
        # ];
        # RestrictNamespaces = true;
        # RestrictRealtime = true;
        # RestrictSUIDSGID = true;
        # SystemCallArchitectures = "native";
        # SystemCallFilter = [
        #   "@system-service"
        #   "~@privileged"
        # ];
        # UMask = "0077";
      };
      bindsTo = [ "postgresql.service" ];
      after = [ "postgresql.service" ];
      environment = configEnv;
    };

    systemd.services."openproject-web" = {
      serviceConfig = {
        User = "openproject";
        EnvironmentFile = remove null [ cfg.secrets.environmentFile ];
        ExecStart = "${lib.getExe' pkg "openproject-web"}";
        WorkingDirectory = "/var/lib/openproject";
        StateDirectory = "openproject";
      };
      bindsTo = [ "openproject-seeder.service" ];
      after = [ "openproject-seeder.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = configEnv;
    };

    systemd.services."openproject-worker" = {
      serviceConfig = {
        User = "openproject";
        EnvironmentFile = remove null [ cfg.secrets.environmentFile ];
        ExecStart = "${lib.getExe' pkg "openproject-worker"}";
        WorkingDirectory = "/var/lib/openproject";
        StateDirectory = "openproject";
      };
      bindsTo = [ "openproject-seeder.service" ];
      after = [ "openproject-seeder.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = configEnv;
    };

    systemd.services."openproject-cron" = {
      serviceConfig = {
        User = "openproject";
        EnvironmentFile = remove null [ cfg.secrets.environmentFile ];
        ExecStart = "${lib.getExe' pkg "openproject-cron-step-imap"}";
        WorkingDirectory = "/var/lib/openproject";
        StateDirectory = "openproject";
      };
      bindsTo = [ "openproject-seeder.service" ];
      after = [ "openproject-seeder.service" ];
      environment = configEnv;
    };

    systemd.timers."openproject-cron" = lib.mkIf (cfg.settings.IMAP_HOST or null != null) {
      timerConfig.OnActiveSec = "30 seconds";
      timerConfig.OnUnitInactiveSec = "5 minutes";
      wantedBy = [ "multi-user.target" ];
      after = [ "openproject-seeder.service" ];
    };

    services.memcached = {
      enable = true;
      enableUnixSocket = true;
    };

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "openproject" ];
      ensureUsers = [
        {
          name = "openproject";
          ensureDBOwnership = true;
        }
      ];
    };

    users = {
      groups.openproject = { };
      users.openproject = {
        isSystemUser = true;
        group = "openproject";
      };
    };

  };
}
