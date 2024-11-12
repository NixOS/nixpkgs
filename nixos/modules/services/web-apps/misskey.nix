{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.misskey;
  settingsFormat = pkgs.formats.yaml { };
  redisType = lib.types.submodule {
    freeformType = lib.types.attrsOf settingsFormat.type;
    options = {
      host = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "The Redis host.";
      };
      port = lib.mkOption {
        type = lib.types.port;
        default = 6379;
        description = "The Redis port.";
      };
    };
  };
  settings = lib.mkOption {
    description = ''
      Configuration for Misskey, see
      [`example.yml`](https://github.com/misskey-dev/misskey/blob/develop/.config/example.yml)
      for all supported options.
    '';
    type = lib.types.submodule {
      freeformType = lib.types.attrsOf settingsFormat.type;
      options = {
        url = lib.mkOption {
          type = lib.types.str;
          example = "https://example.tld/";
          description = ''
            The final user-facing URL. Do not change after running Misskey for the first time.

            This needs to match up with the configured reverse proxy and is automatically configured when using `services.misskey.reverseProxy`.
          '';
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 3000;
          description = "The port your Misskey server should listen on.";
        };
        socket = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/path/to/misskey.sock";
          description = "The UNIX socket your Misskey server should listen on.";
        };
        chmodSocket = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          example = "777";
          description = "The file access mode of the UNIX socket.";
        };
        db = lib.mkOption {
          description = "Database settings.";
          type = lib.types.submodule {
            options = {
              host = lib.mkOption {
                type = lib.types.str;
                default = "/var/run/postgresql";
                example = "localhost";
                description = "The PostgreSQL host.";
              };
              port = lib.mkOption {
                type = lib.types.port;
                default = 5432;
                description = "The PostgreSQL port.";
              };
              db = lib.mkOption {
                type = lib.types.str;
                default = "misskey";
                description = "The database name.";
              };
              user = lib.mkOption {
                type = lib.types.str;
                default = "misskey";
                description = "The user used for database authentication.";
              };
              pass = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "The password used for database authentication.";
              };
              disableCache = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether to disable caching queries.";
              };
              extra = lib.mkOption {
                type = lib.types.nullOr (lib.types.attrsOf settingsFormat.type);
                default = null;
                example = {
                  ssl = true;
                };
                description = "Extra connection options.";
              };
            };
          };
          default = { };
        };
        redis = lib.mkOption {
          type = redisType;
          default = { };
          description = "`ioredis` options. See [`README`](https://github.com/redis/ioredis?tab=readme-ov-file#connect-to-redis) for reference.";
        };
        redisForPubsub = lib.mkOption {
          type = lib.types.nullOr redisType;
          default = null;
          description = "`ioredis` options for pubsub. See [`README`](https://github.com/redis/ioredis?tab=readme-ov-file#connect-to-redis) for reference.";
        };
        redisForJobQueue = lib.mkOption {
          type = lib.types.nullOr redisType;
          default = null;
          description = "`ioredis` options for the job queue. See [`README`](https://github.com/redis/ioredis?tab=readme-ov-file#connect-to-redis) for reference.";
        };
        redisForTimelines = lib.mkOption {
          type = lib.types.nullOr redisType;
          default = null;
          description = "`ioredis` options for timelines. See [`README`](https://github.com/redis/ioredis?tab=readme-ov-file#connect-to-redis) for reference.";
        };
        meilisearch = lib.mkOption {
          description = "Meilisearch connection options.";
          type = lib.types.nullOr (
            lib.types.submodule {
              options = {
                host = lib.mkOption {
                  type = lib.types.str;
                  default = "localhost";
                  description = "The Meilisearch host.";
                };
                port = lib.mkOption {
                  type = lib.types.port;
                  default = 7700;
                  description = "The Meilisearch port.";
                };
                apiKey = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "The Meilisearch API key.";
                };
                ssl = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = "Whether to connect via SSL.";
                };
                index = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Meilisearch index to use.";
                };
                scope = lib.mkOption {
                  type = lib.types.enum [
                    "local"
                    "global"
                  ];
                  default = "local";
                  description = "The search scope.";
                };
              };
            }
          );
          default = null;
        };
        id = lib.mkOption {
          type = lib.types.enum [
            "aid"
            "aidx"
            "meid"
            "ulid"
            "objectid"
          ];
          default = "aidx";
          description = "The ID generation method to use. Do not change after starting Misskey for the first time.";
        };
      };
    };
  };
