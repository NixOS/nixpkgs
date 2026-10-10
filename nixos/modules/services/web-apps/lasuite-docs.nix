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
    hasAttr
    mapAttrs
    match
    mkEnableOption
    mkIf
    mkPackageOption
    mkOption
    types
    optional
    optionalString
    escapeShellArg
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

  commonServiceConfig = commonServiceConfig' // {
    RuntimeDirectory = "lasuite-docs";
    StateDirectory = "lasuite-docs";
    WorkingDirectory = "/var/lib/lasuite-docs";
    User = "lasuite-docs";
  };

  commonServiceConfigYhub = commonServiceConfig' // {
    StateDirectory = "lasuite-docs-yhub-server";
    WorkingDirectory = "%S/lasuite-docs-yhub-server";
    User = "lasuite-docs-yhub-server";
    RuntimeDirectory = "lasuite-docs-yhub-server";
  };

  commonServiceConfig' = {
    DynamicUser = true;
    Slice = "system-lasuite-docs.slice";
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

  mkJWTPrivateKeySetupService = service: humanServiceName: defaults: {
    description = "Key setup for ${humanServiceName}";
    path = [ pkgs.openssl.bin ];
    unitConfig.ConditionPathExists = "!%S/${service}/private.pem";

    serviceConfig = defaults // {
      Type = "oneshot";
      ExecStart = "openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:2048 -out private.pem";
      ExecSearchPath = lib.makeBinPath [ pkgs.openssl.bin ];
    };
  };

  # Convert environment variables to be used as systemd-run arguments
  envArgs = lib.concatStringsSep " " (
    lib.mapAttrsToList (name: value: "-E ${escapeShellArg "${name}=${value}"}") pythonEnvironment
  );

  yhubEnv =
    lib.mapAttrs (
      _: val: if lib.isBool val then lib.boolToString val else toString val
    ) cfg.yhub.settings
    // lib.optionalAttrs cfg.postgresql.createLocally {
      PGHOST = "/run/postgresql";
      PGDATABASE = "lasuite-docs-yhub-server";
    };

  # Easier usage of django manage.py stuff
  manage = pkgs.writeShellScriptBin "lasuite-docs-manage" ''
    exec ${lib.getExe' config.systemd.package "systemd-run"} \
      -p User=${commonServiceConfig.User} -p DynamicUser=yes \
      -p StateDirectory=${commonServiceConfig.StateDirectory} --working-directory=${commonServiceConfig.WorkingDirectory} \
      --quiet --collect --pipe --pty \
      ${envArgs} ${lib.getExe cfg.backendPackage} "$@"
  '';
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

      port = mkOption {
        type = types.port;
        default = 26379;
        description = ''
          Port for the Redis instance of LaSuite docs.

          Please note that yhub uses `@redis/client@v5` which doesn't suport UDS.
        '';
      };

    };

    yhub = {
      package = mkPackageOption pkgs "lasuite-docs-yhub-server" { };

      settings = mkOption {
        description = ''
          Settings passed as environment variables to the Y collaboration server.
          By default, the migration mode from the old collaboration-server is enabled.
          To turn it off, set `SOFT_MIGRATION = false;` and disable the migration
          service by also setting [](#opt-services.lasuite-docs.collaborationServer.enable)
          to `true`.
        '';

        default = { };
        type = types.submodule {
          freeformType = types.attrsOf (
            types.oneOf [
              types.str
            ]
          );
          config = {
            POSTGRES = lib.mkIf (cfg.postgresql.createLocally) (lib.mkOptionDefault "");
          };
          options = {
            POSTGRES = mkOption {
              type = types.str;
              description = ''
                Connection URL to PostgreSQL.
                See the [upstream docs on the format](https://github.com/suitenumerique/docs/tree/v6.0.0/src/yhub-server#database-schema-yarn-init-db) for more information.
                It's possible to override parameters of this URL via
                [the supported environment variables](https://github.com/porsager/postgres/tree/v3.4.9#usage) of the client library.
                This is e.g. necessary since the URL format doesn't support declaring a UNIX socket.

                Set to an empty string if `services.lasuite-docs.postgresql.createLocally == true`.
              '';
            };

            REDIS = mkOption {
              type = types.nullOr types.str;
              defaultText = lib.literalExpression ''
                if config.services.lasuite-docs.redis.createLocally then
                  "redis://''${config.services.redis.servers.lasuite-docs.bind}:''${toString config.services.redis.servers.lasuite-docs.port}/2"
                else null
              '';
              default =
                if cfg.redis.createLocally then
                  "redis://${config.services.redis.servers.lasuite-docs.bind}:${toString config.services.redis.servers.lasuite-docs.port}/2"
                else
                  null;
              description = "URL of the redis backend";
            };

            YHUB_JWT_PRIVATE_KEY_FILE = mkOption {
              type = types.externalPath;
              default = "/var/lib/lasuite-docs-yhub-server/private.pem";
              description = ''
                Path to the RSA private key (PEM) yhub signs its calls to the backend with.
                Generated by `lasuite-docs-yhub-server-setup-keys.service`.
              '';
            };

            PORT = mkOption {
              type = types.port;
              default = 3002;
              description = "Port of Yhub server.";
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

            SOFT_MIGRATION = mkOption {
              type = types.bool;
              default = true;
              description = ''
                Whether we're in soft-migration mode where the old server is still used to import documents.
                See [Upgrade guide to v6 for more details](https://github.com/suitenumerique/docs/blob/v6.0.0/UPGRADE.md).
              '';
            };
          };
        };
      };
    };

    collaborationServer = {
      enable = mkEnableOption "legacy collaboration server" // {
        default = true;
      };

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
                "redis://${config.services.redis.servers.lasuite-docs.bind}:${toString config.services.redis.servers.lasuite-docs.port}/0"
              else
                null;
            description = "URL of the redis backend";
          };

          CELERY_BROKER_URL = mkOption {
            type = types.nullOr types.str;
            default =
              if cfg.redis.createLocally then
                "redis://${config.services.redis.servers.lasuite-docs.bind}:${toString config.services.redis.servers.lasuite-docs.port}/1"
              else
                null;
            description = "URL of the redis backend for celery";
          };

          JWT_PRIVATE_KEY_FILE = mkOption {
            type = types.externalPath;
            default = "/var/lib/lasuite-docs/private.pem";
            description = ''
              Path to the RSA private key (PEM) the backend signs its calls to the collaboration server with.
              Generated by `lasuite-docs-setup-keys.service`.
            '';
          };

          YHUB_API_BASE_URL = mkOption {
            default = "http://localhost:${toString cfg.yhub.settings.PORT}";
            defaultText = lib.literalExpression "http://localhost:\${cfg.yhub.settings.PORT}";
            type = types.str;
            description = "Internal base URL for the Y collaboration server.";
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
    systemd.slices.system-lasuite-docs = { };
    environment.systemPackages = [ manage ];

    assertions = [
      {
        assertion = cfg.collaborationServer.enable == cfg.yhub.settings.SOFT_MIGRATION;
        message = ''
          `services.lasuite-docs`: `yhub.SOFT_MIGRATION` and `collaborationServer.enable`
          must have the same value!
        '';
      }
    ];

    # Some settings options in LaSuite has been renamed in 5.0.0
    # Show warnings if those settings are not renamed
    # TODO: remove it when the retrocompatibility options will be gone
    warnings =
      (optional (hasAttr "AI_API_KEY" cfg.settings) "AI_API_KEY has been renamed as OPENAI_SDK_API_KEY in LaSuite Docs")
      ++ (optional (hasAttr "AI_API_KEY_FILE" cfg.settings) "AI_API_KEY_FILE has been renamed as OPENAI_SDK_API_KEY_FILE in LaSuite Docs")
      ++ (optional (hasAttr "AI_BASE_URL" cfg.settings) "AI_BASE_URL has been renamed as OPENAI_SDK_BASE_URL in LaSuite Docs")
      ++ optional (cfg.collaborationServer.enable) "services.lasuite-docs: collaboration server is deprecated and only used to migrate to the y-server. Read upstream migration docs (https://github.com/suitenumerique/docs/blob/v6.0.0/UPGRADE.md) for more details.";

    systemd.services.lasuite-docs-postgresql-setup = mkIf cfg.postgresql.createLocally {
      wantedBy = [ "lasuite-docs.target" ];
      requiredBy = [ "lasuite-docs.service" ];
      before = [ "lasuite-docs.service" ];
      after = [ "postgresql-setup.service" ];

      serviceConfig = {
        Slice = "system-lasuite-docs.slice";
        Type = "oneshot";
        User = "postgres";

        # lasuite-docs user cannot create a C function as it is unsafe.
        ExecStart = ''
          ${lib.getExe' config.services.postgresql.package "psql"} --port=${toString config.services.postgresql.settings.port} -d lasuite-docs -c "CREATE OR REPLACE FUNCTION public.immutable_unaccent(regdictionary, text) RETURNS text LANGUAGE c IMMUTABLE PARALLEL SAFE STRICT AS '$libdir/unaccent', 'unaccent_dict';"
        '';

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

    };

    systemd.services.lasuite-docs-yhub-server-setup-keys =
      mkJWTPrivateKeySetupService "lasuite-docs-yhub-server" "Y collaboration server of LaSuite docs"
        commonServiceConfigYhub;

    systemd.services.lasuite-docs-setup-keys =
      mkJWTPrivateKeySetupService "lasuite-docs" "LaSuite docs"
        commonServiceConfig;

    systemd.services.lasuite-docs-yhub-server-setup-db = {
      description = "DB setup for Y collaboration server of LaSuite docs";
      after = optional cfg.redis.createLocally "redis-lasuite-docs.service";
      wants = optional cfg.redis.createLocally "redis-lasuite-docs.service";
      environment = yhubEnv;
      serviceConfig = commonServiceConfigYhub // {
        Type = "oneshot";
        ExecStart = "${lib.getExe' cfg.yhub.package "y-init-db"}";
      };
    };

    systemd.services.lasuite-docs-yhub-server = {
      description = "Y collaboration server of LaSuite docs";
      environment = yhubEnv;
      wantedBy = [ "multi-user.target" ];
      after = [
        "lasuite-docs-yhub-server-setup-db.service"
        "lasuite-docs-yhub-server-setup-keys.service"
      ]
      ++ optional cfg.postgresql.createLocally "postgresql.target"
      ++ optional cfg.redis.createLocally "redis-lasuite-docs.service";
      requires = [
        "lasuite-docs-yhub-server-setup-db.service"
        "lasuite-docs-yhub-server-setup-keys.service"
      ];
      wants =
        (optional cfg.postgresql.createLocally "postgresql.target")
        ++ (optional cfg.redis.createLocally "redis-lasuite-docs.service");

      serviceConfig = commonServiceConfigYhub // {
        ExecStart = lib.getExe cfg.yhub.package;
      };
    };

    systemd.services.lasuite-docs = {
      description = "Docs from SuiteNumérique";
      after = [
        "network.target"
        "lasuite-docs-setup-keys.service"
      ]
      ++ (optional cfg.postgresql.createLocally "postgresql.target")
      ++ (optional cfg.redis.createLocally "redis-lasuite-docs.service");
      wants =
        (optional cfg.postgresql.createLocally "postgresql.target")
        ++ (optional cfg.redis.createLocally "redis-lasuite-docs.service");
      wantedBy = [ "multi-user.target" ];
      requires = [ "lasuite-docs-setup-keys.service" ];

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
      ensureDatabases = [
        "lasuite-docs"
        "lasuite-docs-yhub-server"
      ];
      ensureUsers = [
        {
          name = "lasuite-docs";
          ensureDBOwnership = true;
        }
        {
          name = "lasuite-docs-yhub-server";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.lasuite-docs = mkIf cfg.redis.createLocally {
      enable = true;
      inherit (cfg.redis) port;
    };

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

        locations."~ '^/user-reconciliations/(active|inactive)/[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}/?$'" =
          {
            tryFiles = "$uri /user-reconciliations/$1/[id]/index.html";
          };

        locations."/api" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
        };

        locations."/admin" = {
          proxyPass = "http://${cfg.bind}";
          recommendedProxySettings = true;
        };

        locations."/static/" = {
          alias = "${cfg.backendPackage}/share/static/";
        };

        locations."/collaboration/ws/v1/" = {
          proxyPass = "http://localhost:${toString cfg.yhub.settings.PORT}";
          recommendedProxySettings = true;
          proxyWebsockets = true;
        };

        locations."~ ^/collaboration/(ydoc|rollback|prune|changeset|activity|jwks)/" = {
          proxyPass = "http://localhost:${toString cfg.yhub.settings.PORT}";
          recommendedProxySettings = true;
          proxyWebsockets = true;
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
