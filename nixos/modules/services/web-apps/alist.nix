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

      stateDir = lib.mkOption {
        type = lib.types.str;
        default = "/var/lib/alist";
        description = "Alist stores data and config file in this directory.";
      };

      allowModify = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Allow Alist to persist settings in the config file";
      };

      package = lib.mkPackageOption pkgs "alist" { };

      settings = lib.mkOption {
        type = lib.types.submodule {
          freeformType = settingsFormat.type;
          options = {
            force = lib.mkOption {
              type = lib.types.bool;
              default = true;
              description = ''
                By default AList reads the configuration from environment variables, set this field to true to force AList to read config from the configuration file.
              '';
            };
            site_url = lib.mkOption {
              type = lib.types.str;
              default = "";
              description = ''
                The address of your AList server, such as https://pan.nn.ci. This address is essential for some features, and thus thry may not work properly if unset:
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
                The address of the CDN. Included `$version` values will be dynamically replaced by the version of AList. Existing dist resources are hosted on both npm and GitHub, which can be found at:

                - https://www.npmjs.com/package/alist-web
                - https://github.com/alist-org/web-dist
                Thus it is possible to use any npm or GitHub CDN path for this field. For example:

                - https://registry.npmmirror.com/alist-web/$version/files/dist/
                - https://cdn.jsdelivr.net/npm/alist-web@$version/dist/
                - https://unpkg.com/alist-web@$version/dist/

                Keep empty to use local dist resources.
              '';
            };
            jwt_secret = lib.mkOption {
              type = lib.types.attrsOf lib.types.path;
              example = lib.literalExpression ''
                {
                  _secret = "/run/agenix/alist-jwt";
                };
              '';
              description = ''
                The secret used to sign the JWT token, should be a random string
              '';
            };
            token_expires_in = lib.mkOption {
              type = lib.types.int;
              default = 48;
              description = ''
                User login expiration time, in hours.
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
                default = "";
                example = "127.0.0.1";
                description = "database host";
              };
              port = lib.mkOption {
                type = lib.types.port;
                default = 0;
                example = 3306;
                description = "database port";
              };
              user = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = "root";
                description = "database account";
              };
              password = lib.mkOption {
                type = lib.types.oneOf [
                  lib.types.str
                  (lib.types.attrsOf lib.types.path)
                ];
                default = "";
                example = lib.literalExpression ''
                  {
                    _secret = /run/agenix/alist-db-password;
                  };
                '';
                description = "database password";
              };
              name = lib.mkOption {
                type = lib.types.str;
                default = "";
                example = "alist";
                description = "database name";
              };
              db_file = lib.mkOption {
                type = lib.types.str;
                default = "/var/lib/alist/data.db";
                description = "Database location, used by sqlite3";
              };
              table_prefix = lib.mkOption {
                type = lib.types.str;
                default = "alist_";
                description = "database table name prefix";
              };
              ssl_mode = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = ''
                  To control the encryption options during the SSL handshake, the parameters can be searched by themselves, or check the answer from ChatGPT on https://alist.nn.ci/config/configuration.html#database
                '';
              };
              dsn = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = ''
                  see https://github.com/alist-org/alist/pull/6031
                '';
              };
            };
            scheme = {
              address = lib.mkOption {
                type = lib.types.str;
                default = "0.0.0.0";
                description = ''
                  The http/https address to listen on, default `0.0.0.0`
                '';
              };
              http_port = lib.mkOption {
                type = lib.types.oneOf [
                  (lib.types.enum [ (-1) ])
                  lib.types.port
                ];
                default = 5244;
                description = ''
                  The http port to listen on, default `5244`, if you want to disable http, set it to `-1`
                '';
              };
              https_port = lib.mkOption {
                type = lib.types.oneOf [
                  (lib.types.enum [ (-1) ])
                  lib.types.port
                ];
                default = (-1);
                description = ''
                  The https port to listen on, default `-1`, if you want to enable https, set it to non `-1`
                '';
              };
              force_https = lib.mkOption {
                type = lib.types.bool;
                default = false;
                description = ''
                  Whether HTTPS protocol is forced, if true the user can only access the website through HTTPS.
                '';
              };
              cert_file = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Path of cert file";
              };
              key_file = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = "Path of key file";
              };
              unix_file = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = ''
                  Unix socket file path to listen on, default empty, if you want to use unix socket, set it to non empty
                '';
              };
              unix_file_perm = lib.mkOption {
                type = lib.types.str;
                default = "";
                description = ''
                  Unix socket file permission, set to the appropriate permissions
                '';
              };
            };
            temp_dir = lib.mkOption {
              type = lib.types.str;
              default = "/tmp";
              description = ''
                The directory to keep temporary files.
                temp_dir is a temporary folder exclusive to alist. In order to prevent AList from generating garbage files when being interrupted, the directory will be cleared every time AList starts, so do not store anything in this directory.
              '';
            };
          };
        };
        default = { };
        description = ''
          The alist configuration, see https://alist.nn.ci/config/configuration.html for documentation.

          Options containing secret data should be set to an attribute set containing the attribute `_secret` - a string pointing to a file containing the value the option should be set to.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    systemd.services.alist = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      preStart =
        ''
          ${utils.genJqSecretsReplacementSnippet cfg.settings "/run/alist/new"}
        ''
        + (
          if cfg.allowModify then
            ''
              if [ -e "${cfg.stateDir}/config.json" ]; then
                cp "${cfg.stateDir}/config.json" /run/alist/old
                ${lib.getExe pkgs.jq} -s '.[0] * .[1]' /run/alist/old /run/alist/new > /run/alist/result
                cp /run/alist/result "${cfg.stateDir}/config.json"
              else
                cp "/run/alist/new" "${cfg.stateDir}/config.json"
              fi
              rm -f /run/alist/{old,new,result}
            ''
          else
            ''
              cp /run/alist/new "${cfg.stateDir}/config.json"
              rm -f /run/alist/new
            ''
        );
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${lib.getExe cfg.package} server --data ${cfg.stateDir} --log-std"
          + lib.optionalString cfg.debug " --debug";
        Restart = "on-failure";
        RestartSec = "1s";
        StateDirectory = "alist";
        RuntimeDirectory = "alist";
        PrivateTmp = true;
        WorkingDirectory = cfg.stateDir;
        DynamicUser = true;
        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
        UMask = "0077";
      };
    };
  };
}
