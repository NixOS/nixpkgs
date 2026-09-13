{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.nodebb;
  settingsFormat = pkgs.formats.json { };
  extraPluginIds = cfg.package.extraPluginIds or [ ];
  dbType = cfg.database.type;

  # web-push VAPID subject must be https: or mailto:.
  defaultPlugins =
    lib.filter (
      p: p != "nodebb-plugin-web-push" || lib.hasPrefix "https://" cfg.settings.url
    ) cfg.package.defaultPlugins
    ++ extraPluginIds;

  configFile =
    let
      unused = lib.filter (name: dbType != name) [
        "mongo"
        "postgres"
        "redis"
      ];
    in
    settingsFormat.generate "config.json" (
      (lib.removeAttrs cfg.settings (unused ++ [ "database" ]))
      // {
        database = dbType;
        plugins.active = cfg.plugins;
        acpPluginInstallDisabled = true;
      }
    );

  applyPassword =
    if cfg.database.passwordFile != null then
      ''
        password=$(cat ${cfg.database.passwordFile})
        jq --arg p "$password" '.${dbType}.password = $p' \
          "$dest/config.json" > "$dest/config.json.new"
        chmod 0600 "$dest/config.json.new"
        mv "$dest/config.json.new" "$dest/config.json"
      ''
    else
      ''
        jq 'del(.${dbType}.password)' \
          "$dest/config.json" > "$dest/config.json.new"
        chmod 0600 "$dest/config.json.new"
        mv "$dest/config.json.new" "$dest/config.json"
      '';
