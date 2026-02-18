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
in
{
  options.services.openproject = with types; {
    enable = mkEnableOption "openproject server";
    host = {
      name = mkOption {
        type = str;
        default = config.networking.hostName;
      };
      rootPath = mkOption {
        type = str;
        default = "";
      };
      bind.addr = mkOption {
        type = str;
        default = "0.0.0.0";
      };
      bind.port = mkOption {
        type = int;
        default = 6346;
      };
    };
    package = mkPackageOption pkgs "openproject" { };
    secrets.keyBaseFile = mkOption {
      type = str;
    };
    secrets.environmentFile = mkOption {
      type = nullOr str;
      default = null;
    };
    secrets.extraSeedEnvironmentFile = mkOption {
      type = nullOr str;
      default = null;
    };
    environment = mkOption {
      type = attrsOf str;
      default = { };
    };
    useJemalloc = mkOption {
      type = bool;
      default = true;
    };
    dbUrl = mkOption {
      type = str;
      default = "postgres:///openproject?host=/run/postgresql&username=openproject&pool=20&encoding=unicode&reconnect=true";
    };
    statePath = mkOption {
      type = str;
      default = "/var/lib/openproject";
    };
    imap = {
      enable = mkEnableOption "interact with openproject via mail";
    };
  };
  config = mkIf cfg.enable {

    nixpkgs.overlays = [
      (import ./overlay.nix { openprojectStatePath = cfg.statePath; })
    ];

    services.openproject = {
      ## see https://www.openproject.org/docs/installation-and-operations/configuration/environment/
      environment = {
        OPENPROJECT_HOST__NAME = cfg.host.name;
        OPENPROJECT_HSTS = "false";
        OPENPROJECT_RAILS_CACHE_STORE = "memcache";
        ## FIXME run multiple memcached instances instead
        ## FIXME or switch to redis if feasible
        OPENPROJECT_CACHE__MEMCACHE__SERVER = "unix:///run/memcached/memcached.sock";
        OPENPROJECT_CACHE__NAMESPACE = "openproject";
        OPENPROJECT_RAILS__RELATIVE__URL__ROOT = cfg.host.rootPath;
        RAILS_ENV = "production";
        RAILS_MIN_THREADS = "4";
        RAILS_MAX_THREADS = "16";
        BUNDLE_WITHOUT = "development:test";
        # set to true to enable the email receiving feature. See ./docker/cron for more options;
        IMAP_ENABLED = "false";
        PGVERSION = pgVersion;
        CURRENT_PGVERSION = pgVersion;
        NEXT_PGVERSION = pgVersion;
        DATABASE_URL = cfg.dbUrl;
        SECRET_KEY_BASE_FILE = cfg.secrets.keyBaseFile;
        LD_PRELOAD = mkIf cfg.useJemalloc "${pkgs.jemalloc}/lib/libjemalloc.so";
      };
    };

    users = {
      groups.openproject = { };
      users.openproject = {
        isSystemUser = true;
        group = "openproject";
      };
    };

    systemd.services."openproject-seeder" = {
      serviceConfig.User = "openproject";
      serviceConfig.Type = "oneshot";
      serviceConfig.RemainAfterExit = true;
      bindsTo = [ "postgresql.service" ];
      environment = cfg.environment;
      serviceConfig.EnvironmentFile = remove null [
        cfg.secrets.extraSeedEnvironmentFile
        cfg.secrets.environmentFile
      ];
      serviceConfig.ExecStart = "${cfg.package}/bin/openproject-seeder openproject";
    };
    systemd.services."openproject-web" = {
      serviceConfig.User = "openproject";
      bindsTo = [ "openproject-seeder.service" ];
      after = [ "openproject-seeder.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.environment;
      serviceConfig.EnvironmentFile = remove null [ cfg.secrets.environmentFile ];
      serviceConfig.ExecStart = "${cfg.package}/bin/openproject-web -b ${cfg.host.bind.addr} -p ${toString cfg.host.bind.port}";
    };
    systemd.services."openproject-worker" = {
      serviceConfig.User = "openproject";
      bindsTo = [ "openproject-seeder.service" ];
      after = [ "openproject-seeder.service" ];
      wantedBy = [ "multi-user.target" ];
      environment = cfg.environment;
      serviceConfig.EnvironmentFile = remove null [ cfg.secrets.environmentFile ];
      serviceConfig.ExecStart = "${cfg.package}/bin/openproject-worker";
    };
    systemd.services."openproject-cron" = {
      serviceConfig.User = "openproject";
      bindsTo = [ "openproject-seeder.service" ];
      after = [ "openproject-seeder.service" ];
      environment = cfg.environment;
      serviceConfig.EnvironmentFile = remove null [ cfg.secrets.environmentFile ];
      serviceConfig.ExecStart = mkIf cfg.imap.enable "${cfg.package}/bin/openproject-cron-step-imap";
    };
    systemd.timers."openproject-cron" = {
      timerConfig.OnActiveSec = "30 seconds";
      timerConfig.OnUnitInactiveSec = "5 minutes";
      wantedBy = [ "multi-user.target" ];
      after = [ "openproject-seeder.service" ];
    };

    services.memcached = {
      enable = true;
      enableUnixSocket = true;
    };

    systemd.tmpfiles.rules = [
      "d ${cfg.statePath} 0750 openproject openproject"
    ];

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

  };
}