in

{
  options = {
    services.misskey = {
      enable = lib.mkEnableOption "misskey";
      package = lib.mkPackageOption pkgs "misskey" { };
      inherit settings;
      database = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Create the PostgreSQL database locally. Sets `services.misskey.settings.db.{db,host,port,user,pass}`.";
        };
        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "The path to a file containing the database password. Sets `services.misskey.settings.db.pass`.";
        };
      };
      redis = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Create and use a local Redis instance. Sets `services.misskey.settings.redis.host`.";
        };
        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "The path to a file containing the Redis password. Sets `services.misskey.settings.redis.pass`.";
        };
      };
      meilisearch = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Create and use a local Meilisearch instance. Sets `services.misskey.settings.meilisearch.{host,port,ssl}`.";
        };
        keyFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "The path to a file containing the Meilisearch API key. Sets `services.misskey.settings.meilisearch.apiKey`.";
        };
      };
      reverseProxy = {
        enable = lib.mkEnableOption "a HTTP reverse proxy for Misskey";
        webserver = lib.mkOption {
          type = lib.types.attrTag {
            nginx = lib.mkOption {
              type = lib.types.submodule (import ../web-servers/nginx/vhost-options.nix);
              default = { };
              description = ''
                Extra configuration for the nginx virtual host of Misskey.
                Set to `{ }` to use the default configuration.
              '';
            };
            caddy = lib.mkOption {
              type = lib.types.submodule (
                import ../web-servers/caddy/vhost-options.nix { cfg = config.services.caddy; }
              );
              default = { };
              description = ''
                Extra configuration for the caddy virtual host of Misskey.
                Set to `{ }` to use the default configuration.
              '';
            };
          };
          description = "The webserver to use as the reverse proxy.";
        };
        host = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          description = ''
            The fully qualified domain name to bind to. Sets `services.misskey.settings.url`.

            This is required when using `services.misskey.reverseProxy.enable = true`.
          '';
          example = "misskey.example.com";
          default = null;
        };
        ssl = lib.mkOption {
          type = lib.types.nullOr lib.types.bool;
          description = ''
            Whether to enable SSL for the reverse proxy. Sets `services.misskey.settings.url`.

            This is required when using `services.misskey.reverseProxy.enable = true`.
          '';
          example = true;
          default = null;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          cfg.reverseProxy.enable -> ((cfg.reverseProxy.host != null) && (cfg.reverseProxy.ssl != null));
        message = "`services.misskey.reverseProxy.enable` requires `services.misskey.reverseProxy.host` and `services.misskey.reverseProxy.ssl` to be set.";
      }
    ];

    services.misskey.settings = lib.mkMerge [
      (lib.mkIf cfg.database.createLocally {
        db = {
          db = lib.mkDefault "misskey";
          # Use unix socket instead of localhost to allow PostgreSQL peer authentication,
          # required for `services.postgresql.ensureUsers`
          host = lib.mkDefault "/var/run/postgresql";
          port = lib.mkDefault config.services.postgresql.settings.port;
          user = lib.mkDefault "misskey";
          pass = lib.mkDefault null;
        };
      })
      (lib.mkIf (cfg.database.passwordFile != null) { db.pass = lib.mkDefault "@DATABASE_PASSWORD@"; })
      (lib.mkIf cfg.redis.createLocally { redis.host = lib.mkDefault "localhost"; })
      (lib.mkIf (cfg.redis.passwordFile != null) { redis.pass = lib.mkDefault "@REDIS_PASSWORD@"; })
      (lib.mkIf cfg.meilisearch.createLocally {
        meilisearch = {
          host = lib.mkDefault "localhost";
          port = lib.mkDefault config.services.meilisearch.listenPort;
          ssl = lib.mkDefault false;
        };
      })
      (lib.mkIf (cfg.meilisearch.keyFile != null) {
        meilisearch.apiKey = lib.mkDefault "@MEILISEARCH_KEY@";
      })
      (lib.mkIf cfg.reverseProxy.enable {
        url = lib.mkDefault "${
          if cfg.reverseProxy.ssl then "https" else "http"
        }://${cfg.reverseProxy.host}";
      })
    ];

    systemd.services.misskey = {
      after = [
        "network-online.target"
        "postgresql.service"
      ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        MISSKEY_CONFIG_YML = "/run/misskey/default.yml";
      };
      preStart =
        ''
          install -m 700 ${settingsFormat.generate "misskey-config.yml" cfg.settings} /run/misskey/default.yml
        ''
        + (lib.optionalString (cfg.database.passwordFile != null) ''
          ${pkgs.replace-secret}/bin/replace-secret '@DATABASE_PASSWORD@' "${cfg.database.passwordFile}" /run/misskey/default.yml
        '')
        + (lib.optionalString (cfg.redis.passwordFile != null) ''
          ${pkgs.replace-secret}/bin/replace-secret '@REDIS_PASSWORD@' "${cfg.redis.passwordFile}" /run/misskey/default.yml
        '')
        + (lib.optionalString (cfg.meilisearch.keyFile != null) ''
          ${pkgs.replace-secret}/bin/replace-secret '@MEILISEARCH_KEY@' "${cfg.meilisearch.keyFile}" /run/misskey/default.yml
        '');
      serviceConfig = {
        ExecStart = "${cfg.package}/bin/misskey migrateandstart";
        RuntimeDirectory = "misskey";
        RuntimeDirectoryMode = "700";
        StateDirectory = "misskey";
        StateDirectoryMode = "700";
        TimeoutSec = 60;
        DynamicUser = true;
        User = "misskey";
        LockPersonality = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectProc = "invisible";
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX AF_NETLINK";
      };
    };

    services.postgresql = lib.mkIf cfg.database.createLocally {
      enable = true;
      ensureDatabases = [ "misskey" ];
      ensureUsers = [
        {
          name = "misskey";
          ensureDBOwnership = true;
        }
      ];
    };

    services.redis.servers = lib.mkIf cfg.redis.createLocally {
      misskey = {
        enable = true;
        port = cfg.settings.redis.port;
      };
    };

    services.meilisearch = lib.mkIf cfg.meilisearch.createLocally { enable = true; };

    services.caddy = lib.mkIf (cfg.reverseProxy.enable && cfg.reverseProxy.webserver ? caddy) {
      enable = true;
      virtualHosts.${cfg.settings.url} = lib.mkMerge [
        cfg.reverseProxy.webserver.caddy
        {
          hostName = lib.mkDefault cfg.settings.url;
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.settings.port}
          '';
        }
      ];
    };

    services.nginx = lib.mkIf (cfg.reverseProxy.enable && cfg.reverseProxy.webserver ? nginx) {
      enable = true;
      virtualHosts.${cfg.reverseProxy.host} = lib.mkMerge [
        cfg.reverseProxy.webserver.nginx
        {
          locations."/" = {
            proxyPass = lib.mkDefault "http://localhost:${toString cfg.settings.port}";
            proxyWebsockets = lib.mkDefault true;
            recommendedProxySettings = lib.mkDefault true;
          };
        }
        (lib.mkIf (cfg.reverseProxy.ssl != null) { forceSSL = lib.mkDefault cfg.reverseProxy.ssl; })
      ];
    };
  };

  meta = {
    maintainers = [ lib.maintainers.feathecutie ];
  };
}