in
{
  options.services.nodebb = {
    enable = lib.mkEnableOption "NodeBB";
    package = lib.mkPackageOption pkgs "nodebb" { };

    user = lib.mkOption {
      type = lib.types.str;
      default = "nodebb";
      description = "The user NodeBB runs as.";
    };

    group = lib.mkOption {
      type = lib.types.str;
      default = "nodebb";
      description = "The group NodeBB runs as.";
    };

    plugins = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = defaultPlugins;
      defaultText = lib.literalExpression ''
        (lib.filter (p: p != "nodebb-plugin-web-push" || lib.hasPrefix "https://" config.services.nodebb.settings.url)
          config.services.nodebb.package.defaultPlugins)
        ++ (config.services.nodebb.package.extraPluginIds or [ ])
      '';
      example = [
        "nodebb-plugin-markdown"
        "nodebb-theme-harmony"
      ];
      description = ''
        Plugin ids written to `plugins.active` in config.json. nconf resolves
        `nconf.get("plugins:active")` to this nested list, which overrides the
        database plugin set. Must include the active theme
        (`nodebb-theme-harmony` by default) or setup fails. web-push is omitted
        unless `settings.url` is https.

        Extra packaged plugins come from `package = pkgs.nodebb.withPackages
        (ps: [ … ])`; list their ids here if you override this option instead
        of using the default.
      '';
    };

    admin = {
      username = lib.mkOption {
        type = lib.types.str;
        example = "admin";
        description = "Admin username created on first setup.";
      };

      email = lib.mkOption {
        type = lib.types.str;
        example = "admin@example.com";
        description = "Admin email created on first setup.";
      };

      passwordFile = lib.mkOption {
        type = lib.types.path;
        description = "File containing the admin password (first setup only).";
      };
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open `settings.port` in the firewall.";
    };

    database = {
      type = lib.mkOption {
        type = lib.types.enum [
          "mongo"
          "postgres"
          "redis"
        ];
        default = "postgres";
        description = "Primary database backend. Written to config.json as `database`.";
      };

      createLocally = lib.mkEnableOption "a local PostgreSQL or Redis instance for NodeBB";

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          File containing the database password. Required for MongoDB and for
          PostgreSQL when not using peer authentication. Optional for Redis.
        '';
      };
    };

    settings = lib.mkOption {
      description = "Settings written to NodeBB's config.json.";
      type = lib.types.submodule {
        freeformType = settingsFormat.type;
        options = {
          url = lib.mkOption {
            type = lib.types.str;
            default = "http://localhost:4567";
            description = "Public URL of this NodeBB.";
          };

          port = lib.mkOption {
            type = lib.types.port;
            default = 4567;
            description = "Port NodeBB listens on.";
          };

          mongo = {
            host = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              description = "MongoDB host.";
            };
            port = lib.mkOption {
              type = lib.types.port;
              default = 27017;
              description = "MongoDB port.";
            };
            username = lib.mkOption {
              type = lib.types.str;
              default = "nodebb";
              description = "MongoDB user.";
            };
            database = lib.mkOption {
              type = lib.types.str;
              default = "nodebb";
              description = "MongoDB database name.";
            };
          };

          postgres = {
            host = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              # mkDefault in config recurses: generating config.json forces
              # every settings.* value, including this one, whose mkIf would
              # read cfg.settings. apply only reads database.createLocally + type.
              apply =
                host:
                if cfg.database.createLocally && dbType == "postgres" && host == "127.0.0.1" then
                  "/run/postgresql"
                else
                  host;
              description = ''
                PostgreSQL host. With `database.createLocally`, the default
                `127.0.0.1` is rewritten to the unix socket so the service can
                use peer authentication. Set a different host to keep TCP.
              '';
            };
            port = lib.mkOption {
              type = lib.types.port;
              default = 5432;
              description = "PostgreSQL port.";
            };
            username = lib.mkOption {
              type = lib.types.str;
              default = "nodebb";
              description = "PostgreSQL user.";
            };
            database = lib.mkOption {
              type = lib.types.str;
              default = "nodebb";
              description = "PostgreSQL database name.";
            };
            ssl = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = "Whether to use TLS for PostgreSQL.";
            };
          };

          redis = {
            host = lib.mkOption {
              type = lib.types.str;
              default = "127.0.0.1";
              description = "Redis host.";
            };
            port = lib.mkOption {
              type = lib.types.port;
              default = 6379;
              description = "Redis port.";
            };
            database = lib.mkOption {
              type = lib.types.int;
              default = 0;
              description = "Redis database index.";
            };
          };
        };
      };
      default = { };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = !(cfg.database.createLocally && dbType == "mongo");
          message = "services.nodebb.database.createLocally does not provision MongoDB. Use an external MongoDB or set database.type to postgres or redis.";
        }
        {
          assertion =
            dbType != "postgres"
            || cfg.database.passwordFile != null
            || cfg.settings.postgres.host == "/run/postgresql";
          message = "services.nodebb.database.passwordFile is required for PostgreSQL unless settings.postgres.host is the local unix socket.";
        }
        {
          assertion = dbType != "mongo" || cfg.database.passwordFile != null;
          message = "services.nodebb.database.passwordFile is required when using MongoDB.";
        }
        {
          assertion =
            !(cfg.database.createLocally && dbType == "postgres")
            || cfg.settings.postgres.host != "/run/postgresql"
            || cfg.settings.postgres.username == cfg.user;
          message = "services.nodebb.settings.postgres.username must match services.nodebb.user when using the local unix socket.";
        }
      ];

      systemd.services.nodebb = {
        description = "NodeBB";
        documentation = [ "https://docs.nodebb.org" ];
        wantedBy = [ "multi-user.target" ];
        after = [
          "network-online.target"
        ]
        ++ lib.optional (cfg.database.createLocally && dbType == "postgres") "postgresql.service"
        ++ lib.optional (cfg.database.createLocally && dbType == "redis") "redis-nodebb.service";
        wants = [ "network-online.target" ];
        requires =
          lib.optional (cfg.database.createLocally && dbType == "postgres") "postgresql.service"
          ++ lib.optional (cfg.database.createLocally && dbType == "redis") "redis-nodebb.service";

        environment = {
          NODE_ENV = "production";
          CONFIG = "/var/lib/nodebb/config.json";
        };

        path = with pkgs; [
          rsync
          jq
          cfg.package.nodejs
        ];

        serviceConfig = {
          Type = "simple";
          User = cfg.user;
          Group = cfg.group;
          StateDirectory = "nodebb";
          StateDirectoryMode = "0750";
          WorkingDirectory = "/var/lib/nodebb";
          ExecStart = "${lib.getExe cfg.package.nodejs} app.js";
          Restart = "on-failure";
          RestartSec = "5s";
          TimeoutStartSec = "15min";
          UMask = "0077";
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          NoNewPrivileges = true;
          RestrictAddressFamilies = [
            "AF_INET"
            "AF_INET6"
            "AF_UNIX"
          ];
          ReadWritePaths = [ "/var/lib/nodebb" ];
        };

        preStart = ''
          set -eu
          src=${cfg.package}/lib/node_modules/nodebb
          dest=/var/lib/nodebb

          write_config() {
            {
              if [ -f "$dest/config.json" ]; then cat "$dest/config.json"; else echo '{}'; fi
              cat ${configFile}
            } | jq -s '.[0] * .[1] | del(."plugins:active")' > "$dest/config.json.new"
            chmod 0600 "$dest/config.json.new"
            mv "$dest/config.json.new" "$dest/config.json"
            ${applyPassword}
          }

          mkdir -p "$dest/public/uploads/system" "$dest/logs"
          write_config

          if [ "${cfg.package}" != "$(cat "$dest/.install-hash" 2>/dev/null || true)" ]; then
            rsync -a --chmod=u+w \
              --exclude config.json \
              --exclude public/uploads \
              --exclude logs \
              --exclude pidfile \
              --exclude .install-hash \
              "$src/" "$dest/"
            mkdir -p "$dest/public/uploads/system" "$dest/logs"

            export NODEBB_ADMIN_USERNAME=${lib.escapeShellArg cfg.admin.username}
            export NODEBB_ADMIN_EMAIL=${lib.escapeShellArg cfg.admin.email}
            export NODEBB_ADMIN_PASSWORD="$(cat ${cfg.admin.passwordFile})"
            export NODEBB_DB=${lib.escapeShellArg dbType}
            ${lib.optionalString (cfg.database.passwordFile != null) ''
              export NODEBB_DB_PASSWORD="$(cat ${cfg.database.passwordFile})"
            ''}
            # nconf already loaded CONFIG; admin/DB secrets come from env.
            # Do not pass config.json on argv (world-readable /proc/cmdline).
            ./nodebb setup '{}'
            write_config
            echo ${lib.escapeShellArg "${cfg.package}"} > "$dest/.install-hash"
          fi
        '';
      };

      users = {
        groups = lib.mkIf (cfg.group == "nodebb") { nodebb = { }; };
        users = lib.mkIf (cfg.user == "nodebb") {
          nodebb = {
            inherit (cfg) group;
            isSystemUser = true;
          };
        };
      };

      networking.firewall.allowedTCPPorts = lib.optional cfg.openFirewall cfg.settings.port;
    })
    (lib.mkIf (cfg.enable && cfg.database.createLocally && dbType == "postgres") {
      services.postgresql = {
        enable = true;
        ensureDatabases = [ cfg.settings.postgres.database ];
        ensureUsers = [
          {
            name = cfg.settings.postgres.username;
            ensureDBOwnership = true;
          }
        ];
      };
    })
    (lib.mkIf (cfg.enable && cfg.database.createLocally && dbType == "redis") {
      services.nodebb.database.passwordFile = lib.mkDefault (
        config.services.redis.servers.nodebb.requirePassFile
      );
      services.redis.servers.nodebb = {
        enable = true;
        port = cfg.settings.redis.port;
      };
    })
  ];

  meta.maintainers = with lib.maintainers; [
    lucasew
    prince213
  ];
}
