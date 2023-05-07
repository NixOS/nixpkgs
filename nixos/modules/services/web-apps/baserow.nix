{ lib, pkgs, config, ... }:
# TODO: OTEL stuff
let
  inherit (lib) mkIf mkOption mkEnableOption mkPackageOptionMD mkDefault mdDoc;
  cfg = config.services.baserow;
  penv = cfg.package.python.buildEnv.override {
    extraLibs = [
      (cfg.package.python.pkgs.toPythonModule cfg.package)
    ];
  };
  pythonPath = "${penv}/${cfg.package.python.sitePackages}/";
  defaultEnvironment = cfg.environment // {
    PYTHONPATH = pythonPath;
  };
  # TODO: handle env file and secrets.
  baserowManageScript = pkgs.writeShellScriptBin "baserow-manage" ''
    set -a
    export PYTHONPATH=${cfg.package.pythonPath}
    sudo=exec
    if [[ "$USER" != baserow ]]; then
      sudo='exec /run/wrappers/bin/sudo -u baserow --preserve-env'
    fi
    $sudo ${cfg.package}/bin/baserow "$@"
  '';
in
  {
    options.services.baserow = {
      enable = mkEnableOption (mdDoc "baserow, you need to provide your own reverse proxy server");
      package = mkPackageOptionMD pkgs "baserow" {};

      listenAddress = mkOption {
        type = lib.types.str;
        default = "[::1]";
        description = lib.mdDoc ''
          Address the server will listen on.
        '';
      };

      port = mkOption {
        type = lib.types.port;
        default = 8000;
        description = lib.mdDoc ''
          Port the server will listen on.
        '';
      };

      environment = mkOption {
        type = lib.types.submodule {
          freeformType = with lib.types; attrsOf (oneOf [ int str path ]);
        };
        default = {};
        description = "Environment variables passed to Baserow, use this to configure the service.";
      };
      secretFile = mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = "Secrets that should not end up in the Nix store.";
      };
    };

    config = mkIf cfg.enable {
      services.baserow.environment = {
        DATABASE_URL = mkDefault "postgresql:///baserow";
        REDIS_URL = mkDefault "redis+socket://${config.services.redis.servers.baserow.unixSocket}";
        REDIS_BEAT_URL = mkDefault "unix://${config.services.redis.servers.baserow.unixSocket}";
        DJANGO_REDIS_URL = mkDefault "unix://${config.services.redis.servers.baserow.unixSocket}";
        DJANGO_CHANNEL_REDIS_URL = mkDefault "unix://${config.services.redis.servers.baserow.unixSocket}";
        DJANGO_SETTINGS_MODULE = mkDefault "baserow.config.settings.base";
      };

      services.redis.servers.baserow.enable = true;
      services.postgresql = {
        enable = true;
        ensureDatabases = [ "baserow" ];
        ensureUsers = [
          {
            name = "baserow";
            ensurePermissions."DATABASE baserow" = "ALL PRIVILEGES";
          }
        ];
      };

      environment.systemPackages = [ baserowManageScript ];
      systemd.targets.baserow = {
        description = "Target for all Baserow services";
        wantedBy = [ "multi-user.target" ];
        after = [ "network-online.target" "redis-baserow.service" ];
      };

      systemd.services =
      let
        defaultServiceConfig = {
          WorkingDirectory = "/var/lib/baserow";
          User = "baserow";
          Group = "baserow";
          StateDirectory = "baserow";
          StateDirectoryMode = "0750";
          Restart = "on-failure";

          EnvironmentFile = mkIf (cfg.secretFile != null) [ cfg.secretFile ];
        };
      in
      {
        baserow-prepare = {
          description = "Baserow migrations & misc service";
          wantedBy = [ "baserow.target" ];
          after = [ "postgresql.service" ];

          environment = defaultEnvironment;
          path = [ baserowManageScript ];

          serviceConfig = defaultServiceConfig // {
            Type = "oneshot";
            ExecStart = ''
              ${baserowManageScript}/bin/baserow-manage migrate
              # When BASEROW_TRIGGER_SYNC_TEMPLATES_AFTER_MIGRATION is true
              # We don't need to do it.
              # baserow-manage sync_templates
            '';
          };
        };
        baserow-wsgi = {
          description = "Baserow WSGI service";
          wantedBy = [ "baserow.target" ];
          requires = [ "baserow-prepare.service" ];
          after = [ "baserow-prepare.service" ];

          environment = defaultEnvironment;

          # On worker temp dir: https://github.com/bram2w/baserow/blob/master/backend/docker/docker-entrypoint.sh#L205C12-L206
          serviceConfig = defaultServiceConfig // {
            RuntimeDirectory = "baserow";
            ExecStart = ''
            ${cfg.package.python.pkgs.gunicorn}/bin/gunicorn \
            -k uvicorn.workers.UvicornWorker \
            baserow.config.asgi:application \
            --worker-tmp-dir=/run/baserow \
            --log-file=- \
            --access-logfile=- \
            --capture-output \
            --bind ${cfg.listenAddress}:${toString cfg.port} \
            '';
          };
        };
        baserow-celery-worker = {
          description = "Baserow Celery workers service";
          wantedBy = [ "baserow.target" ];
          requires = [ "baserow-wsgi.service" ];
          after = [ "baserow-wsgi.service" ];

          environment = defaultEnvironment;

          serviceConfig = defaultServiceConfig // {
            ExecStart = ''
            ${cfg.package.python.pkgs.celery}/bin/celery -A baserow worker \
            -l INFO \
            -Q celery,export \
            -n "default-worker@%h"
            '';
          };
        };
        # baserow-celery-exportworker = {};
        baserow-celery-beat = {
          description = "Baserow scheduler service";
          wantedBy = [ "baserow.target" ];
          requires = [ "baserow-celery-worker.service" ];
          after = [ "baserow-celery-worker.service" ];

          environment = defaultEnvironment;

          serviceConfig = defaultServiceConfig // {
            ExecStart = ''
            ${cfg.package.python.pkgs.celery}/bin/celery -A baserow beat \
            -l INFO \
            -S redbeat.RedBeatScheduler
            '';
          };
        };
      };

    users.users.baserow = {
      isSystemUser = true;
      group = "baserow";
    };
    users.groups.baserow = {};
    users.groups."${config.services.redis.servers.baserow.user}".members = [ "baserow" ];
  };
}
