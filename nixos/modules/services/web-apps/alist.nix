{
  config,
  lib,
  pkgs,
  utils,
  ...
}:
let
  cfg = config.services.alist;
  settingsFormat = pkgs.formats.json { };
in
{
  meta = {
    maintainers = with lib.maintainers; [ moraxyc ];
  };

  options = {
    services.alist = {
      enable = lib.mkEnableOption "alist, a file list program";
      debug = lib.mkEnableOption "debug mode of alist";

      user = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Alist user name. If this is not set, a user named `alist` will be created.";
      };

      group = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "Alist group name. If this is not set, a group named `alist` will be created.";
      };

      stateDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/alist";
        description = "Alist stores data and config file in this directory.";
      };

      mutableConfig = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Allow Alist to persist settings in the config file.";
      };

      extraFlags = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        example = [ "--dev" ];
        description = ''
          Extra flags passed to the alist command.
        '';
      };

      package = lib.mkPackageOption pkgs "alist" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            jwt_secret = lib.mkOption {
              type = lib.types.nullOr (lib.types.attrsOf lib.types.path);
              example = {
                _secret = "/run/secrets/alist-jwt";
              };
              default = null;
              description = ''
                The secret used to sign the JWT token, should be a random string.

                This setting is optional. However, please note that if `mutableConfig`
                is set to false and this option is not configured, Alist will generate
                a different `jwt_secret` each time it restarts.
                This may affect the functionality of the `sign` feature as well as session persistence.
              '';
            };
            database = {
              type = lib.mkOption {
                type = lib.types.enum [
                  "sqlite3"
                  "mysql"
                  "postgres"
                ];
                default = "sqlite3";
                description = ''
                  Database type to use.
                '';
              };
              password = lib.mkOption {
                type = lib.types.nullOr (lib.types.attrsOf lib.types.path);
                default = null;
                example = {
                  _secret = "/run/secrets/alist-db-password";
                };
                description = "Database password";
              };
              db_file = lib.mkOption {
                type = lib.types.str;
                default = "/var/lib/alist/data.db";
                description = "Location where to store the database. This is only used by sqlite3.";
              };
              dsn = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "";
                description = ''
                  A flexible way to configure the database connection.
                  Supports connecting via Unix sockets or other non-standard configurations.

                  Example (MySQL):
                    `root:password@unix(/run/mysqld/mysqld.sock)/testdb?charset=utf8mb4&parseTime=True&loc=Local`

                  Example (PostgreSQL):
                    `user=username password=password host=/run/postgresql dbname=dbname port=5432 sslmode=disable``

                  For more details, see <https://gorm.io/docs/connecting_to_the_database.html>.
                '';
              };
            };
            scheme = {
              address = lib.mkOption {
                type = lib.types.str;
                default = "[::1]";
                description = ''
                  The ip address to listen on.
                '';
              };
              http_port = lib.mkOption {
                type = lib.types.nullOr lib.types.port;
                default = 5244;
                apply = v: if v != null then v else -1;
                description = ''
                  The http port to listen on, default `5244`, set it to `null` to disable `http`.
                '';
              };
              https_port = lib.mkOption {
                type = lib.types.nullOr lib.types.port;
                default = null;
                apply = v: if v != null then v else -1;
                description = ''
                  The https port to listen on, default `null`, set it to non `null` to enable `https`.
                '';
              };
              unix_file = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = ''
                  Unix socket file path to listen on, default empty, set it to non empty to enable unix socket.
                '';
              };
              unix_file_perm = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = ''
                  Unix socket file permission, set to the appropriate permissions, like `0644`.
                '';
              };
            };
          };
        };
        # Remove jwt_secret to let Alist generate a random one.
        apply = s: if s.jwt_secret == null then lib.removeAttrs s [ "jwt_secret" ] else s;
        default = { };
        description = ''
          The alist configuration, see <https://alist.nn.ci/config/configuration.html>
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
    services.alist.settings = {
      # Let Alist read tls-related configurations from environment variables
      force = false;
      # systemd.services.alist.serviceConfig.PrivateTmp
      temp_dir = "/tmp";
    };

    # Alist may store files in local paths, so make the alist user permanent.
    users.users.alist = lib.mkIf (cfg.user == null) {
      description = "Alist user";
      isSystemUser = true;
      group = if (cfg.group == null) then "alist" else cfg.group;
    };
    users.groups.alist = lib.mkIf (cfg.group == null) { };

    systemd.services.alist = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # If mutableConfig is true, overwrite the contents of cfg.settings to the existing configuration
      preStart =
        utils.genJqSecretsReplacementSnippet cfg.settings "/run/alist/new"
        + lib.optionalString cfg.mutableConfig ''
          if [ -e "${cfg.stateDir}/config.json" ]; then
            cp "${cfg.stateDir}/config.json" /run/alist/old
            ${lib.getExe pkgs.jq} -s '.[0] * .[1]' /run/alist/old /run/alist/new > /run/alist/result
            mv /run/alist/result /run/alist/new
            rm -f /run/alist/old
          fi
        ''
        + ''
          mv /run/alist/new "${cfg.stateDir}/config.json"
        ''
        + lib.optionalString ((cfg.settings.scheme.cert_file or null) != null) ''
          export ALIST_CERT_FILE="''${CREDENTIALS_DIRECTORY}/tls-cert"
        ''
        + lib.optionalString ((cfg.settings.scheme.key_file or null) != null) ''
          export ALIST_KEY_FILE="''${CREDENTIALS_DIRECTORY}/tls-key"
        '';
      serviceConfig =
        let
          needPerm =
            (cfg.settings.scheme.http_port != -1 && cfg.settings.scheme.http_port < 1024)
            || (cfg.settings.scheme.https_port != -1 && cfg.settings.scheme.https_port < 1024);
        in
        {
          ExecStart =
            "${lib.getExe cfg.package} server --log-std "
            + lib.escapeShellArgs (
              [
                "--data"
                cfg.stateDir
              ]
              ++ lib.optional cfg.debug "--debug"
              ++ cfg.extraFlags
            );
          Type = "simple";
          User = if cfg.user == null then "alist" else cfg.user;
          Group = if cfg.group == null then "alist" else cfg.group;
          Restart = "on-failure";
          RestartSec = "10s";
          StateDirectory = "alist";
          RuntimeDirectory = "alist";
          WorkingDirectory = cfg.stateDir;
          LoadCredential =
            lib.optional (
              (cfg.settings.scheme.cert_file or null) != null
            ) "tls-cert:${cfg.settings.scheme.cert_file}"
            ++ lib.optional (
              (cfg.settings.scheme.key_file or null) != null
            ) "tls-key:${cfg.settings.scheme.key_file}";

          # Hardening
          PrivateTmp = true;
          PrivateUsers = !needPerm; # incompatible with CAP_NET_BIND_SERVICE
          NoNewPrivileges = true;
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
          AmbientCapabilities = lib.optional needPerm "CAP_NET_BIND_SERVICE";
          CapabilityBoundingSet = lib.optional needPerm "CAP_NET_BIND_SERVICE";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
        };
    };
  };
}
