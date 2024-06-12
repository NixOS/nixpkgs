{ config
, pkgs
, lib
, ...
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
          description = "The final user-facing URL. Do not change after running Misskey for the first time.";
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
                description = "The PostgreSQL port";
              };
              db = lib.mkOption {
                type = lib.types.str;
                default = "misskey";
                description = "The database name";
              };
              user = lib.mkOption {
                type = lib.types.str;
                default = "misskey";
                description = "The user used for database authentication";
              };
              pass = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "The password used for database authentication";
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
          type = lib.types.nullOr (lib.types.submodule {
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
                type = lib.types.enum [ "local" "global" ];
                default = "local";
                description = "The search scope.";
              };
            };
          });
          default = null;
        };
        id = lib.mkOption {
          type = lib.types.enum [ "aid" "aidx" "meid" "ulid" "objectid" ];
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
          description = "Create the PostgreSQL database locally. Overrides `settings.db.{db,host,port,user,pass}`.";
        };
        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "The path to a file containing the database password. Overrides `settings.db.pass`.";
        };
      };
      redis = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Create and use a local Redis instance. Overrides `settings.redis.host`";
        };
        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "The path to a file containing the Redis password. Overrides `settings.redis.pass`.";
        };
      };
      meilisearch = {
        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "Create and use a local Meilisearch instance. Overrides `settings.meilisearch.{host,port,ssl}`";
        };
        keyFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "The path to a file containing the Meilisearch API key. Overrides `settings.meilisearch.apiKey`.";
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
              type = lib.types.submodule (import ../web-servers/caddy/vhost-options.nix { cfg = config.services.caddy; });
              default = { };
              description = ''
                Extra configuration for the caddy virtual host of Misskey.
                Set to `{ }` to use the default configuration.
              '';
            };
          };
          description = "The webserver to use as the reverse proxy.";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.misskey.settings = {
      db = (lib.optionalAttrs cfg.database.createLocally {
        db = "misskey";
        # Use unix socket instead of localhost to allow PostgreSQL peer authentication,
        # required for `services.postgresql.ensureUsers`
        host = "/var/run/postgresql";
        port = config.services.postgresql.settings.port;
        user = "misskey";
        pass = null;
      }) // (lib.optionalAttrs (cfg.database.passwordFile != null) {
        pass = "@DATABASE_PASSWORD@";
      });
      redis = (lib.optionalAttrs cfg.redis.createLocally {
        host = "localhost";
      }) // (lib.optionalAttrs (cfg.redis.passwordFile != null) {
        pass = "@REDIS_PASSWORD@";
      });
      meilisearch =
        if (cfg.meilisearch.createLocally || (cfg.meilisearch.keyFile != null)) then
          ((lib.optionalAttrs cfg.meilisearch.createLocally {
            host = "localhost";
            port = config.services.meilisearch.listenPort;
            ssl = false;
          }) // (lib.optionalAttrs (cfg.meilisearch.keyFile != null) {
            apiKey = "@MEILISEARCH_KEY@";
          })) else null;
    };

    systemd.services.misskey = {
      after = [ "network-online.target" "postgresql.service" ];
      wants = [ "network-online.target" ];
      wantedBy = [ "multi-user.target" ];
      environment = {
        MISSKEY_CONFIG_YML = "/run/misskey/default.yml";
      };
      preStart = ''
        install -m 700 ${settingsFormat.generate "misskey-config.yml" cfg.settings} /run/misskey/default.yml
      '' + (lib.optionalString (cfg.database.passwordFile != null) ''
        ${pkgs.replace-secret}/bin/replace-secret '@DATABASE_PASSWORD@' "${cfg.database.passwordFile}" /run/misskey/default.yml
      '') + (lib.optionalString (cfg.redis.passwordFile != null) ''
        ${pkgs.replace-secret}/bin/replace-secret '@REDIS_PASSWORD@' "${cfg.redis.passwordFile}" /run/misskey/default.yml
      '') + (lib.optionalString (cfg.meilisearch.keyFile != null) ''
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

    services.meilisearch = lib.mkIf cfg.meilisearch.createLocally {
      enable = true;
    };

    services.caddy.virtualHosts = lib.mkIf (cfg.reverseProxy.enable && cfg.reverseProxy.webserver ? caddy) {
      ${cfg.settings.url} = lib.mkMerge [
        cfg.reverseProxy.webserver.caddy
        {
          hostName = lib.mkForce cfg.settings.url;
          extraConfig = ''
            reverse_proxy localhost:${toString cfg.settings.port}
          '';
        }
      ];
    };

    services.nginx.virtualHosts = lib.mkIf (cfg.reverseProxy.enable && cfg.reverseProxy.webserver ? nginx) {
      ${cfg.settings.url} = lib.mkMerge [
        cfg.reverseProxy.webserver.nginx
        {
          locations."/" = {
            proxyPass = "http://localhost:${toString cfg.settings.port}";
            proxyWebsockets = true;
            recommendedProxySettings = true;
          };
        }
      ];
    };
  };

  meta = {
    maintainers = [ lib.maintainers.feathecutie ];
  };
}
