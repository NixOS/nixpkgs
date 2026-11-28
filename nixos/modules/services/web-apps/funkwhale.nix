{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.funkwhale;
  user = "funkwhale";
  group = "funkwhale";

  pythonEnv = cfg.package.python.withPackages (
    pyPkgs:
    cfg.package.dependencies
    ++ [
      (pyPkgs.toPythonModule cfg.package)
      pyPkgs.gunicorn
    ]
  );

  hostName = lib.head (lib.splitString ":" (cfg.settings.FUNKWHALE_HOSTNAME or ""));
  vHost = config.services.nginx.virtualHosts.${hostName} or null;
  sslEnabled =
    cfg.configureNginx
    && vHost != null
    && (
      vHost.forceSSL or false
      || vHost.onlySSL or false
      || vHost.addSSL or false
      || vHost.enableACME or false
    );
in
{
  options.services.funkwhale = {
    enable = lib.mkEnableOption "Funkwhale, a federated audio platform";
    package = lib.mkPackageOption pkgs "funkwhale" { };

    createDatabaseLocally = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Create a local PostgreSQL database for Funkwhale.";
    };

    createRedisLocally = lib.mkOption {
      type = lib.types.bool;
      default = true;
      example = false;
      description = "Create a local Redis server for Funkwhale.";
    };

    configureNginx = lib.mkOption {
      type = lib.types.bool;
      default = false;
      example = true;
      description = ''
        Configure nginx as a reverse proxy for Funkwhale.

        You will still need to configure SSL/HTTPS.
      '';
    };

    settings = lib.mkOption {
      type = lib.types.submodule {
        freeformType =
          with lib.types;
          attrsOf (oneOf [
            int
            str
            bool
            path
            (listOf (oneOf [
              int
              str
              bool
              path
            ]))
          ]);

        options = {
          FUNKWHALE_API_IP = lib.mkOption {
            type = lib.types.str;
            default = "127.0.0.1";
            example = "0.0.0.0";
            description = "Host or address to bind the API socket to.";
          };
          FUNKWHALE_API_PORT = lib.mkOption {
            type = lib.types.port;
            default = 5000;
            example = 5678;
            description = "Port to bind the API socket to.";
          };

          DATABASE_NAME = lib.mkOption {
            type = lib.types.str;
            default = "funkwhale";
            example = "funkiestwhale";
            description = "Name of the PostgreSQL database.";
          };

          FUNKWHALE_HOSTNAME = lib.mkOption {
            type = lib.types.str;
            example = "mypod.audio";
            description = "Hostname of your Funkwhale pod.";
          };
          FUNKWHALE_PROTOCOL = lib.mkOption {
            type = lib.types.enum [
              "http"
              "https"
            ];
            default = "http";
            example = "https";
            description = "Protocol end users will use to access your pod.";
          };
          DJANGO_ALLOWED_HOSTS = lib.mkOption {
            type = with lib.types; listOf str;
            default = [ ];
            example = [
              "localhost:5000"
              "127.0.0.1:5000"
            ];
            description = ''
              List of additional hostnames or origins (including port) that are allowed to access the instance.
              This is used to populate Django's `ALLOWED_HOSTS` and `CSRF_TRUSTED_ORIGINS`.
            '';
          };
        };
      };
      # The environment variables are parsed using <https://pypi.org/project/django-environ/>.
      apply =
        let
          toStr =
            value:
            if lib.isPath value then
              "${value}"
            else if lib.isBool value then
              lib.boolToString value
            else
              toString value;
        in
        attrs:
        lib.mapAttrs (
          _: value: if lib.isList value then lib.concatMapStringsSep "," toStr value else toStr value
        ) attrs;
      default = { };
      example = {
        FUNKWHALE_HOSTNAME = "localhost";
      };
      description = ''
        See <https://docs.funkwhale.audio/administrator/configuration/env-file.html>.

        Secret settings such as `DJANGO_SECRET_KEY` should go in `services.funkwhale.secretEnvironmentFile`.

        You will need to manually create your first user account.
        Example: `sudo -u funkwhale funkwhale-manage fw users create --superuser`.
        See <https://docs.funkwhale.audio/administrator/manage-script/users.html> for
        more information.
      '';
    };

    secretEnvironmentFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      example = "/run/secrets/funkwhale.env";
      description = ''
        Secret environment variable settings. These overwrite `services.funkwhale.settings`.
        See <https://docs.funkwhale.audio/administrator/configuration/env-file.html>.

        Example:

        ```
        DJANGO_SECRET_KEY="some-very-increadibly-secret-key"
        TYPESENSE_API_KEY="some-other-very-increadibly-super-secret-key"
        ```

        `DJANGO_SECRET_KEY` will be auto-generated if not set here.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = !(cfg.settings ? DJANGO_SECRET_KEY);
        message = ''
          Setting `services.funkwhale.settings.DJANGO_SECRET_KEY` is not secure.
          Instead, `DJANGO_SECRET_KEY` should be set in `services.funkwhale.secretEnvironmentFile`.
        '';
      }
    ];

    services.funkwhale.settings = lib.mkMerge [
      {
        MEDIA_ROOT = "/var/lib/funkwhale/data/media";
        MUSIC_DIRECTORY_PATH = "/var/lib/funkwhale/data/music";
        FUNKWHALE_SPA_HTML_ROOT = "${cfg.package.frontend}/index.html";
      }
      (lib.mkIf cfg.createDatabaseLocally {
        DATABASE_HOST = "";
        DATABASE_PORT = 5432;
        DATABASE_USER = user;
        # Peer authentication.
        DATABASE_PASSWORD = "";
      })
      (lib.mkIf cfg.createRedisLocally {
        CACHE_URL = "unix://${config.services.redis.servers.funkwhale.unixSocket}?db=0";
        CELERY_BROKER_URL = "redis+socket://${config.services.redis.servers.funkwhale.unixSocket}?virtual_host=0";
      })
      (lib.mkIf cfg.configureNginx {
        REVERSE_PROXY_TYPE = "nginx";
        NGINX_MAX_BODY_SIZE = lib.mkDefault "100M";
        FUNKWHALE_PROTOCOL = lib.mkDefault (if sslEnabled then "https" else "http");
      })
    ];

    users = {
      users.${user} = {
        isSystemUser = true;
        home = "/var/lib/funkwhale";
        inherit group;
      };
      groups.${group} = { };
    };

    environment.systemPackages = [
      (pkgs.writeShellScriptBin "funkwhale-manage" ''
        if [[ "$USER" != "${user}" ]]; then
          exec /run/wrappers/bin/sudo -u ${user} "$0" "$@"
        fi

        cd /var/lib/funkwhale

        # Set `cfg.settings` environment variables.
        ${lib.concatMapAttrsStringSep "\n" (
          name: value: "export ${name}=${lib.escapeShellArg value}"
        ) cfg.settings}

        # Set secret environment variables.
        set -o allexport
        if [ -f "/var/lib/funkwhale/config/django_secret_key.env" ]; then
          source "/var/lib/funkwhale/config/django_secret_key.env"
        fi
        ${lib.optionalString (cfg.secretEnvironmentFile != null) ''
          source ${cfg.secretEnvironmentFile}
        ''}
        set +o allexport

        exec ${lib.getExe cfg.package} "$@"
      '')
    ];

    systemd.tmpfiles.settings.funkwhale = {
      # Where auto-generated secrets will be.
      "/var/lib/funkwhale/config".d = {
        inherit user group;
        mode = "0700";
      };

      # Miscellaneous API state files.
      "/var/lib/funkwhale/api".d = {
        inherit user group;
        mode = "0700";
      };

      # Files served by the API.
      "/var/lib/funkwhale/data".d = {
        inherit user group;
        mode = "0755";
      };
      # Default `MEDIA_ROOT`.
      "/var/lib/funkwhale/data/media".d = {
        inherit user group;
        mode = "0755";
      };
      # Default `MUSIC_DIRECTORY_PATH`.
      "/var/lib/funkwhale/data/music".d = {
        inherit user group;
        mode = "0755";
      };
    };

    systemd.targets = {
      funkwhale = {
        description = "Funkwhale";
        wants = [
          "funkwhale-server.service"
          "funkwhale-worker.service"
          "funkwhale-beat.service"
        ];
        wantedBy = [ "multi-user.target" ];
      };
    };

    systemd.services =
      lib.mapAttrs
        (
          _: unitAttrs:
          lib.recursiveUpdate {
            after =
              lib.optional config.services.typesense.enable "typesense.service"
              ++ lib.optionals cfg.createDatabaseLocally [ "postgresql.service" ]
              ++ lib.optionals cfg.createRedisLocally [ "redis-funkwhale.service" ];

            partOf = [ "funkwhale.target" ];

            environment = cfg.settings;

            serviceConfig = {
              User = user;
              Group = group;

              StateDirectory = "funkwhale";
              RuntimeDirectory = "funkwhale";

              EnvironmentFile = [
                "-/var/lib/funkwhale/config/django_secret_key.env"
              ]
              ++ (lib.optional (cfg.secretEnvironmentFile != null) cfg.secretEnvironmentFile);
            };
          } unitAttrs
        )
        {
          funkwhale-setup = {
            description = "Funkwhale setup";

            before = [
              "funkwhale-server.service"
              "funkwhale-worker.service"
              "funkwhale-beat.service"
            ];
            requiredBy = [ "funkwhale.target" ];

            script = ''
              if [[ ! -v DJANGO_SECRET_KEY ]]; then
                echo "No \`DJANGO_SECRET_KEY\` found, auto-generating one."
                key=$(tr -dc A-Za-z0-9 < /dev/urandom | head -c64)
                printf 'DJANGO_SECRET_KEY=%s\n' "$key" > $STATE_DIRECTORY/config/django_secret_key.env
                export DJANGO_SECRET_KEY="$key"
              fi

              ${lib.getExe cfg.package} migrate
            '';
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
            };
          };

          funkwhale-server = {
            description = "Funkwhale application server";

            serviceConfig = {
              Type = "notify";
              KillMode = "mixed";
              ExecStart = ''
                ${lib.getExe' pythonEnv "gunicorn"} \
                  config.asgi:application \
                  --workers=${cfg.settings.FUNKWHALE_WEB_WORKERS or "4"} \
                  --worker-class=uvicorn.workers.UvicornWorker \
                  --bind=${cfg.settings.FUNKWHALE_API_IP}:${cfg.settings.FUNKWHALE_API_PORT}
              '';
              ExecReload = "${lib.getExe' pkgs.util-linux "kill"} -s HUP $MAINPID";
            };
          };

          funkwhale-beat = {
            description = "Funkwhale celery beat process";

            serviceConfig = {
              ExecStart = ''
                ${lib.getExe' pythonEnv "celery"} \
                  --app funkwhale_api.taskapp \
                  beat \
                  --loglevel INFO \
                  --schedule "''${STATE_DIRECTORY}/api/celerybeat-schedule"
              '';
            };
          };

          funkwhale-worker = {
            description = "Funkwhale celery worker";

            serviceConfig = {
              ExecStart = ''
                ${lib.getExe' pythonEnv "celery"} \
                  --app funkwhale_api.taskapp \
                  worker \
                  --loglevel INFO \
                  --concurrency=${cfg.settings.CELERYD_CONCURRENCY or "0"}
              '';
            };
          };
        };

    services.postgresql = lib.mkIf cfg.createDatabaseLocally {
      enable = lib.mkDefault true;
      ensureDatabases = [ cfg.settings.DATABASE_NAME ];
      ensureUsers = [
        {
          name = user;
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers.funkwhale = lib.mkIf cfg.createRedisLocally {
      enable = true;
      inherit user group;
    };

    # Based on <https://dev.funkwhale.audio/funkwhale/funkwhale/-/blob/develop/deploy/nginx.template>.
    services.nginx = lib.mkIf cfg.configureNginx {
      enable = lib.mkDefault true;

      # `gixy` doesn't like the nested `add-header` use.
      # See <https://github.com/NixOS/nixpkgs/issues/128506>.
      validateConfigFile = false;

      recommendedGzipSettings = lib.mkDefault true;

      upstreams.funkwhale-api.servers = {
        "${cfg.settings.FUNKWHALE_API_IP}:${cfg.settings.FUNKWHALE_API_PORT}" = { };
      };

      virtualHosts.${hostName} =
        let
          proxyApi = {
            recommendedProxySettings = true;
            proxyWebsockets = true;
            proxyPass = "http://funkwhale-api";
          };
        in
        {
          root = cfg.package.frontend;
          extraConfig = ''
            add_header Content-Security-Policy "default-src 'self'; connect-src https: wss: http: ws: 'self' 'unsafe-eval'; script-src 'self' 'wasm-unsafe-eval'; style-src https: http: 'self' 'unsafe-inline'; img-src https: http: 'self' data:; font-src https: http: 'self' data:; media-src https: http: 'self' data:; object-src 'none'";
            add_header Referrer-Policy "strict-origin-when-cross-origin";
            add_header X-Frame-Options "SAMEORIGIN" always;
            add_header Service-Worker-Allowed "/";
          '';

          locations = {
            "/api/" = proxyApi // {
              extraConfig = ''
                client_max_body_size ${cfg.settings.NGINX_MAX_BODY_SIZE};
              '';
            };

            "~ ^/library/(albums|tracks|artists|playlists)/" = proxyApi;

            "/channels/" = proxyApi;

            "~ ^/@(vite-plugin-pwa|vite|id)/" = {
              recommendedProxySettings = true;
              proxyWebsockets = true;
              alias = "${cfg.package.frontend}/";
              tryFiles = "$uri $uri/ /index.html";
            };

            "/@" = proxyApi;

            "/" = {
              recommendedProxySettings = true;
              proxyWebsockets = true;
              alias = "${cfg.package.frontend}/";
              tryFiles = "$uri $uri/ /index.html";
              extraConfig = ''
                expires 1d;
              '';
            };

            "~ \"/(front/)?embed.html\"" = {
              alias = "${cfg.package.frontend}/embed.html";
              extraConfig = ''
                add_header Content-Security-Policy "connect-src https: http: 'self'; default-src 'self'; script-src 'self' unpkg.com 'unsafe-inline' 'unsafe-eval'; style-src https: http: 'self' 'unsafe-inline'; img-src https: http: 'self' data:; font-src https: http: 'self' data:; object-src 'none'; media-src https: http: 'self' data:";
                add_header Referrer-Policy "strict-origin-when-cross-origin";

                expires 1d;
              '';
            };

            "/federation/" = proxyApi;

            "/rest/" = proxyApi // {
              proxyPass = "http://funkwhale-api/api/subsonic/rest/";
            };

            "/.well-known/" = proxyApi;

            # Allow direct access to only specific subdirectories in `/media`.
            "/media/__sized__/" = {
              alias = "${cfg.settings.MEDIA_ROOT}/__sized__/";
              extraConfig = ''
                add_header Access-Control-Allow-Origin '*';
              '';
            };
            "/media/attachments/" = {
              alias = "${cfg.settings.MEDIA_ROOT}/attachments/";
              extraConfig = ''
                add_header Access-Control-Allow-Origin '*';
              '';
            };
            "/media/dynamic_preferences/" = {
              alias = "${cfg.settings.MEDIA_ROOT}/dynamic_preferences/";
              extraConfig = ''
                add_header Access-Control-Allow-Origin '*';
              '';
            };

            # This is an internal location that is used to serve media (uploaded) files
            # once correct permission / authentication has been checked on API side.
            "~ /_protected/media/(.+)" = {
              alias = "${cfg.settings.MEDIA_ROOT}/$1";
              extraConfig = ''
                internal;
                add_header Access-Control-Allow-Origin '*';
              '';
            };

            # This is an internal location that is used to serve media (uploaded) files
            # once correct permission / authentication has been checked on API side.
            "/_protected/music/" = {
              alias = "${cfg.settings.MUSIC_DIRECTORY_PATH}/";
              extraConfig = ''
                internal;
                add_header Access-Control-Allow-Origin '*';
              '';
            };

            "/manifest.json" = {
              # If the reverse proxy is terminating SSL, nginx gets confused and redirects
              # to http, hence the full URL.
              return = "302 ${cfg.settings.FUNKWHALE_PROTOCOL}://${cfg.settings.FUNKWHALE_HOSTNAME}/api/v2/instance/spa-manifest.json";
            };

            "/staticfiles/" = {
              alias = "${cfg.package.static}/";
            };
          };
        };
    };
  };

  meta.maintainers = lib.teams.ngi.members;
}
