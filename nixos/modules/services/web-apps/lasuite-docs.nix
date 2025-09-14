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
    match
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    optional
    optionalString
    ;

  cfg = config.services.lasuite-docs;

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

  proxySuffix = if match "unix:.*" cfg.bind != null then ":" else "";

  commonServiceConfig = {
    RuntimeDirectory = "lasuite-docs";
    StateDirectory = "lasuite-docs";
    WorkingDirectory = "/var/lib/lasuite-docs";

    User = "lasuite-docs";
    DynamicUser = true;
    SupplementaryGroups = mkIf cfg.redis.createLocally [
      config.services.redis.servers.lasuite-docs.group
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
  };
in
{
  options.services.lasuite-docs = {
    enable = mkEnableOption "SuiteNumérique Docs";

    backendPackage = mkPackageOption pkgs "lasuite-docs" { };

    frontendPackage = mkPackageOption pkgs "lasuite-docs-frontend" { };

    bind = mkOption {
      type = types.str;
      default = "unix:/run/lasuite-docs/gunicorn.sock";
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
          Configure local PostgreSQL database server for docs.
        '';
      };
    };

    redis = {
      createLocally = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Configure local Redis cache server for docs.
        '';
      };
    };

    collaborationServer = {
      package = mkPackageOption pkgs "lasuite-docs-collaboration-server" { };

      port = mkOption {
        type = types.port;
        default = 4444;
        description = ''
          Port used by the collaboration server to listen.
        '';
      };

      settings = mkOption {
        type = types.submodule {
          freeformType = types.attrsOf (
            types.oneOf [
              types.str
              types.bool
            ]
          );

          options = {
            PORT = mkOption {
              type = types.str;
              default = toString cfg.collaborationServer.port;
              readOnly = true;
              description = "Port used by collaboration server to listen to";
            };

            COLLABORATION_BACKEND_BASE_URL = mkOption {
              type = types.str;
              default = "https://${cfg.domain}";
              defaultText = lib.literalExpression "https://\${cfg.domain}";
              description = "URL to the backend server base";
            };

            COLLABORATION_SERVER_ORIGIN = mkOption {
              type = types.str;
              default = "https://${cfg.domain}";
              defaultText = lib.literalExpression "https://\${cfg.domain}";
              description = "Origins allowed to connect to the collaboration server";
            };
          };
        };
        default = { };
        example = ''
          {
            COLLABORATION_LOGGING = true;
          }
        '';
        description = ''
          Configuration options of collaboration server.

          See <https://github.com/suitenumerique/docs/blob/v${cfg.collaborationServer.package.version}/docs/env.md>
        '';
      };
    };

    gunicorn = {
      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [
          "--name=impress"
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
        Domain name of the docs instance.
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
            default = "impress.settings";
            description = "The configuration module that Django will use";
          };

          DJANGO_SECRET_KEY_FILE = mkOption {
            type = types.path;
            default =
              if cfg.secretKeyPath == null then "/var/lib/lasuite-docs/django_secret_key" else cfg.secretKeyPath;
            description = "The path to the file containing Django's secret key";
          };

          DATA_DIR = mkOption {
            type = types.path;
            default = "/var/lib/lasuite-docs";
            description = "Path to the data directory";
          };

          DJANGO_ALLOWED_HOSTS = mkOption {
            type = types.str;
            default = if cfg.enableNginx then "localhost,127.0.0.1,${cfg.domain}" else "";
            defaultText = lib.literalExpression ''
              if cfg.enableNginx then "localhost,127.0.0.1,''${cfg.domain}" else ""
            '';
            description = "Comma-separated list of hosts that are able to connect to the server";
          };

          DB_NAME = mkOption {
            type = types.str;
            default = "lasuite-docs";
            description = "Name of the database";
          };

          DB_USER = mkOption {
            type = types.str;
            default = "lasuite-docs";
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
                "unix://${config.services.redis.servers.lasuite-docs.unixSocket}?db=0"
              else
                null;
            description = "URL of the redis backend";
          };

          CELERY_BROKER_URL = mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.redis.createLocally then
                "redis+socket://${config.services.redis.servers.lasuite-docs.unixSocket}?db=1"
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
        Configuration options of docs.

        See <https://github.com/suitenumerique/docs/blob/v${cfg.backendPackage.version}/docs/env.md>

        `REDIS_URL` and `CELERY_BROKER_URL` are set if `services.lasuite-docs.redis.createLocally` is true.
        `DB_HOST` is set if `services.lasuite-docs.postgresql.createLocally` is true.
      '';
    };

    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to environment file.

        This can be useful to pass secrets to docs via tools like `agenix` or `sops`.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.lasuite-docs = {
      description = "Docs from SuiteNumérique";
      after = [
        "network.target"
      ]
      ++ (optional cfg.postgresql.createLocally "postgresql.target")
      ++ (optional cfg.redis.createLocally "redis-lasuite-docs.service");
      wants =
        (optional cfg.postgresql.createLocally "postgresql.target")
        ++ (optional cfg.redis.createLocally "redis-lasuite-docs.service");
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        if [ ! -f .version ]; then
          touch .version
        fi

        ${optionalString (cfg.secretKeyPath == null) ''
          if [[ ! -f /var/lib/lasuite-docs/django_secret_key ]]; then
            (
              umask 0377
              tr -dc A-Za-z0-9 < /dev/urandom | head -c64 | ${pkgs.moreutils}/bin/sponge /var/lib/lasuite-docs/django_secret_key
            )
          fi
        ''}
        if [ "${cfg.backendPackage.version}" != "$(cat .version)" ]; then
          ${getExe cfg.backendPackage} migrate
          echo -n "${cfg.backendPackage.version}" > .version
        fi
      '';

      environment = pythonEnvironment;

      serviceConfig = {
        BindReadOnlyPaths = "${cfg.backendPackage}/share/static:/var/lib/lasuite-docs/static";

        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe' cfg.backendPackage "gunicorn")
            "--bind=${cfg.bind}"
          ]
          ++ cfg.gunicorn.extraArgs
          ++ [ "impress.wsgi:application" ]
        );
        EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
        MemoryDenyWriteExecute = true;
      }
      // commonServiceConfig;
    };

    systemd.services.lasuite-docs-celery = {
      description = "Docs Celery broker from SuiteNumérique";
      after = [
        "network.target"
      ]
      ++ (optional cfg.postgresql.createLocally "postgresql.target")
      ++ (optional cfg.redis.createLocally "redis-lasuite-docs.service");
      wants =
        (optional cfg.postgresql.createLocally "postgresql.target")
        ++ (optional cfg.redis.createLocally "redis-lasuite-docs.service");
      wantedBy = [ "multi-user.target" ];

      environment = pythonEnvironment;

      serviceConfig = {
        ExecStart = utils.escapeSystemdExecArgs (
          [
            (lib.getExe' cfg.backendPackage "celery")
          ]
          ++ cfg.celery.extraArgs
          ++ [
            "--app=impress.celery_app"
            "worker"
          ]
        );
        EnvironmentFile = optional (cfg.environmentFile != null) cfg.environmentFile;
        MemoryDenyWriteExecute = true;
      }
      // commonServiceConfig;
    };

    systemd.services.lasuite-docs-collaboration-server = {
      description = "Docs Collaboration Server from SuiteNumérique";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      environment = cfg.collaborationServer.settings;

      serviceConfig = {
        ExecStart = getExe cfg.collaborationServer.package;
      }
      // commonServiceConfig;
    };

    services.postgresql = mkIf cfg.postgresql.createLocally {
      enable = true;
      ensureDatabases = [ "lasuite-docs" ];
      ensureUsers = [
        {
          name = "lasuite-docs";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.lasuite-docs = mkIf cfg.redis.createLocally { enable = true; };

    services.nginx = mkIf cfg.enableNginx {
      enable = true;

      virtualHosts.${cfg.domain} = {
        extraConfig = ''
          error_page 401 /401;
          error_page 403 /403;
          error_page 404 /404;
        '';

        root = cfg.frontendPackage;

        locations."~ '^/docs/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/?$'" = {
          tryFiles = "$uri /docs/[id]/index.html";
        };

        locations."/api" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
        };

        locations."/admin" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
        };

        locations."/collaboration/ws/" = {
          proxyPass = "http://localhost:${toString cfg.collaborationServer.port}";
          recommendedProxySettings = true;
          proxyWebsockets = true;
        };

        locations."/collaboration/api/" = {
          proxyPass = "http://localhost:${toString cfg.collaborationServer.port}";
          recommendedProxySettings = true;
        };

        locations."/media-auth" = {
          proxyPass = "http://${cfg.bind}${proxySuffix}/api/v1.0/documents/media-auth/";
          recommendedProxySettings = true;
          extraConfig = ''
            proxy_set_header X-Original-URL $request_uri;
            proxy_pass_request_body off;
            proxy_set_header Content-Length "";
            proxy_set_header X-Original-Method $request_method;
          '';
        };

        locations."/media/" = {
          proxyPass = cfg.s3Url;
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
