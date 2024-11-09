{ lib, pkgs, config, ... }:
# TODO: OTEL stuff
let
  inherit (lib) mkIf mkOption mkEnableOption mkPackageOptionMD mkDefault mdDoc concatStringsSep mapAttrsToList;
  cfg = config.services.baserow;
  penv = cfg.package.python.buildEnv.override {
    extraLibs = [
      (cfg.package.python.pkgs.toPythonModule cfg.package)
    ];
  };
  ui = cfg.package.ui;
  pythonPath = "${penv}/${cfg.package.python.sitePackages}/";
  defaultEnvironment = cfg.environment // {
    PYTHONPATH = pythonPath;
  };
<<<<<<< HEAD
=======
  templateNuxtProdConfig = pkgs.writeText "nuxt.config.prod.js.in" ''
  import base from './nuxt.config.base.js';

  export default base(
    @baseModules@,
    @premiumModules@,
    @enterpriseModules@
  )
  '';
  environmentAsFile = pkgs.writeText "baserow-environment" (concatStringsSep "\n"
    (mapAttrsToList (key: value: "${key}=\"${toString value}\"") cfg.environment));
  # TODO: handle env file and secrets.
  baserowManageScript = pkgs.writeShellScriptBin "baserow-manage" ''
    set -a
    export PYTHONPATH=${cfg.package.pythonPath}
    source ${cfg.secretFile}
    source ${environmentAsFile}
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
        BASEROW_TRIGGER_SYNC_TEMPLATES_AFTER_MIGRATION = mkDefault "false";
        NUXT_TELEMETRY_DISABLED = mkDefault "1";
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
              ${baserowManageScript}/bin/baserow-manage sync_templates
            '';
          };
        };
        baserow-nuxt = {
          description = "Baserow Nuxt service (frontend)";
          wantedBy = [ "baserow.target" ];
          requires = [ "baserow-prepare.service" ];
          after = [ "baserow-prepare.service" ];

          environment = defaultEnvironment // {
            NODE_MODULES = "${ui}/node_modules";
            NODE_OPTIONS = "--openssl-legacy-provider";
          };

          preStart = ''
            ln -sf ${ui}/.nuxt /var/lib/baserow/.nuxt
          '';

          serviceConfig = defaultServiceConfig // {
            WorkingDirectory = "/var/lib/baserow";
            # https://github.com/nuxt/nuxt/issues/20714
            ExecStart = ''
              ${ui}/node_modules/.bin/nuxt start
=======
            NODE_OPTIONS = "--openssl-legacy-provider --dns-result-order=verbatim";
          };

          preStart = ''
            ln -sf ${ui}/web-frontend/.nuxt /var/lib/baserow/frontend/
            ln -sf ${ui}/premium /var/lib/baserow/
            ln -sf ${ui}/enterprise /var/lib/baserow/
            ln -sf ${ui}/web-frontend/modules /var/lib/baserow/frontend/
            mkdir -p /var/lib/baserow/frontend/config
            ${pkgs.xorg.lndir}/bin/lndir -ignorelinks ${ui}/web-frontend/config /var/lib/baserow/frontend/config
            ln -sf ${(pkgs.substituteAll {
              src = templateNuxtProdConfig;
              baseImport = "${ui}/web-frontend/config/nuxt.config.base.js";
              baseModules = "${ui}/web-frontend";
              premiumModules = "${ui}/premium/web-frontend";
              enterpriseModules = "${ui}/enterprise/web-frontend";
            })} /var/lib/baserow/frontend/config/nuxt.config.prod.js
          '';

          serviceConfig = defaultServiceConfig // {
            WorkingDirectory = "/var/lib/baserow/frontend";
            StateDirectory = [ "baserow" "baserow/frontend" ];
            # https://github.com/nuxt/nuxt/issues/20714
            ExecStart = ''
              ${ui}/web-frontend/node_modules/.bin/nuxt start --config-file config/nuxt.config.local.js
>>>>>>> e3b5d8d20811 (nixos module)
            '';
          };
        };
        baserow-wsgi = {
          description = "Baserow WSGI service (backend)";
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
