{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.inventree;
  pkg = cfg.package;

  mysqlLocal = cfg.database.createLocally && cfg.database.dbtype == "mysql";
  pgsqlLocal = cfg.database.createLocally && cfg.database.dbtype == "postgresql";

  manage = pkgs.writeShellScriptBin "inventree-manage" ''
    set -a
    ${lib.toShellVars cfg.settings}
    ${lib.concatMapStringsSep "\n" (file: ". ${file}") cfg.settingsFiles}
    ${lib.optionalString (
      cfg.database.passwordFile != null
    ) ''INVENTREE_DB_PASSWORD="$(<"${cfg.database.passwordFile}")"''}
    set +a

    pushd "${cfg.dataDir}" &>/dev/null
    sudo=exec
    if [[ "$USER" != ${cfg.user} ]]; then
      ${
        if config.security.sudo.enable then
          "sudo='exec ${config.security.wrapperDir}/sudo -u ${cfg.user} -E'"
        else
          ">&2 echo 'Aborting, inventree-manage must be run as user `${cfg.user}`!'; exit 2"
      }
    fi
    $sudo ${cfg.package}/bin/inventree "$@"
    popd &>/dev/null
  '';

in
{
  meta.buildDocsInSandbox = false;
  meta.maintainers = with lib.maintainers; [
    kurogeek
  ];

  options.services.inventree = with lib; {
    enable = lib.mkEnableOption "inventree";

    dataDir = mkOption {
      type = types.str;
      default = "/var/lib/inventree";
      description = "Inventree's data storage path.  Will be `/var/lib/inventree` by default.";
    };

    package = mkOption {
      type = types.package;
      description = "Which package to use for the InvenTree instance.";
      default = pkgs.inventree;
      defaultText = literalExpression "pkgs.inventree";
    };

    adminPasswordFile = mkOption {
      type = types.nullOr lib.types.path;
      default = null;
      example = "/run/keys/inventree-password";
      description = "Path to a file containing admin password";
    };

    secretKeyFile = mkOption {
      type = types.path;
      default = "${cfg.dataDir}/secret_key.txt";
      defaultText = lib.literalExpression ''"''${cfg.dataDir}/secret_key.txt"'';
      example = "/run/keys/inventree-secret-key";
      description = ''
        Path to a file containing the secret key
      '';
    };

    database = {
      dbtype = mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "postgresql"
            "mysql"
          ]
        );
        default = "postgresql";
        description = "Database type.";
      };
      dbhost = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default =
          if pgsqlLocal then
            "/run/postgresql"
          else if mysqlLocal then
            "/run/mysqld/mysqld.sock"
          else
            "localhost";
        defaultText = "localhost";
        example = "localhost";
        description = ''
          Database host or socket path.
          If [](#opt-services.inventree.database.createLocally) is true and
          [](#opt-services.inventree.database.dbtype) is either `postgresql` or `mysql`,
          defaults to the correct Unix socket instead.
        '';
      };
      dbport = mkOption {
        type = types.port;
        default = 5432;
        description = "Database host port.";
      };
      dbname = mkOption {
        type = types.str;
        default = "inventree";
        description = "Database name.";
      };
      dbuser = mkOption {
        type = types.str;
        default = "inventree";
        description = "Database username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/inventree-dbpassword";
        description = ''
          A file containing the password corresponding to
          <option>database.dbuser</option>.
        '';
      };
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Create the database and database user locally.";
      };
    };

    domain = mkOption {
      type = types.str;
      default = "localhost";
      example = "inventree.example.com";
      description = ''
        The INVENTREE_SITE_URL option defines the base URL for the
        InvenTree server. This is a critical setting, and it is required
        for correct operation of the server. If not specified, the
        server will attempt to determine the site URL automatically -
        but this may not always be correct!

        The site URL is the URL that users will use to access the
        InvenTree server. For example, if the server is accessible at
        `https://inventree.example.com`, the site URL should be set to
        `https://inventree.example.com`. Note that this is not
        necessarily the same as the internal URL that the server is
        running on - the internal URL will depend entirely on your
        server configuration and may be obscured by a reverse proxy or
        other such setup.
      '';
    };

    user = mkOption {
      type = types.str;
      default = "inventree";
      description = "User under which InvenTree runs.";
    };

    group = mkOption {
      type = types.str;
      default = "inventree";
      description = "Group under which InvenTree runs.";
    };

    settings = mkOption {
      type =
        with lib.types;
        attrsOf (
          nullOr (oneOf [
            path
            str
          ])
        );
      default = { };
      description = ''
        InvenTree config options.

        See [the documentation](https://docs.inventree.org/en/stable/start/config/) for available options.
      '';
      example = {
        INVENTREE_CACHE_ENABLED = true;
        INVENTREE_CACHE_HOST = "localhost";

        INVENTREE_EMAIL_HOST = "smtp.example.com";
        INVENTREE_EMAIL_PORT = 25;
      };
    };

    settingsFiles = mkOption {
      description = "Additional environment files to load into all services";
      type = lib.types.listOf lib.types.path;
      default = [ ];
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        services.inventree.settings = {
          INVENTREE_DB_ENGINE = cfg.database.dbtype;
          INVENTREE_DB_NAME = cfg.database.dbname;
          INVENTREE_DB_HOST = cfg.database.dbhost;
          INVENTREE_DB_USER = cfg.database.dbuser;
          INVENTREE_DB_PORT = toString cfg.database.dbport;

          INVENTREE_CONFIG_FILE = lib.mkDefault "${cfg.dataDir}/config/config.yaml";
          INVENTREE_OIDC_PRIVATE_KEY_FILE = lib.mkDefault "${cfg.dataDir}/config/oidc_private_key.txt";
          INVENTREE_STATIC_ROOT = lib.mkDefault "${cfg.package}/lib/inventree/static";
          INVENTREE_MEDIA_ROOT = lib.mkDefault "${cfg.dataDir}/data/media";
          INVENTREE_BACKUP_DIR = lib.mkDefault "${cfg.dataDir}/data/backups";
          INVENTREE_SITE_URL = lib.mkDefault "http://${cfg.domain}";
          INVENTREE_PLUGIN_FILE = lib.mkDefault "${cfg.dataDir}/data/plugins/plugins.txt";
          INVENTREE_PLUGIN_DIR = lib.mkDefault "${cfg.dataDir}/data/plugins";
          INVENTREE_ADMIN_PASSWORD_FILE = lib.mkDefault cfg.adminPasswordFile;
          INVENTREE_SECRET_KEY_FILE = lib.mkDefault cfg.secretKeyFile;
          INVENTREE_AUTO_UPDATE = lib.mkDefault "false";
        };
        environment.systemPackages = [ manage ];
        systemd.tmpfiles.rules = (
          map (dir: "d ${dir} 0755 inventree inventree") [
            "${cfg.dataDir}"
            "${cfg.dataDir}/config"
            "${cfg.dataDir}/data"
            "${cfg.dataDir}/data/media"
            "${cfg.dataDir}/data/backups"
            "${cfg.dataDir}/data/plugins"
          ]
        );

        services.postgresql = lib.mkIf pgsqlLocal {
          enable = true;
          ensureDatabases = [ cfg.database.dbname ];
          ensureUsers = [
            {
              name = cfg.database.dbuser;
              ensureDBOwnership = true;
            }
          ];
        };

        services.mysql = lib.mkIf mysqlLocal {
          enable = true;
          package = lib.mkDefault pkgs.mariadb;
          ensureDatabases = [ cfg.database.dbname ];
          ensureUsers = [
            {
              name = cfg.database.dbuser;
              ensurePermissions = {
                "${cfg.database.dbname}.*" = "ALL PRIVILEGES";
              };
            }
          ];
        };

        services.nginx.enable = true;
        services.nginx.virtualHosts.${cfg.domain} = {
          locations =
            let
              unixPath = config.systemd.sockets.inventree-server.socketConfig.ListenStream;
            in
            {
              "/" = {
                recommendedProxySettings = true;
                extraConfig = ''
                  proxy_pass_request_headers on;

                  proxy_redirect off;

                  client_max_body_size 0;

                  proxy_buffering off;
                  proxy_request_buffering off;
                '';
                proxyPass = "http://unix:${unixPath}";
              };
              "/auth" = {
                extraConfig = ''
                  internal;
                  proxy_pass_request_body off;
                  proxy_set_header Content-Length "";
                  proxy_set_header X-Original-URI $request_uri;
                '';
                proxyPass = "http://unix:${unixPath}:/auth/";
              };
              "/static/" = {
                alias = "${cfg.settings.INVENTREE_STATIC_ROOT}/";
                extraConfig = ''
                  autoindex on;

                  # Caching settings
                  expires 30d;
                  add_header Pragma public;
                  add_header Cache-Control "public";
                '';
              };
              "/media/" = {
                alias = "${cfg.settings.INVENTREE_MEDIA_ROOT}/";
                extraConfig = ''
                  auth_request /auth;
                  add_header Content-disposition "attachment";
                '';
              };
            };
        };

        systemd.services.inventree-setup = {
          description = "Inventree setup";
          wantedBy = [ "inventree.target" ];
          partOf = [ "inventree.target" ];
          after = lib.optional mysqlLocal "mysql.service" ++ lib.optional pgsqlLocal "postgresql.target";
          requires = lib.optional mysqlLocal "mysql.service" ++ lib.optional pgsqlLocal "postgresql.target";
          before = [
            "inventree-server.service"
            "inventree-qcluster.service"
          ];
          serviceConfig = {
            Type = "oneshot";
            User = cfg.user;
            Group = cfg.group;
            RemainAfterExit = true;
            PrivateTmp = true;
            UMask = "0077";
            EnvironmentFile = cfg.settingsFiles;
          }
          // lib.optionalAttrs (cfg.database.passwordFile != null) {
            LoadCredential = "db_password:${cfg.database.passwordFile}";
          };
          environment = cfg.settings;
          script = ''
            set -euo pipefail

            ${lib.optionalString (cfg.database.passwordFile != null) ''
              export INVENTREE_DB_PASSWORD="$(<"$CREDENTIALS_DIRECTORY/db_password")"
            ''}
            ${pkg}/bin/inventree migrate
          '';
        };

        systemd.services.inventree-server = {
          description = "Inventree Gunicorn service";
          requiredBy = [ "inventree.target" ];
          partOf = [ "inventree.target" ];
          environment = cfg.settings;
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = "inventree";
            PrivateTmp = true;
            EnvironmentFile = cfg.settingsFiles;
          }
          // lib.optionalAttrs (cfg.database.passwordFile != null) {
            LoadCredential = "db_password:${cfg.database.passwordFile}";
          };
          script = ''
            ${lib.optionalString (cfg.database.passwordFile != null) ''
              export INVENTREE_DB_PASSWORD="$(<"$CREDENTIALS_DIRECTORY/db_password")"
            ''}
            exec ${pkg}/bin/gunicorn InvenTree.wsgi
          '';
        };

        systemd.sockets.inventree-server = {
          wantedBy = [ "sockets.target" ];
          partOf = [ "inventree.target" ];
          socketConfig.ListenStream = "/run/inventree/gunicorn.socket";
        };

        systemd.services.inventree-qcluster = {
          description = "InvenTree qcluster server";
          requiredBy = [ "inventree.target" ];
          wantedBy = [ "inventree.target" ];
          partOf = [ "inventree.target" ];
          environment = cfg.settings;
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = "inventree";
            PrivateTmp = true;
            EnvironmentFile = cfg.settingsFiles;
          }
          // lib.optionalAttrs (cfg.database.passwordFile != null) {
            LoadCredential = "db_password:${cfg.database.passwordFile}";
          };
          script = ''
            ${lib.optionalString (cfg.database.passwordFile != null) ''
              export INVENTREE_DB_PASSWORD="$(<"$CREDENTIALS_DIRECTORY/db_password")"
            ''}
            exec ${pkg}/bin/inventree qcluster
          '';
        };

        systemd.targets.inventree = {
          description = "Target for all InvenTree services";
          wantedBy = [ "multi-user.target" ];
          wants = [ "network-online.target" ];
          after = [ "network-online.target" ];
        };

        users = lib.optionalAttrs (cfg.user == cfg.user) {
          users.${cfg.user} = {
            group = cfg.group;
            isSystemUser = true;
            home = cfg.dataDir;
          };
          groups.${cfg.group}.members = [ cfg.user ];
        };
      }
    ]
  );
}
