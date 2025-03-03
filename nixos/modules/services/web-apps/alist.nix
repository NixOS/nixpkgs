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

      package = lib.mkPackageOption pkgs "alist" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            jwt_secret = lib.mkOption {
              type = lib.types.attrsOf lib.types.path;
              example = {
                _secret = "/run/agenix/alist-jwt";
              };
              description = ''
                The secret used to sign the JWT token, should be a random string.
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
                  Database type, available options are `sqlite3`, `mysql` and `postgres`.
                '';
              };
              host = lib.mkOption {
                type = lib.types.str;
                default = "127.0.0.1";
                description = "Database host.";
              };
              port = lib.mkOption {
                type = lib.types.port;
                default = 3306;
                description = "Database port.";
              };
              user = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "root";
                description = "Database user name.";
              };
              password = lib.mkOption {
                type = lib.types.nullOr (lib.types.attrsOf lib.types.path);
                default = null;
                example = {
                  _secret = "/run/agenix/alist-db-password";
                };
                description = "Database password.";
              };
              name = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                example = "alist";
                description = "Database name.";
              };
              db_file = lib.mkOption {
                type = lib.types.str;
                default = "/var/lib/alist/data.db";
                description = "Database location, used by sqlite3.";
              };
              table_prefix = lib.mkOption {
                type = lib.types.str;
                default = "alist_";
                description = "Database table name prefix.";
              };
              ssl_mode = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = ''
                  To control the encryption options during the SSL handshake.
                '';
              };
              dsn = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = ''
                  Use this option to configure a more flexible database connection such as `unix`.

                  The format needs to match the following:
                  `[username[:password]@][protocol[(address)]]/dbname[?param1=value1&...&paramN=valueN]`
                '';
              };
            };
            scheme = {
              address = lib.mkOption {
                type = lib.types.str;
                default = "[::1]";
                description = ''
                  The http/https address to listen on.
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
              cert_file = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Path of cert file.";
              };
              key_file = lib.mkOption {
                type = lib.types.nullOr lib.types.str;
                default = null;
                description = "Path of key file.";
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
                  Unix socket file permission, set to the appropriate permissions.
                '';
              };
            };
            temp_dir = lib.mkOption {
              type = lib.types.str;
              default = "/tmp";
              description = ''
                The directory to keep temporary files exclusive to alist.
                In order to prevent AList from generating garbage files when being interrupted,
                the directory will be cleared every time AList starts, so do not store anything in this directory.
              '';
            };
          };
        };
        default = { };
        description = ''
          The alist configuration, see https://alist.nn.ci/config/configuration.html
          for possible options.

          Options containing secret data should be set to an attribute set
          containing the attribute `_secret` - a string pointing to a file
          containing the value the option should be set to.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # Let Alist read tls-related configurations from environment variables
    services.alist.settings.force = false;

    # Alist may store files in local paths, so make the alist user permanent.
    users.users.alist = lib.mkIf (cfg.user == null) {
      description = "Alist user";
      isSystemUser = true;
      group = lib.optionalString (cfg.group == null) "alist";
    };
    users.groups.alist = lib.mkIf (cfg.group == null) { };

    systemd.services.alist = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      # If mutableConfig is true, overwrite the contents of cfg.settings to the existing configuration
      script = ''
        ${utils.genJqSecretsReplacementSnippet cfg.settings "/run/alist/new"}

        ${lib.optionalString cfg.mutableConfig ''
          [ -e "${cfg.stateDir}/config.json" ] && cp "${cfg.stateDir}/config.json" /run/alist/old && \
          ${lib.getExe pkgs.jq} -s '.[0] * .[1]' /run/alist/old /run/alist/new > /run/alist/result && \
          mv /run/alist/result /run/alist/new && \
          rm -f /run/alist/old
        ''}

        mv /run/alist/new "${cfg.stateDir}/config.json"

        ${lib.optionalString (cfg.settings.scheme.cert_file != null) ''
          export ALIST_CERT_FILE="''${CREDENTIALS_DIRECTORY}/tls-cert"
        ''}
        ${lib.optionalString (cfg.settings.scheme.key_file != null) ''
          export ALIST_KEY_FILE="''${CREDENTIALS_DIRECTORY}/tls-key"
        ''}
        ${lib.getExe cfg.package} server --data ${cfg.stateDir} --log-std ${lib.optionalString cfg.debug " --debug"}
      '';
      serviceConfig =
        let
          needPerm =
            (cfg.settings.scheme.http_port != -1 && cfg.settings.scheme.http_port < 1024)
            || (cfg.settings.scheme.https_port != -1 && cfg.settings.scheme.https_port < 1024);
        in
        {
          Type = "simple";
          User = if cfg.user == null then "alist" else cfg.user;
          Group = if cfg.group == null then "alist" else cfg.group;
          Restart = "on-failure";
          RestartSec = "3s";
          StateDirectory = "alist";
          RuntimeDirectory = "alist";
          WorkingDirectory = cfg.stateDir;
          LoadCredential =
            lib.optional (cfg.settings.scheme.cert_file != null) "tls-cert:${cfg.settings.scheme.cert_file}"
            ++ lib.optional (cfg.settings.scheme.key_file != null) "tls-key:${cfg.settings.scheme.key_file}";

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
          AmbientCapabilities = lib.optionalString needPerm "CAP_NET_BIND_SERVICE";
          CapabilityBoundingSet = lib.optionalString needPerm "CAP_NET_BIND_SERVICE";
          SystemCallFilter = [
            "@system-service"
            "~@privileged"
          ];
        };
    };
  };
}
