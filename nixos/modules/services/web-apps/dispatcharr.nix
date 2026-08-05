{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.dispatcharr;

  python = cfg.package.python;
  pythonSitePackages = python.sitePackages;

  # Dispatcharr hard-codes BASE_DIR to the read-only site-packages directory in
  # its upstream settings.py, which breaks static/media/backup paths at runtime.
  # Load a tiny shim after the upstream settings so all mutable paths live under
  # the NixOS state directory.
  nixosSettingsFile = pkgs.writeTextFile {
    name = "dispatcharr-nixos-settings.py";
    text = ''
      from dispatcharr.settings import *
      import os
      from pathlib import Path

      BASE_DIR = Path(os.environ.get("DISPATCHARR_STATE_DIRECTORY", "${cfg.dataDir}"))
      STATIC_ROOT = BASE_DIR / "static"
      MEDIA_ROOT = BASE_DIR / "media"
      BACKUP_ROOT = BASE_DIR / "backups"
      DATA_DIR = os.environ.get("DISPATCHARR_DATA_DIRECTORY", str(BASE_DIR / "data"))
      BACKUP_DATA_DIRS = [
          os.path.join(DATA_DIR, "logos"),
          os.path.join(DATA_DIR, "uploads"),
          os.path.join(DATA_DIR, "plugins"),
      ]
    '';
  };

  nixosSettingsPackage = pkgs.runCommand "dispatcharr-nixos-settings" { } ''
    install -Dm644 ${nixosSettingsFile} $out/${pythonSitePackages}/dispatcharr_nixos_settings.py
  '';

  pythonPath = lib.concatStringsSep ":" [
    cfg.package.pythonPath
    "${nixosSettingsPackage}/${pythonSitePackages}"
  ];

  envVars = {
    DJANGO_SETTINGS_MODULE = "dispatcharr_nixos_settings";
    PYTHONPATH = lib.concatStringsSep ":" [
      pythonPath
      "${cfg.package}/${cfg.package.python.sitePackages}"
    ];
    DISPATCHARR_STATE_DIRECTORY = cfg.dataDir;
    DISPATCHARR_DATA_DIRECTORY = "${cfg.dataDir}/data";
    DISPATCHARR_PLUGINS_DIR = "${cfg.dataDir}/data/plugins";
    # Redis settings are read from environment variables by upstream.
    REDIS_HOST = "localhost";
    REDIS_PORT = toString config.services.redis.servers.dispatcharr.port;
    REDIS_DB = "0";
    # PostgreSQL settings are read from environment variables by upstream.
    DB_ENGINE = "postgresql";
    POSTGRES_DB = "dispatcharr";
    POSTGRES_USER = "dispatcharr";
    POSTGRES_HOST = "/run/postgresql";
    POSTGRES_PORT = "5432";
  };

  manage = "${cfg.package}/bin/dispatcharr-manage";
in
{
  options.services.dispatcharr = {
    enable = lib.mkEnableOption "Dispatcharr, an IPTV stream management companion";

    package = lib.mkPackageOption pkgs "dispatcharr" { };

    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/dispatcharr";
      description = "Directory where Dispatcharr stores mutable data.";
    };

    secretKeyFile = lib.mkOption {
      type = lib.types.path;
      example = "/run/secrets/dispatcharr-secret-key";
      description = ''
        Path to a file containing the Django secret key.

        This file is loaded as a systemd EnvironmentFile and should contain a
        single line of the form `DJANGO_SECRET_KEY=your-secret-key`.
      '';
    };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address the Dispatcharr web interface will listen on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8000;
      description = "Port the Dispatcharr web interface will listen on.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Open ports in the firewall for the Dispatcharr web interface.";
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.secretKeyFile != null;
        message = "services.dispatcharr.secretKeyFile must be set.";
      }
    ];

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "dispatcharr" ];
      ensureUsers = [
        {
          name = "dispatcharr";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.dispatcharr = {
      enable = true;
      bind = "127.0.0.1";
      port = 6379;
    };

    systemd.tmpfiles.settings."10-dispatcharr".${cfg.dataDir} = {
      d = {
        user = "dispatcharr";
        group = "dispatcharr";
        mode = "0750";
      };
    };

    systemd.services.dispatcharr-migrations = {
      description = "Dispatcharr database migrations";
      wantedBy = [ "dispatcharr.target" ];
      after = [
        "network-online.target"
        "postgresql.service"
        "redis-dispatcharr.service"
      ];
      requires = [
        "postgresql.service"
        "redis-dispatcharr.service"
      ];
      environment = envVars;
      serviceConfig = {
        Type = "oneshot";
        User = "dispatcharr";
        Group = "dispatcharr";
        EnvironmentFile = cfg.secretKeyFile;
        StateDirectory = "dispatcharr";
        StateDirectoryMode = "0750";
        WorkingDirectory = cfg.dataDir;
        ExecStart = manage + " migrate --no-input";
      };
    };

    systemd.services.dispatcharr-collectstatic = {
      description = "Dispatcharr collectstatic";
      wantedBy = [ "dispatcharr.target" ];
      after = [ "dispatcharr-migrations.service" ];
      environment = envVars;
      serviceConfig = {
        Type = "oneshot";
        User = "dispatcharr";
        Group = "dispatcharr";
        EnvironmentFile = cfg.secretKeyFile;
        StateDirectory = "dispatcharr";
        StateDirectoryMode = "0750";
        WorkingDirectory = cfg.dataDir;
        ExecStart = manage + " collectstatic --no-input";
      };
    };

    systemd.services.dispatcharr = {
      description = "Dispatcharr web interface";
      wantedBy = [ "dispatcharr.target" ];
      after = [
        "network-online.target"
        "dispatcharr-migrations.service"
        "dispatcharr-collectstatic.service"
      ];
      environment = envVars;
      serviceConfig = {
        Type = "simple";
        User = "dispatcharr";
        Group = "dispatcharr";
        EnvironmentFile = cfg.secretKeyFile;
        StateDirectory = "dispatcharr";
        StateDirectoryMode = "0750";
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${python.pkgs.daphne}/bin/daphne -b ${cfg.listenAddress} -p ${toString cfg.port} dispatcharr.asgi:application";
        Restart = "on-failure";
      };
    };

    systemd.services.dispatcharr-worker = {
      description = "Dispatcharr Celery worker";
      wantedBy = [ "dispatcharr.target" ];
      after = [
        "network-online.target"
        "dispatcharr-migrations.service"
        "dispatcharr.service"
      ];
      environment = envVars;
      serviceConfig = {
        Type = "simple";
        User = "dispatcharr";
        Group = "dispatcharr";
        EnvironmentFile = cfg.secretKeyFile;
        StateDirectory = "dispatcharr";
        StateDirectoryMode = "0750";
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${python.pkgs.celery}/bin/celery -A dispatcharr worker --loglevel=info";
        Restart = "on-failure";
      };
    };

    systemd.services.dispatcharr-beat = {
      description = "Dispatcharr Celery beat scheduler";
      wantedBy = [ "dispatcharr.target" ];
      after = [
        "network-online.target"
        "dispatcharr-migrations.service"
        "dispatcharr.service"
      ];
      environment = envVars;
      serviceConfig = {
        Type = "simple";
        User = "dispatcharr";
        Group = "dispatcharr";
        EnvironmentFile = cfg.secretKeyFile;
        StateDirectory = "dispatcharr";
        StateDirectoryMode = "0750";
        WorkingDirectory = cfg.dataDir;
        ExecStart = "${python.pkgs.celery}/bin/celery -A dispatcharr beat --loglevel=info --scheduler django_celery_beat.schedulers:DatabaseScheduler";
        Restart = "on-failure";
      };
    };

    systemd.targets.dispatcharr = {
      description = "Target for all Dispatcharr services";
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
    };

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.port ];
    };

    users.users.dispatcharr = {
      isSystemUser = true;
      group = "dispatcharr";
      home = cfg.dataDir;
    };
    users.groups.dispatcharr = { };
  };

  meta = {
    doc = ./dispatcharr.md;
    maintainers = with lib.maintainers; [ staticdev ];
  };
}
