{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.openlist;
  settingsFormat = pkgs.formats.json { };

  certFile = cfg.settings.scheme.cert_file;
  keyFile = cfg.settings.scheme.key_file;
in
{
  options = {
    services.openlist = {
      enable = lib.mkEnableOption "OpenList, a file list program";

      stateDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/openlist";
        description = "OpenList stores data and config file in this directory. Corresponds to the `--data` CLI argument.";
      };

      user = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "OpenList user name. If not set, a user named `openlist` will be created.";
      };

      group = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "OpenList group name. If not set, a group named `openlist` will be created.";
      };

      mutableConfig = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Allow OpenList to persist settings in the config file.";
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [
          "--log-std"
          "--dev"
          "--no-prefix"
        ];
        description = "Extra flags passed to the openlist server command. Use this to pass CLI arguments such as `--debug`, `--dev`, `--no-prefix`, or `--force-bin-dir`.";
      };

      package = lib.mkPackageOption pkgs "openlist" { };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        example = lib.literalExpression "[ pkgs.ffmpeg-headless ]";
        description = "Additional packages to add to the service's PATH environment variable. For video thumbnail support, add pkgs.ffmpeg-headless.";
      };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            force = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = "By default OpenList reads the configuration from environment variables, set this field to true to force OpenList to read config from the configuration file.";
            };

            site_url = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The address of your OpenList server. This address is essential for some features, and thus thry may not work properly if unset:
                - thumbnailing LocalStorage
                - previewing site after setting web proxy
                - displaying download address after setting web proxy
                - reverse-proxying to site sub directories
                - ...
                Do not include the slash (/) at the end of the address.
              '';
            };

            cdn = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The address of the CDN. Included `$version` values will be dynamically replaced by the version of OpenList. Existing dist resources are hosted on both npm and GitHub, which can be found at:

                - https://www.npmjs.com/package/@openlist-frontend/openlist-frontend
                - https://github.com/OpenListTeam/OpenList-Frontend
                Thus it is possible to use any npm or GitHub CDN path for this field. For example:

                - https://registry.npmmirror.com/@openlist-frontend/openlist-frontend/$version/files/dist/
                - https://cdn.jsdelivr.net/npm/@openlist-frontend/openlist-frontend@$version/dist/
                - https://unpkg.com/@openlist-frontend/openlist-frontend@$version/dist/

                Keep empty to use local dist resources.
              '';
            };

            jwt_secret = lib.mkOption {
              type = lib.types.nullOr (lib.types.attrsOf lib.types.path);
              default = null;
              example = {
                _secret = "/run/secrets/openlist-jwt";
              };
              description = ''
                The secret used to sign the JWT token, should be a random string.

                This setting is optional. However, if `mutableConfig` is set to false and
                this option is not configured, OpenList will generate a different
                `jwt_secret` each time it restarts. This may affect the functionality
                of the `sign` feature as well as session persistence.
              '';
            };

            token_expires_in = lib.mkOption {
              type = lib.types.int;
              default = 48;
              description = "User login expiration time, in hours.";
            };

            database = {
              type = lib.mkOption {
                type = lib.types.enum [
                  "sqlite3"
                  "mysql"
                  "postgres"
                ];
                default = "sqlite3";
                description = "Database type to use.";
              };

              host = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = "127.0.0.1";
                description = "Database host. Only used when `database.type` is `mysql` or `postgres`.";
              };

              port = lib.mkOption {
                type = lib.types.port;
                default = 0;
                example = 3306;
                description = "Database port. Only used when `database.type` is `mysql` or `postgres`.";
              };

              user = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = "root";
                description = "Database account. Only used when `database.type` is `mysql` or `postgres`.";
              };

              password = lib.mkOption {
                type = lib.types.nullOr (lib.types.attrsOf lib.types.path);
                default = null;
                example = {
                  _secret = "/run/secrets/openlist-db-password";
                };
                description = "Database password. Only used when `database.type` is `mysql` or `postgres`. Set to an attribute set containing `_secret` to reference a secret file.";
              };

              name = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = "openlist";
                description = "Database name. Only used when `database.type` is `mysql` or `postgres`.";
              };

              db_file = lib.mkOption {
                type = lib.types.str;
                default = "/var/lib/openlist/data.db";
                description = "Database location. Only used when `database.type` is `sqlite3`.";
              };

              table_prefix = lib.mkOption {
                type = lib.types.str;
                default = "openlist_";
                description = "Database table name prefix.";
              };

              ssl_mode = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "To control the encryption options during the SSL handshake. Only used when `database.type` is `mysql` or `postgres`.";
              };

              dsn = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "";
                description = ''
                  Custom DSN connection string. If set, overrides all other database
                  connection options (`host`, `port`, `user`, `password`, `name`,
                  `ssl_mode`). Useful for advanced connection parameters not exposed
                  as individual options.

                  Example (MySQL):
                    `root:password@unix(/run/mysqld/mysqld.sock)/testdb?charset=utf8mb4&parseTime=True&loc=Local`

                  Example (PostgreSQL):
                    `user=username password=password host=/run/postgresql dbname=dbname port=5432 sslmode=disable`

                  For more details, see <https://gorm.io/docs/connecting_to_the_database.html>.
                '';
              };
            };

            scheme = {
              address = lib.mkOption {
                type = lib.types.str;
                default = "[::1]";
                description = "The http/https address to listen on.";
              };
              http_port = lib.mkOption {
                type = lib.types.nullOr lib.types.port;
                default = 5244;
                apply = v: if v != null then v else -1;
                description = "The http port to listen on, default `5244`, set it to `null` to disable http.";
              };
              https_port = lib.mkOption {
                type = lib.types.nullOr lib.types.port;
                default = null;
                apply = v: if v != null then v else -1;
                description = "The https port to listen on, default `null`, set it to non `null` to enable https.";
              };
              force_https = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = "Whether the HTTPS protocol is forcibly, if it is set to True, the user can only access the website through HTTPS.";
              };
              cert_file = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
                description = "Path of cert file.";
              };
              key_file = lib.mkOption {
                type = lib.types.nullOr lib.types.path;
                default = null;
                description = "Path of key file.";
              };
              unix_file = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Unix socket file path to listen on. Set to non-null to enable unix socket.";
              };
              unix_file_perm = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Unix socket file permission, set to the appropriate permissions, like `0644`.";
              };
            };
          };
        };
        default = { };
        apply = s: if s.jwt_secret == null then lib.removeAttrs s [ "jwt_secret" ] else s;
        description = ''
          The OpenList configuration, see <https://doc.oplist.org/configuration/configuration>
          for possible options.

          Options containing secret data should be set to an attribute set
          containing the attribute `_secret`. This attribute should be a string
          or structured JSON with `quote = false;`, pointing to a file that
          contains the value the option should be set to.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.openlist.settings = {
      force = false;
      temp_dir = "/tmp";
    };

    users = {
      users.openlist = lib.mkIf (cfg.user == null) {
        description = "OpenList user";
        isSystemUser = true;
        group = if cfg.group == null then "openlist" else cfg.group;
      };
      groups.openlist = lib.mkIf (cfg.group == null) { };
    };

    systemd.services.openlist = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      preStart = ''
        umask 0077
        mkdir -p ${cfg.stateDir}
        ${utils.genJqSecretsReplacementSnippet cfg.settings "/run/openlist/new"}
      ''
      + (
        if cfg.mutableConfig then
          ''
            if [ -e "${cfg.stateDir}/config.json" ]; then
              cp "${cfg.stateDir}/config.json" /run/openlist/old
              ${lib.getExe pkgs.jq} -s '.[0] * .[1]' /run/openlist/old /run/openlist/new > /run/openlist/result
              mv /run/openlist/result /run/openlist/new
              rm -f /run/openlist/old
            fi
            mv /run/openlist/new "${cfg.stateDir}/config.json"
          ''
        else
          ''
            mv /run/openlist/new "${cfg.stateDir}/config.json"
          ''
      )
      + lib.optionalString (certFile != null) ''
        export OPENLIST_CERT_FILE="''${CREDENTIALS_DIRECTORY}/tls-cert"
        export CERT_FILE="''${CREDENTIALS_DIRECTORY}/tls-cert"
      ''
      + lib.optionalString (keyFile != null) ''
        export OPENLIST_KEY_FILE="''${CREDENTIALS_DIRECTORY}/tls-key"
        export KEY_FILE="''${CREDENTIALS_DIRECTORY}/tls-key"
      '';

      serviceConfig =
        let
          needPerm =
            (cfg.settings.scheme.http_port != -1 && cfg.settings.scheme.http_port < 1024)
            || (cfg.settings.scheme.https_port != -1 && cfg.settings.scheme.https_port < 1024);
        in
        {
          User = if cfg.user == null then "openlist" else cfg.user;
          Group = if cfg.group == null then "openlist" else cfg.group;
          Type = "simple";

          ExecStart =
            "${lib.getExe cfg.package} server --log-std "
            + lib.escapeShellArgs (
              [
                "--data"
                cfg.stateDir
              ]
              ++ cfg.extraFlags
            );

          Restart = "on-failure";
          RestartSec = "10s";

          StateDirectory = [ "openlist" ];
          RuntimeDirectory = [ "openlist" ];
          WorkingDirectory = cfg.stateDir;

          LoadCredential =
            lib.optional (certFile != null) "tls-cert:${certFile}"
            ++ lib.optional (keyFile != null) "tls-key:${keyFile}";

          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateUsers = !needPerm;
          NoNewPrivileges = true;
          ReadWritePaths = [ cfg.stateDir ];
          RestrictSUIDSGID = true;
          RemoveIPC = true;
          PrivateDevices = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectHostname = true;
          ProtectProc = "invisible";
          MemoryDenyWriteExecute = true;
          UMask = "0077";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
          AmbientCapabilities = lib.optional needPerm "CAP_NET_BIND_SERVICE";
          CapabilityBoundingSet = lib.optional needPerm "CAP_NET_BIND_SERVICE";
        };

      path = cfg.extraPackages;
    };
  };

  meta = {
    doc = ./openlist.md;
    maintainers = with lib.maintainers; [
      knightfemale
    ];
  };
}
