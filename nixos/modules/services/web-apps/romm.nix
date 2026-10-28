{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.romm;

  authSecretFile = "${cfg.dataDir}/.auth-secret.env";

  isIPv6 = addr: lib.hasInfix ":" addr;
  bracketed = addr: if isIPv6 addr then "[${addr}]" else addr;

  # Wildcard binds are proxied via loopback; specific addresses as-is.
  proxyHost =
    if
      lib.elem cfg.listenAddress [
        "0.0.0.0"
        "::"
      ]
    then
      "127.0.0.1"
    else
      cfg.listenAddress;
  proxyTarget = "http://${bracketed proxyHost}:${toString cfg.port}";

  redisHost = if cfg.redis.createLocally then "127.0.0.1" else cfg.redis.host;

  commonEnv = {
    ROMM_BASE_PATH = cfg.dataDir;
    ROMM_HOST = bracketed cfg.listenAddress;
    ROMM_PORT = toString cfg.port;
    # gunicorn trusts X-Forwarded-* only from nginx's side of the socket.
    FORWARDED_ALLOW_IPS = proxyHost;
    ROMM_DB_DRIVER = "postgresql";
    DB_NAME = cfg.database.name;
    DB_USER = cfg.database.user;
    DB_PORT = toString cfg.database.port;
    REDIS_HOST = redisHost;
    REDIS_PORT = toString cfg.redis.port;
    # The rq and rqscheduler CLIs do not read RomM's REDIS_* variables.
    RQ_REDIS_HOST = redisHost;
    RQ_REDIS_PORT = toString cfg.redis.port;
    RQ_REDIS_URL = "redis://${redisHost}:${toString cfg.redis.port}/0";
  }
  // lib.optionalAttrs cfg.watcher.enable {
    # Upstream defaults this to false, which turns the watcher into a no-op.
    ENABLE_RESCAN_ON_FILESYSTEM_CHANGE = "true";
  }
  // lib.optionalAttrs cfg.database.createLocally {
    # RomM refuses to start without a database password, but with peer
    # authentication over the unix socket it is never actually used.
    DB_PASSWD = "peer-auth-unused";
    DB_QUERY_JSON = builtins.toJSON { host = "/run/postgresql"; };
  }
  // lib.optionalAttrs (!cfg.database.createLocally) {
    DB_HOST = cfg.database.host;
  }
  // lib.optionalAttrs cfg.nginx.enable (
    let
      vhost = config.services.nginx.virtualHosts.${cfg.nginx.virtualHost};
      ssl = vhost.forceSSL || vhost.onlySSL;
    in
    {
      # Used to build user-facing absolute URLs (invite and password reset
      # links); upstream's default is a broken http://0.0.0.0.
      ROMM_BASE_URL = "http${lib.optionalString ssl "s"}://${cfg.nginx.virtualHost}";
    }
    // lib.optionalAttrs ssl {
      # Upstream leaves this off because the container cannot know how it is
      # served; here the virtual host tells us TLS is terminated in front.
      ROMM_SESSION_SECURE_COOKIE = "true";
    }
  )
  // cfg.extraEnvironment;

  environmentFiles = [
    "-${authSecretFile}"
  ]
  ++ lib.optional (cfg.environmentFile != null) cfg.environmentFile;

  commonServiceConfig = {
    User = cfg.user;
    Group = cfg.group;
    WorkingDirectory = cfg.dataDir;
    EnvironmentFile = environmentFiles;
    Restart = "on-failure";
    # Hardening
    NoNewPrivileges = true;
    PrivateTmp = true;
    ProtectHome = true;
    ProtectSystem = "strict";
    ReadWritePaths = [ cfg.dataDir ];
    Environment = [
      "PATH=${lib.makeBinPath [ pkgs.rahasher ]}:/run/current-system/sw/bin"
    ];
  };
