{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  inherit (lib)
    getExe
    mapAttrs
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    optional
    optionalString
    ;

  cfg = config.services.lasuite-drive;

  pythonEnvironment = mapAttrs (
    _: value:
    if value == null then
      "None"
    else if value == true then
      "True"
    else if value == false then
      "False"
    else
      toString value
  ) cfg.settings;

  commonServiceConfig = {
    RuntimeDirectory = "lasuite-drive";
    StateDirectory = "lasuite-drive";
    WorkingDirectory = "/var/lib/lasuite-drive";

    User = "lasuite-drive";
    DynamicUser = true;
    SupplementaryGroups = mkIf cfg.redis.createLocally [
      config.services.redis.servers.lasuite-drive.group
    ];
    # hardening
    AmbientCapabilities = "";
    CapabilityBoundingSet = [ "" ];
    DevicePolicy = "closed";
    LockPersonality = true;
    NoNewPrivileges = true;
    PrivateDevices = true;
    PrivateTmp = true;
    PrivateUsers = true;
    ProcSubset = "pid";
    ProtectClock = true;
    ProtectControlGroups = true;
    ProtectHome = true;
    ProtectHostname = true;
    ProtectKernelLogs = true;
    ProtectKernelModules = true;
    ProtectKernelTunables = true;
    ProtectProc = "invisible";
    ProtectSystem = "strict";
    RemoveIPC = true;
    MemoryDenyWriteExecute = true;
    RestrictAddressFamilies = [
      "AF_INET"
      "AF_INET6"
      "AF_UNIX"
    ];
    RestrictNamespaces = true;
    RestrictRealtime = true;
    RestrictSUIDSGID = true;
    SystemCallArchitectures = "native";
    UMask = "0077";
    EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
  };
in
{
  options.services.lasuite-drive = {
    enable = mkEnableOption "SuiteNumérique Drive";

    backendPackage = mkPackageOption pkgs "lasuite-drive" { };

    frontendPackage = mkPackageOption pkgs "lasuite-drive-frontend" { };

    bind = mkOption {
      type = types.str;
      default = "unix:/run/lasuite-drive/gunicorn.sock";
      example = "127.0.0.1:8000";
      description = ''
        The path, host/port or file descriptior to bind the gunicorn socket to.

        See  <https://docs.gunicorn.org/en/stable/settings.html#bind> for possible options.
      '';
    };

    enableNginx = mkEnableOption "enable and configure Nginx for reverse proxying" // {
      default = true;
    };

    secretKeyPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to the Django secret key.

        The key can be generated using:
        ```
        python3 -c 'import secrets; print(secrets.token_hex())'
        ```

        If not set, the secret key will be automatically generated.
      '';
    };

    s3Url = mkOption {
      type = types.str;
      description = ''
        URL of the S3 bucket.
      '';
    };

    postgresql = {
      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Configure local PostgreSQL database server for drive.
        '';
      };
    };

    redis = {
      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Configure local Redis cache server for drive.
        '';
      };
    };

    gunicorn = {
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [
          "--name=drive"
          "--workers=3"
        ];
        description = ''
          Extra arguments to pass to the gunicorn process.
        '';
      };
    };

    celery = {
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [ ];
        description = ''
          Extra arguments to pass to the celery process.
        '';
      };
    };

    domain = mkOption {
      type = types.str;
      description = ''
        Domain name of the drive instance.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType = types.attrsOf (
          types.nullOr (
            types.oneOf [
              types.str
              types.bool
              types.path
              types.int
            ]
          )
        );

        options = {
          DJANGO_CONFIGURATION = mkOption {
            type = types.str;
            internal = true;
            default = "Production";
            description = "The configuration that Django will use";
          };

          DJANGO_SETTINGS_MODULE = mkOption {
            type = types.str;
            internal = true;
            default = "drive.settings";
            description = "The configuration module that Django will use";
          };

          DJANGO_SECRET_KEY_FILE = mkOption {
            type = types.path;
            default =
              if cfg.secretKeyPath == null then "/var/lib/lasuite-drive/django_secret_key" else cfg.secretKeyPath;
            description = "The path to the file containing Django's secret key";
          };

          DATA_DIR = mkOption {
            type = types.path;
            default = "/var/lib/lasuite-drive";
            description = "Path to the data directory";
          };

          DJANGO_ALLOWED_HOSTS = mkOption {
            type = types.str;
            default = if cfg.enableNginx then "localhost,127.0.0.1,${cfg.domain}" else "";
            defaultText = lib.literalExpression ''
              if cfg.enableNginx then "localhost,127.0.0.1,$${cfg.domain}" else ""
            '';
            description = "Comma-separated list of hosts that are able to connect to the server";
          };

          DB_NAME = mkOption {
            type = types.str;
            default = "lasuite-drive";
            description = "Name of the database";
          };

          DB_USER = mkOption {
            type = types.str;
            default = "lasuite-drive";
            description = "User of the database";
          };

          DB_HOST = mkOption {
            type = types.nullOr types.str;
            default = if cfg.postgresql.createLocally then "/run/postgresql" else null;
            description = "Host of the database";
          };

          REDIS_URL = mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.redis.createLocally then
                "unix://${config.services.redis.servers.lasuite-drive.unixSocket}?db=1"
              else
                null;
            description = "URL of the redis backend";
          };

          CELERY_BROKER_URL = mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.redis.createLocally then
                "redis+socket://${config.services.redis.servers.lasuite-drive.unixSocket}?db=2"
              else
                null;
            description = "URL of the redis backend for celery";
          };
        };
      };
      default = { };
      example = ''
        {
          DJANGO_ALLOWED_HOSTS = "*";
        }
      '';
      description = ''
        Configuration options of drive.

        See https://github.com/suitenumerique/drive/blob/${cfg.backendPackage.src.rev}/docs/env.md

        `REDIS_URL` and `CELERY_BROKER_URL` are set if `services.lasuite-drive.redis.createLocally` is true.
        `DB_HOST` is set if `services.lasuite-drive.postgresql.createLocally` is true.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to environment file.

        This can be useful to pass secrets to drive via tools like `agenix` or `sops`.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lasuite-drive = {
      description = "Drive from SuiteNumérique";
      after =
        [ "network.target" ]
        ++ (optional cfg.postgresql.createLocally "postgresql.service")
        ++ (optional cfg.redis.createLocally "redis-lasuite-drive.service");
      wants =
        (optional cfg.postgresql.createLocally "postgresql.service")
        ++ (optional cfg.redis.createLocally "redis-lasuite-drive.service");
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        ln -sfT ${cfg.backendPackage}/share/static /var/lib/lasuite-drive/static

        if [ ! -f .version ]; then
          touch .version
        fi

        if [ "${cfg.backendPackage.version}" != "$(cat .version)" ]; then
          ${getExe cfg.backendPackage} migrate
          echo -n "${cfg.backendPackage.version}" > .version
        fi
        ${optionalString (cfg.secretKeyPath == null) ''
          if [[ ! -f /var/lib/lasuite-drive/django_secret_key ]]; then
            (
              umask 0377
              tr -dc A-Za-z0-9 < /dev/urandom | head -c64 | ${pkgs.moreutils}/bin/sponge /var/lib/lasuite-drive/django_secret_key
            )
          fi
        ''}
      '';

      environment = pythonEnvironment;

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe' cfg.backendPackage "gunicorn")
            "--bind=${cfg.bind}"
          ]
          ++ cfg.gunicorn.extraArgs
          ++ [ "drive.wsgi:application" ]
        );
      } // commonServiceConfig;
    };

    systemd.services.lasuite-drive-celery = {
      description = "Docs Celery broker from SuiteNumérique";
      after =
        [ "network.target" ]
        ++ (optional cfg.postgresql.createLocally "postgresql.service")
        ++ (optional cfg.redis.createLocally "redis-lasuite-drive.service");
      wants =
        (optional cfg.postgresql.createLocally "postgresql.service")
        ++ (optional cfg.redis.createLocally "redis-lasuite-drive.service");
      wantedBy = [ "multi-user.target" ];

      environment = pythonEnvironment;

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [ (lib.getExe' cfg.backendPackage "celery") ]
          ++ cfg.celery.extraArgs
          ++ [
            "--app=drive.celery_app"
            "worker"
          ]
        );
      } // commonServiceConfig;
    };

    services.postgresql = mkIf cfg.postgresql.createLocally {
      enable = true;
      ensureDatabases = [ "lasuite-drive" ];
      ensureUsers = [
        {
          name = "lasuite-drive";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.lasuite-drive = mkIf cfg.redis.createLocally { enable = true; };

    services.nginx = mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        extraConfig = ''
          error_page 404 /404.html;
        '';

        root = cfg.frontendPackage;

        locations."/" = {
          tryFiles = "$uri index.html $uri/ =404";
        };

        locations."~ '^/explorer/items/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/?$'" =
          {
            tryFiles = "$uri /explorer/items/[id].html";
          };

        locations."~ '^/sdk/explorer/items/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/?$'" =
          {
            tryFiles = "$uri /sdk/explorer/items/[id].html";
          };

        locations."/api" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
        };

        locations."/admin" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
        };

        locations."/media-auth" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
          extraConfig = ''
            rewrite $/(.*)^ /api/v1.0/documents/$1 break;

            proxy_set_header Host $host;
            proxy_set_header X-Original-URL $request_uri;

            proxy_pass_request_body off;
            proxy_set_header Content-Length "";
            proxy_set_header X-Original-Method $request_method;
          '';
        };

        locations."/media/" = {
          proxyPass = cfg.s3Url;
          recommendedProxySettings = true;
          extraConfig = ''
            auth_request /media-auth;
            auth_request_set $authHeader $upstream_http_authorization;
            auth_request_set $authDate $upstream_http_x_amz_date;
            auth_request_set $authContentSha256 $upstream_http_x_amz_content_sha256;

            proxy_set_header Authorization $authHeader;
            proxy_set_header X-Amz-Date $authDate;
            proxy_set_header X-Amz-Content-SHA256 $authContentSha256;

            add_header Content-Security-Policy "default-src 'none'" always;
          '';
        };
      };
    };
  };

  meta = {
    buildDocsInSandbox = false;
    maintainers = [ lib.maintainers.soyouzpanda ];
  };
}
