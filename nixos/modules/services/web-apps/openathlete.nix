{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.openathlete;
  inherit (lib) mkOption mkIf types;

  environmentValue = value: if lib.isBool value then lib.boolToString value else toString value;

  # The PostgreSQL role, its database and the service's DynamicUser share this name:
  # peer authentication matches the role to the user, and ensureDBOwnership requires
  # the database to carry the role's name
  databaseName = "openathlete";

  # nginx drops inherited add_header directives in any location that sets its own
  securityHeaders = ''
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
  '';

  noCacheFile = {
    tryFiles = "$uri =404";
    extraConfig = ''
      ${securityHeaders}
      add_header Cache-Control no-cache;
    '';
  };

  apiAddress = "http://127.0.0.1:${toString cfg.settings.PORT}";

  localDependencies =
    lib.optional cfg.database.createLocally "postgresql.target"
    ++ lib.optional cfg.redis.createLocally "redis-openathlete.service";

  secretPath = types.pathWith {
    inStore = false;
    absolute = true;
  };

  redisUrlFromCredential = ''
    export REDIS_URL="redis://:$(< "$CREDENTIALS_DIRECTORY/redis")@127.0.0.1:${toString cfg.redis.port}"
  '';
in
{
  options.services.openathlete = {
    enable = lib.mkEnableOption "OpenAthlete, a self-hosted endurance training platform";

    package = lib.mkPackageOption pkgs "openathlete" { };

    hostName = mkOption {
      type = types.str;
      example = "coach.example.com";
      description = ''
        Host name under which the web app and the API are served by nginx.
        Only used when {option}`services.openathlete.configureNginx` is enabled.
      '';
    };

    configureNginx = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to serve the web app and proxy the API with nginx. The API
        is reachable under `/api` on the same origin as the app, which is the
        layout the web app is built for.
      '';
    };

    nginx = mkOption {
      type = types.submodule [
        (import ../web-servers/nginx/vhost-options.nix { inherit config lib; })
        {
          config = {
            root = lib.mkDefault cfg.package.web;
            extraConfig = securityHeaders;
            locations = {
              "/".tryFiles = "$uri $uri/ /index.html";
              "= /sw.js" = noCacheFile;
              "= /manifest.webmanifest" = noCacheFile;
              "~* \\.html$".extraConfig = ''
                ${securityHeaders}
                add_header Cache-Control "no-store, no-cache, must-revalidate";
              '';
              "~* \\.(js|css|png|jpg|jpeg|gif|ico|svg|woff2?|ttf|eot)$".extraConfig = ''
                ${securityHeaders}
                add_header Cache-Control "public, max-age=31536000, immutable";
              '';
              # `^~` keeps the static-asset regexes above from capturing proxied paths
              "^~ /api/" = {
                proxyPass = "${apiAddress}/";
                recommendedProxySettings = true;
                extraConfig = ''
                  proxy_http_version 1.1;
                  client_max_body_size 25m;
                  proxy_read_timeout 300s;
                '';
              };
              "^~ /socket.io" = {
                proxyPass = apiAddress;
                proxyWebsockets = true;
                recommendedProxySettings = true;
              };
              "^~ /.well-known/oauth-" = {
                proxyPass = apiAddress;
                recommendedProxySettings = true;
                extraConfig = "proxy_http_version 1.1;";
              };
            };
          };
        }
      ];
      default = { };
      example = lib.literalExpression ''
        {
          enableACME = true;
          forceSSL = true;
        }
      '';
      description = ''
        Extra configuration for the nginx virtual host of OpenAthlete.

        nginx drops the `add_header` directives of the virtual host in any location
        that sets its own, and the static-file locations do. A header added to
        `extraConfig`, such as `Strict-Transport-Security`, therefore does not reach
        the app shell, the scripts or the service worker unless it is repeated in
        `locations."~* \\.html$".extraConfig` and the other static locations.
      '';
    };

    settings = mkOption {
      type = types.submodule {
        freeformType =
          with types;
          attrsOf (oneOf [
            bool
            int
            str
          ]);

        options = {
          ENV = mkOption {
            type = types.enum [
              "development"
              "staging"
              "production"
            ];
            default = "production";
            description = "Deployment environment of the API.";
          };

          PORT = mkOption {
            type = types.port;
            default = 3000;
            description = ''
              Port the API listens on. The API binds every interface and has no
              setting to restrict it: this module does not open the port, so keep
              it closed in the firewall and let nginx be the entry point.
            '';
          };

          APP_URL = mkOption {
            type = types.str;
            example = "https://coach.example.com";
            description = ''
              Public URL of the instance, used for links in emails, OAuth callbacks
              and the MCP server. It must match the origin browsers use, as CORS and
              WebSocket origins derive from it unless `CORS_ORIGINS` is set.
            '';
          };

          DATABASE_URL = mkOption {
            type = types.str;
            default = "postgresql://${databaseName}@localhost:${toString config.services.postgresql.settings.port}/${databaseName}?host=/run/postgresql";
            defaultText = lib.literalExpression ''"postgresql://openathlete@localhost:''${toString config.services.postgresql.settings.port}/openathlete?host=/run/postgresql"'';
            description = ''
              PostgreSQL connection URL. The database needs the `pgvector`
              extension, which migrations create. A URL carrying a password is a
              secret: set it from {option}`services.openathlete.environmentFiles`,
              which overrides this option.
            '';
          };

          REDIS_URL = mkOption {
            type = types.str;
            default = "redis://127.0.0.1:${toString cfg.redis.port}";
            defaultText = lib.literalExpression ''"redis://127.0.0.1:''${toString config.services.openathlete.redis.port}"'';
            description = ''
              Redis connection URL. Redis holds the job queue and some durable
              state, so it must not evict keys. A URL carrying a password is a
              secret: set it from {option}`services.openathlete.environmentFiles`.
              {option}`services.openathlete.redis.passwordFile` overrides this
              option and the environment files.
            '';
          };

          SIGNUP_MODE = mkOption {
            type = types.enum [
              "open"
              "invite"
              "closed"
            ];
            default = "invite";
            description = ''
              Who can create an account. The first account of an instance is always
              allowed, whatever the mode.
            '';
          };

          TRUST_PROXY = mkOption {
            type = types.str;
            default = "loopback";
            description = ''
              Express `trust proxy` setting. The default fits a reverse proxy on the
              same host, including a chain of them; widen it if requests reach nginx
              from another machine, otherwise every client shares one rate limit.
              A hop count must be written as a string, for example `"2"`.
            '';
          };
        };
      };
      default = { };
      example = lib.literalExpression ''
        {
          APP_URL = "https://coach.example.com";
          SMTP_HOST = "127.0.0.1";
          SMTP_PORT = 25;
          EMAIL_FROM = "noreply@example.com";
        }
      '';
      description = ''
        Configuration of the API as environment variables, see
        <https://docs.openathlete.org/docs/getting-started/self-hosting>.
        Secrets belong in {option}`services.openathlete.environmentFiles`
        so that they do not reach the Nix store.

        Nothing is sent to the project: analytics and telemetry stay off unless
        `POSTHOG_PROJECT_TOKEN` is set. The one outbound call made without any
        configuration is the weather lookup for imported activities that carry a
        GPS track, which sends a coarse location and the date to open-meteo.com.
        There is no setting for it; block that host if it is not wanted.
      '';
    };

    environmentFiles = mkOption {
      type = types.listOf secretPath;
      default = [ ];
      example = [ "/run/secrets/openathlete.env" ];
      description = ''
        Environment files read by the API, holding the secrets: `JWT_SECRET_KEY`
        and `HASH_PEPPER` (both from `openssl rand -hex 32`), and optionally
        provider credentials such as `GARMIN_CLIENT_ID` and `GARMIN_CLIENT_SECRET`,
        `ANTHROPIC_API_KEY` or `SMTP_PASSWORD`. Changing `HASH_PEPPER` invalidates
        every password. The files must not be in the Nix store.
      '';
    };

    database.createLocally = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to create the database and its owner on the local PostgreSQL
        server, and install `pgvector` there.
      '';
    };

    redis = {
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to run a Redis server dedicated to OpenAthlete. Sharing one
          is discouraged: the job queue needs `noeviction`, and Redis has no
          isolation between applications.
        '';
      };

      port = mkOption {
        type = types.port;
        default = 6380;
        description = "Port of the dedicated Redis server, on the loopback interface.";
      };

      passwordFile = mkOption {
        type = types.nullOr secretPath;
        default = null;
        example = "/run/secrets/openathlete-redis-password";
        description = ''
          File holding the password of the dedicated Redis server. Without it,
          every local user can read and write the job queue. The password ends up
          in a URL, so it must not contain URL-reserved characters: use
          `openssl rand -hex 32`.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? JWT_SECRET_KEY || cfg.settings ? HASH_PEPPER);
        message = ''
          services.openathlete.settings is written to the world-readable unit file:
          put JWT_SECRET_KEY and HASH_PEPPER in services.openathlete.environmentFiles.
        '';
      }
      {
        assertion = cfg.redis.passwordFile != null -> cfg.redis.createLocally;
        message = "services.openathlete.redis.passwordFile only applies to the dedicated Redis server, enable services.openathlete.redis.createLocally.";
      }
    ];

    services.postgresql = mkIf cfg.database.createLocally {
      enable = true;
      extensions = ps: [ ps.pgvector ];
      ensureDatabases = [ databaseName ];
      ensureUsers = [
        {
          name = databaseName;
          ensureDBOwnership = true;
        }
      ];
    };

    # pgvector is not a trusted extension: the migration that creates it fails for the
    # database owner, so the superuser has to install it first
    systemd.services.postgresql-setup = mkIf cfg.database.createLocally {
      serviceConfig.ExecStartPost = [
        "${lib.getExe' config.services.postgresql.finalPackage "psql"} -p ${toString config.services.postgresql.settings.port} -d ${databaseName} -c 'CREATE EXTENSION IF NOT EXISTS vector' -c 'ALTER EXTENSION vector UPDATE'"
      ];
    };

    services.redis.servers.openathlete = mkIf cfg.redis.createLocally {
      enable = true;
      bind = "127.0.0.1";
      port = cfg.redis.port;
      appendOnly = true;
      requirePassFile = cfg.redis.passwordFile;
      settings.maxmemory-policy = "noeviction";
    };

    services.nginx = mkIf cfg.configureNginx {
      enable = true;
      virtualHosts.${cfg.hostName} = cfg.nginx;
    };

    systemd.services.openathlete = {
      description = "OpenAthlete";
      wantedBy = [ "multi-user.target" ];
      wants = [ "network-online.target" ];
      after = [ "network-online.target" ] ++ localDependencies;
      requires = localDependencies;

      environment = lib.mapAttrs (_: environmentValue) cfg.settings;

      script = ''
        ${lib.optionalString (cfg.redis.passwordFile != null) redisUrlFromCredential}
        exec ${lib.getExe cfg.package}
      '';

      serviceConfig = {
        ExecStartPre = lib.getExe' cfg.package "openathlete-migrate";
        EnvironmentFile = cfg.environmentFiles;
        LoadCredential = lib.optional (cfg.redis.passwordFile != null) "redis:${cfg.redis.passwordFile}";
        DynamicUser = true;
        PrivateTmp = true;
        Restart = "on-failure";
        RestartSec = 5;
        UMask = "0077";

        MemoryDenyWriteExecute = false;
        CapabilityBoundingSet = "";
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProcSubset = "pid";
        ProtectSystem = "strict";
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
          "AF_UNIX"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "@pkey"
        ];
      };
    };
  };

  meta = {
    maintainers = with lib.maintainers; [ paulfariello ];
  };
}