in
{
  options.services.romm = {
    enable = lib.mkEnableOption "RomM, a self-hosted ROM manager";

    package = lib.mkPackageOption pkgs "romm" { };

    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      example = "0.0.0.0";
      description = ''
        Address the RomM API binds to. The frontend and downloads are served
        by the nginx virtual host, not by the API directly.
      '';
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port the RomM API listens on.";
    };

    user = lib.mkOption {
      type = lib.types.str;
      default = "romm";
      description = "User account under which RomM runs.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "romm";
      description = "Group under which RomM runs.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/romm";
      description = ''
        Base path for the ROM library and runtime data
        (`''${dataDir}/{library,resources,assets,config,cache}`).

        The ROM library location is fixed to `''${dataDir}/library` by
        upstream. To use an existing ROM collection stored elsewhere,
        bind-mount it there and make sure it is readable and writable by
        {option}`services.romm.user`.
      '';
    };

    database = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to create the PostgreSQL database and user locally (peer
          authentication over the unix socket).
        '';
      };
      name = lib.mkOption {
        type = lib.types.str;
        default = "romm";
        description = "Database name.";
      };
      user = lib.mkOption {
        type = lib.types.str;
        default = "romm";
        description = ''
          Database user. With {option}`services.romm.database.createLocally`
          this must equal {option}`services.romm.user`.
        '';
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          PostgreSQL host. Ignored when
          {option}`services.romm.database.createLocally` is set; the password
          for a remote database is passed as `DB_PASSWD` via
          {option}`services.romm.environmentFile`.
        '';
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 5432;
        description = "PostgreSQL port.";
      };
    };

    redis = {
      createLocally = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to create a dedicated local Redis instance
          (`services.redis.servers.romm`).
        '';
      };
      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = ''
          Redis host. Ignored when
          {option}`services.romm.redis.createLocally` is set; credentials for
          a remote Redis are passed via
          {option}`services.romm.environmentFile` (`REDIS_PASSWORD`, and
          `RQ_REDIS_URL` for the job queue).
        '';
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 6379;
        description = ''
          Redis port. RomM does not support unix sockets for Redis.
        '';
      };
    };

    watcher.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to run the filesystem watcher that rescans the library on changes.";
    };

    nginx = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to serve RomM through a local nginx virtual host, as
          upstream's container image does. The backend only exposes the API;
          nginx serves the frontend, ROM downloads (`X-Accel-Redirect`,
          `mod_zip`) and the cross-origin isolation headers for the emulator.
          Point external reverse proxies at this virtual host.
        '';
      };
      virtualHost = lib.mkOption {
        type = lib.types.str;
        example = "romm.example.org";
        description = "Server name of the RomM virtual host.";
      };
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Environment file with secrets such as metadata provider credentials
        (`IGDB_CLIENT_ID`, `IGDB_CLIENT_SECRET`, `SCREENSCRAPER_USER`, ...).
        `ROMM_AUTH_SECRET_KEY` may also be set here; when absent, one is
        generated and persisted under {option}`services.romm.dataDir`.
      '';
    };

    extraEnvironment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      example = {
        WEB_CONCURRENCY = "4";
      };
      description = ''
        Extra environment variables passed to all RomM services. See
        <https://docs.romm.app/latest/Getting-Started/Environment-Variables/>.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.createLocally -> cfg.database.user == cfg.user;
        message = "services.romm.database.user must equal services.romm.user when database.createLocally is enabled.";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.name == cfg.database.user;
        message = "services.romm.database.name must equal services.romm.database.user when database.createLocally is enabled.";
      }
    ];

    users.users.${cfg.user} = lib.mkIf (cfg.user == "romm") {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
    };
    users.groups.${cfg.group} = lib.mkIf (cfg.group == "romm") { };

    systemd.tmpfiles.settings."10-romm" =
      lib.genAttrs
        (
          [ cfg.dataDir ]
          ++ map (dir: "${cfg.dataDir}/${dir}") [
            "assets"
            "cache"
            "config"
            "library"
            "resources"
          ]
        )
        (_: {
          d = {
            mode = "0750";
            user = cfg.user;
            group = cfg.group;
          };
        });

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.romm = lib.mkIf cfg.redis.createLocally {
      enable = true;
      port = cfg.redis.port;
      bind = "127.0.0.1";
    };

    systemd.services.romm = {
      description = "RomM ROM manager";
      wantedBy = [ "multi-user.target" ];
      after = [
        "network.target"
      ]
      ++ lib.optional cfg.redis.createLocally "redis-romm.service"
      ++ lib.optional cfg.database.createLocally "postgresql.target";
      requires =
        lib.optional cfg.redis.createLocally "redis-romm.service"
        ++ lib.optional cfg.database.createLocally "postgresql.target";
      environment = commonEnv;

      # EnvironmentFile is already in effect during preStart, so this only
      # generates a secret when none was configured.
      preStart = ''
        if [ -z "''${ROMM_AUTH_SECRET_KEY:-}" ]; then
          umask 0077
          echo "ROMM_AUTH_SECRET_KEY=$(${lib.getExe pkgs.openssl} rand -hex 32)" > ${lib.escapeShellArg authSecretFile}
        fi
      '';

      serviceConfig = commonServiceConfig // {
        ExecStartPre = [
          "${cfg.package}/bin/romm-migrate"
          "${cfg.package}/bin/romm-startup"
        ];
        ExecStart = "${cfg.package}/bin/romm";
      };
    };

    systemd.services.romm-worker = {
      description = "RomM RQ worker";
      wantedBy = [ "multi-user.target" ];
      after = [ "romm.service" ];
      requires = [ "romm.service" ];
      environment = commonEnv;
      serviceConfig = commonServiceConfig // {
        ExecStart = "${cfg.package}/bin/romm-worker";
      };
    };

    systemd.services.romm-scheduler = {
      description = "RomM RQ scheduler";
      wantedBy = [ "multi-user.target" ];
      after = [ "romm.service" ];
      requires = [ "romm.service" ];
      environment = commonEnv;
      serviceConfig = commonServiceConfig // {
        ExecStart = "${cfg.package}/bin/romm-scheduler";
      };
    };

    systemd.services.romm-watcher = lib.mkIf cfg.watcher.enable {
      description = "RomM library watcher";
      wantedBy = [ "multi-user.target" ];
      after = [ "romm.service" ];
      requires = [ "romm.service" ];
      environment = commonEnv;
      serviceConfig = commonServiceConfig // {
        ExecStart = "${cfg.package}/bin/romm-watcher ${cfg.dataDir}/library";
      };
    };

    services.nginx = lib.mkIf cfg.nginx.enable {
      enable = true;
      # mod_zip assembles the streamed multi-file ZIP downloads; njs provides
      # the internal base64 /decode endpoint used in mod_zip manifests.
      additionalModules = with pkgs.nginxModules; [
        njs
        zip
      ];
      appendHttpConfig = ''
        js_import romm_decode from ${cfg.package}/share/romm/decode.js;

        # Cross-origin isolation is required on the emulator player paths for
        # SharedArrayBuffer, which multi-threaded EmulatorJS cores rely on.
        map $request_uri $romm_coep_header {
          default "";
          "~^/rom/.*/ejs$" "require-corp";
          "~^/console/rom/[0-9]+/play" "require-corp";
        }
        map $request_uri $romm_coop_header {
          default "";
          "~^/rom/.*/ejs$" "same-origin";
          "~^/console/rom/[0-9]+/play" "same-origin";
        }
      '';
      virtualHosts.${cfg.nginx.virtualHost} = {
        root = "${cfg.package.frontend}";
        extraConfig = ''
          client_max_body_size 0;
        '';
        locations = {
          "/" = {
            tryFiles = "$uri $uri/ /index.html";
            extraConfig = ''
              # never cache index.html: store paths have epoch mtimes, and
              # heuristic caching would keep serving it across upgrades
              add_header Cache-Control "no-cache";
              add_header Cross-Origin-Embedder-Policy $romm_coep_header;
              add_header Cross-Origin-Opener-Policy $romm_coop_header;
            '';
          };
          "/assets/romm/resources/" = {
            alias = "${cfg.dataDir}/resources/";
          };
          "/openapi.json" = {
            proxyPass = proxyTarget;
            # Per-location instead of the global recommendedProxySettings so
            # other virtual hosts on the same machine are left untouched.
            recommendedProxySettings = true;
          };
          "/api" = {
            proxyPass = proxyTarget;
            recommendedProxySettings = true;
            extraConfig = ''
              # Chunked request bodies can only be relayed unbuffered over
              # HTTP/1.1 (the global recommendedProxySettings used to set this).
              proxy_http_version 1.1;
              proxy_request_buffering off;
              proxy_buffering off;
              proxy_read_timeout 300s;
            '';
          };
          "~ ^/(ws|netplay)" = {
            proxyPass = proxyTarget;
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
          # X-Accel-Redirect targets used by the backend for ROM downloads.
          "/library/" = {
            alias = "${cfg.dataDir}/library/";
            extraConfig = "internal;";
          };
          "/cache/" = {
            alias = "${cfg.dataDir}/cache/";
            extraConfig = "internal;";
          };
          "/decode" = {
            extraConfig = ''
              internal;
              js_content romm_decode.decodeBase64;
            '';
          };
        };
      };
    };

    users.users.${config.services.nginx.user} = lib.mkIf cfg.nginx.enable {
      extraGroups = [ cfg.group ];
    };
  };

  meta.maintainers = with lib.maintainers; [
    denzonl
    jk
  ];
}
