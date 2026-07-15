{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.services.maubot;

  wrapper1 = if cfg.plugins == [ ] then cfg.package else cfg.package.withPlugins (_: cfg.plugins);

  wrapper2 =
    if cfg.pythonPackages == [ ] then wrapper1 else wrapper1.withPythonPackages (_: cfg.pythonPackages);

  settings = lib.recursiveUpdate cfg.settings {
    plugin_directories.trash =
      if cfg.settings.plugin_directories.trash == null then
        "delete"
      else
        cfg.settings.plugin_directories.trash;
    server.unshared_secret = "generate";
  };

  finalPackage = wrapper2.withBaseConfig settings;

  isPostgresql = db: builtins.isString db && lib.hasPrefix "postgresql://" db;
  isLocalPostgresDB =
    db:
    isPostgresql db
    && builtins.any (x: lib.hasInfix x db) [
      "@127.0.0.1/"
      "@::1/"
      "@[::1]/"
      "@localhost/"
    ];
  parsePostgresDB =
    db:
    let
      noSchema = lib.removePrefix "postgresql://" db;
    in
    {
      username = builtins.head (lib.splitString "@" noSchema);
      database = lib.last (lib.splitString "/" noSchema);
    };

  postgresDBs = builtins.filter isPostgresql [
    cfg.settings.database
    cfg.settings.crypto_database
    cfg.settings.plugin_databases.postgres
  ];

  localPostgresDBs = builtins.filter isLocalPostgresDB postgresDBs;

  parsedLocalPostgresDBs = map parsePostgresDB localPostgresDBs;
  parsedPostgresDBs = map parsePostgresDB postgresDBs;

  hasLocalPostgresDB = localPostgresDBs != [ ];
in
{
  options.services.maubot = with lib; {
    enable = mkEnableOption "maubot";

    package = lib.mkPackageOption pkgs "maubot" { };

    plugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression ''
        with config.services.maubot.package.plugins; [
          xyz.maubot.reactbot
          xyz.maubot.rss
        ];
      '';
      description = ''
        List of additional maubot plugins to make available.
      '';
    };

    pythonPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = literalExpression ''
        with pkgs.python3Packages; [
          aiohttp
        ];
      '';
      description = ''
        List of additional Python packages to make available for maubot.
      '';
    };

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/maubot";
      description = ''
        The directory where maubot stores its stateful data.
      '';
    };

    extraConfigFile = mkOption {
      type = types.str;
      default = "./config.yaml";
      defaultText = literalExpression ''"''${config.services.maubot.dataDir}/config.yaml"'';
      description = ''
        A file for storing secrets. You can pass homeserver registration keys here.
        If it already exists, **it must contain `server.unshared_secret`** which is used for signing API keys.
        If `configMutable` is not set to true, **maubot user must have write access to this file**.
      '';
    };

    configMutable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether maubot should write updated config into `extraConfigFile`. **This will make your Nix module settings have no effect besides the initial config, as extraConfigFile takes precedence over NixOS settings!**
      '';
    };

    settings = mkOption {
      default = { };
      description = ''
        YAML settings for maubot. See the
        [example configuration](https://github.com/maubot/maubot/blob/master/maubot/example-config.yaml)
        for more info.

        Secrets should be passed in by using `extraConfigFile`.
      '';
      type =
        with types;
        submodule {
          options = {
            database = mkOption {
              type = str;
              default = "sqlite:maubot.db";
              example = "postgresql://username:password@hostname/dbname";
              description = ''
                The full URI to the database. SQLite and Postgres are fully supported.
                Other DBMSes supported by SQLAlchemy may or may not work.
              '';
            };

            crypto_database = mkOption {
              type = str;
              default = "default";
              example = "postgresql://username:password@hostname/dbname";
              description = ''
                Separate database URL for the crypto database. By default, the regular database is also used for crypto.
              '';
            };

            database_opts = mkOption {
              type = types.attrs;
              default = { };
              description = ''
                Additional arguments for asyncpg.create_pool() or sqlite3.connect()
              '';
            };

            plugin_directories = mkOption {
              default = { };
              description = "Plugin directory paths";
              type = submodule {
                options = {
                  upload = mkOption {
                    type = types.str;
                    default = "./plugins";
                    defaultText = literalExpression ''"''${config.services.maubot.dataDir}/plugins"'';
                    description = ''
                      The directory where uploaded new plugins should be stored.
                    '';
                  };
                  load = mkOption {
                    type = types.listOf types.str;
                    default = [ "./plugins" ];
                    defaultText = literalExpression ''[ "''${config.services.maubot.dataDir}/plugins" ]'';
                    description = ''
                      The directories from which plugins should be loaded. Duplicate plugin IDs will be moved to the trash.
                    '';
                  };
                  trash = mkOption {
                    type = with types; nullOr str;
                    default = "./trash";
                    defaultText = literalExpression ''"''${config.services.maubot.dataDir}/trash"'';
                    description = ''
                      The directory where old plugin versions and conflicting plugins should be moved. Set to null to delete files immediately.
                    '';
                  };
                };
              };
            };

            plugin_databases = mkOption {
              description = "Plugin database settings";
              default = { };
              type = submodule {
                options = {
                  sqlite = mkOption {
                    type = types.str;
                    default = "./plugins";
                    defaultText = literalExpression ''"''${config.services.maubot.dataDir}/plugins"'';
                    description = ''
                      The directory where SQLite plugin databases should be stored.
                    '';
                  };

                  postgres = mkOption {
                    type = types.nullOr types.str;
                    default = if isPostgresql cfg.settings.database then "default" else null;
                    defaultText = literalExpression ''if isPostgresql config.services.maubot.settings.database then "default" else null'';
                    description = ''
                      The connection URL for plugin database. See [example config](https://github.com/maubot/maubot/blob/master/maubot/example-config.yaml) for exact format.
                    '';
                  };

                  postgres_max_conns_per_plugin = mkOption {
                    type = types.nullOr types.int;
                    default = 3;
                    description = ''
                      Maximum number of connections per plugin instance.
                    '';
                  };

                  postgres_opts = mkOption {
                    type = types.attrs;
                    default = { };
                    description = ''
                      Overrides for the default database_opts when using a non-default postgres connection URL.
                    '';
                  };
                };
              };
            };

            server = mkOption {
              default = { };
              description = "Listener config";
              type = submodule {
                options = {
                  hostname = mkOption {
                    type = types.str;
                    default = "127.0.0.1";
                    description = ''
                      The IP to listen on
                    '';
                  };
                  port = mkOption {
                    type = types.port;
                    default = 29316;
                    description = ''
                      The port to listen on
                    '';
                  };
                  public_url = mkOption {
                    type = types.str;
                    default = "http://${cfg.settings.server.hostname}:${toString cfg.settings.server.port}";
                    defaultText = literalExpression ''"http://''${config.services.maubot.settings.server.hostname}:''${toString config.services.maubot.settings.server.port}"'';
                    description = ''
                      Public base URL where the server is visible.
                    '';
                  };
                  ui_base_path = mkOption {
                    type = types.str;
                    default = "/_matrix/maubot";
                    description = ''
                      The base path for the UI.
                    '';
                  };
                  plugin_base_path = mkOption {
                    type = types.str;
                    default = "${config.services.maubot.settings.server.ui_base_path}/plugin/";
                    defaultText = literalExpression ''
                      "''${config.services.maubot.settings.server.ui_base_path}/plugin/"
                    '';
                    description = ''
                      The base path for plugin endpoints. The instance ID will be appended directly.
                    '';
                  };
                  override_resource_path = mkOption {
                    type = types.nullOr types.str;
                    default = null;
                    description = ''
                      Override path from where to load UI resources.
                    '';
                  };
                };
              };
            };

            homeservers = mkOption {
              type = types.attrsOf (
                types.submodule {
                  options = {
                    url = mkOption {
                      type = types.str;
                      description = ''
                        Client-server API URL
                      '';
                    };
                  };
                }
              );
              default = {
                "matrix.org" = {
                  url = "https://matrix-client.matrix.org";
                };
              };
              description = ''
                Known homeservers. This is required for the `mbc auth` command and also allows more convenient access from the management UI.
                If you want to specify registration secrets, pass this via extraConfigFile instead.
              '';
            };

            admins = mkOption {
              type = types.attrsOf types.str;
              default = {
                root = "";
              };
              description = ''
                List of administrator users. Plaintext passwords will be bcrypted on startup. Set empty password
                to prevent normal login. Root is a special user that can't have a password and will always exist.
              '';
            };

            api_features = mkOption {
              type = types.attrsOf bool;
              default = {
                login = true;
                plugin = true;
                plugin_upload = true;
                instance = true;
                instance_database = true;
                client = true;
                client_proxy = true;
                client_auth = true;
                dev_open = true;
                log = true;
              };
              description = ''
                API feature switches.
              '';
            };

            logging = mkOption {
              type = types.attrs;
              description = ''
                Python logging configuration. See [section 16.7.2 of the Python
                documentation](https://docs.python.org/3.6/library/logging.config.html#configuration-dictionary-schema)
                for more info.
              '';
              default = {
                version = 1;
                formatters = {
                  colored = {
                    "()" = "maubot.lib.color_log.ColorFormatter";
                    format = "[%(asctime)s] [%(levelname)s@%(name)s] %(message)s";
                  };
                  normal = {
                    format = "[%(asctime)s] [%(levelname)s@%(name)s] %(message)s";
                  };
                };
                handlers = {
                  file = {
                    class = "logging.handlers.RotatingFileHandler";
                    formatter = "normal";
                    filename = "./maubot.log";
                    maxBytes = 10485760;
                    backupCount = 10;
                  };
                  console = {
                    class = "logging.StreamHandler";
                    formatter = "colored";
                  };
                };
                loggers = {
                  maubot = {
                    level = "DEBUG";
                  };
                  mau = {
                    level = "DEBUG";
                  };
                  aiohttp = {
                    level = "INFO";
                  };
                };
                root = {
                  level = "DEBUG";
                  handlers = [
                    "file"
                    "console"
                  ];
                };
              };
            };
          };
        };
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional (builtins.any (x: x.username != x.database) parsedLocalPostgresDBs) ''
      The Maubot database username doesn't match the database name! This means the user won't be automatically
      granted ownership of the database. Consider changing either the username or the database name.
    '';
    assertions = [
      {
        assertion = builtins.all (x: !lib.hasInfix ":" x.username) parsedPostgresDBs;
        message = ''
          Putting database passwords in your Nix config makes them world-readable. To securely put passwords
          in your Maubot config, change /var/lib/maubot/config.yaml after running Maubot at least once as
          described in the NixOS manual.
        '';
      }
      {
        assertion = hasLocalPostgresDB -> config.services.postgresql.enable;
        message = ''
          Cannot deploy maubot with a configuration for a local postgresql database and a missing postgresql service.
        '';
      }
    ];

    services.postgresql = lib.mkIf hasLocalPostgresDB {
      enable = true;
      ensureDatabases = map (x: x.database) parsedLocalPostgresDBs;
      ensureUsers = lib.flip map parsedLocalPostgresDBs (x: {
        name = x.username;
        ensureDBOwnership = lib.mkIf (x.username == x.database) true;
      });
    };

    users.users.maubot = {
      group = "maubot";
      home = cfg.dataDir;
      # otherwise StateDirectory is enough
      createHome = lib.mkIf (cfg.dataDir != "/var/lib/maubot") true;
      isSystemUser = true;
    };

    users.groups.maubot = { };

    systemd.services.maubot = rec {
      description = "maubot - a plugin-based Matrix bot system written in Python";
      after = [ "network.target" ] ++ wants ++ lib.optional hasLocalPostgresDB "postgresql.target";
      # all plugins get automatically disabled if maubot starts before synapse
      wants = lib.optional config.services.matrix-synapse.enable config.services.matrix-synapse.serviceUnit;
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        if [ ! -f "${cfg.extraConfigFile}" ]; then
          echo "server:" > "${cfg.extraConfigFile}"
          echo "    unshared_secret: $(head -c40 /dev/random | base32 | ${pkgs.gawk}/bin/awk '{print tolower($0)}')" > "${cfg.extraConfigFile}"
          chmod 640 "${cfg.extraConfigFile}"
        fi
      '';

      serviceConfig = {
        ExecStart =
          "${finalPackage}/bin/maubot --config ${cfg.extraConfigFile}"
          + lib.optionalString (!cfg.configMutable) " --no-update";
        User = "maubot";
        Group = "maubot";
        Restart = "on-failure";
        RestartSec = "10s";
        StateDirectory = lib.mkIf (cfg.dataDir == "/var/lib/maubot") "maubot";
        WorkingDirectory = cfg.dataDir;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ chayleaf ];
  meta.doc = ./maubot.md;
}
