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

  dbPass = {
    arg = "INVENTREE_DB_PASSWORD";
    value =
      if cfg.database.passwordFile != null then ''"$(<"${cfg.database.passwordFile}")"'' else ''""'';
  };

  mkExport =
    { arg, value }:
    ''
      ${arg}=${value};
      export ${arg};
    '';

  env = {
    INVENTREE_DB_ENGINE = cfg.database.dbtype;
    INVENTREE_DB_NAME = cfg.database.dbname;
    INVENTREE_DB_HOST = cfg.database.dbhost;
    INVENTREE_DB_USER = cfg.database.dbuser;
    INVENTREE_DB_PORT = builtins.toString cfg.database.dbport;

    INVENTREE_CONFIG_FILE = lib.mkDefault "${cfg.dataDir}/config/config.yaml";
    INVENTREE_OIDC_PRIVATE_KEY_FILE = lib.mkDefault "${cfg.dataDir}/config/oidc_private_key.txt";
    INVENTREE_STATIC_ROOT = lib.mkDefault "${cfg.dataDir}/data/static_root";
    INVENTREE_MEDIA_ROOT = lib.mkDefault "${cfg.dataDir}/data/media";
    INVENTREE_BACKUP_DIR = lib.mkDefault "${cfg.dataDir}/data/backups";
    INVENTREE_SITE_URL = lib.mkDefault "${cfg.domain}";
    INVENTREE_PLUGIN_FILE = lib.mkDefault "${cfg.dataDir}/data/plugins/plugins.txt";
    INVENTREE_PLUGIN_DIR = lib.mkDefault "${cfg.dataDir}/data/plugins";
    INVENTREE_ADMIN_PASSWORD_FILE = lib.mkDefault cfg.adminPasswordFile;
    INVENTREE_SECRET_KEY_FILE = lib.mkDefault cfg.secretKeyFile;
    INVENTREE_AUTO_UPDATE = lib.mkDefault "false";

    PYTHONPATH = pkg.pythonPath;
  }
  // cfg.settings;

  manage = pkgs.writeShellScriptBin "inventree-manage" ''
    set -a
    ${lib.toShellVars env}
    ${mkExport dbPass}
    set +a

    pushd "${cfg.dataDir}"
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
    popd
  '';

in
{
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
      description = ''Path to a file containing admin password'';
    };

    secretKeyFile = mkOption {
      type = types.path;
      default = "${cfg.dataDir}/secret_key.txt";
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
        defaultText = lib.literalExpression "inventree";
        description = "Database username.";
      };
      passwordFile = mkOption {
        type = with types; nullOr path;
        default = null;
        example = "/run/keys/inventree-dbpassword";
        description = ''
          A file containing the password corresponding to
          <option>database.user</option>.
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
      description = mdDoc ''
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
      default = {
        INVENTREE_CONFIG_FILE = "${cfg.dataDir}/config/config.yaml";
        INVENTREE_SECRET_KEY_FILE = "${cfg.dataDir}/config/secret_key.txt";
        INVENTREE_OIDC_PRIVATE_KEY_FILE = "${cfg.dataDir}/config/oidc_private_key.txt";
        INVENTREE_STATIC_ROOT = "${cfg.dataDir}/data/static_root";
        INVENTREE_MEDIA_ROOT = "${cfg.dataDir}/data/media";
        INVENTREE_BACKUP_DIR = "${cfg.dataDir}/data/backups";
        INVENTREE_SITE_URL = "http://${cfg.domain}";
        INVENTREE_PLUGIN_FILE = "${cfg.dataDir}/data/plugins";
      };
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

  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        environment.systemPackages = [ manage ];
        systemd.tmpfiles.rules = (
          map (dir: "d ${dir} 0750 inventree inventree") [
            "${cfg.dataDir}"
            "${cfg.dataDir}/config"
            "${cfg.dataDir}/data"
            "${cfg.dataDir}/data/static_root"
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
                extraConfig = ''
                  client_max_body_size 100M;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                '';
                proxyPass = "http://unix:${unixPath}";
              };
              "/auth" = {
                extraConfig = ''
                  internal;
                '';
                proxyPass = "http://unix:${unixPath}:/auth/";
              };
              "/static/" = {
                alias = "${env.INVENTREE_STATIC_ROOT}";
                extraConfig = ''
                  expires 30d;
                '';
              };
              "/media/" = {
                alias = "${env.INVENTREE_MEDIA_ROOT}";
                extraConfig = ''
                  auth_request /auth;
                '';
              };
            };
        };

        systemd.services.inventree-secrets-setup = {
          description = "Inventree secrets setup";
          wantedBy = [ "inventree-setup.service" ];
          partOf = [ "inventree.target" ];
          before = [ "inventree-setup.service" ];
          serviceConfig = {
            Type = "oneshot";
            User = cfg.user;
            Group = cfg.group;
            RemainAfterExit = true;
            PrivateTmp = true;
          };
          script = ''
            ${mkExport dbPass}

            echo "INVENTREE_DB_PASSWORD=$INVENTREE_DB_PASSWORD" > ${cfg.dataDir}/config/.env
          '';
        };

        systemd.services.inventree-setup = {
          description = "Inventree setup";
          wantedBy = [ "inventree.target" ];
          partOf = [ "inventree.target" ];
          after = lib.optional mysqlLocal "mysql.service" ++ lib.optional pgsqlLocal "postgresql.target";
          requires = lib.optional mysqlLocal "mysql.service" ++ lib.optional pgsqlLocal "postgresql.target";
          before = [
            "inventree-static.service"
            "inventree-server.service"
            "inventree-qcluster.service"
          ];
          serviceConfig = {
            Type = "oneshot";
            User = cfg.user;
            Group = cfg.group;
            RemainAfterExit = true;
            PrivateTmp = true;
            EnvironmentFile = [ "${cfg.dataDir}/config/.env" ];
          };
          environment = env;
          script = ''
            set -euo pipefail
            umask u=rwx,g=,o=

            ${pkg}/bin/inventree migrate
          '';
        };

        systemd.services.inventree-static = {
          description = "Inventree static migration";
          wantedBy = [ "inventree.target" ];
          partOf = [ "inventree.target" ];
          before = [ "inventree-server.service" ];
          environment = env;
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = "inventree";
            PrivateTmp = true;
            ExecStart = ''
              ${pkg}/bin/inventree collectstatic  --no-input
            '';
            EnvironmentFile = [ "${cfg.dataDir}/config/.env" ];
          };
        };

        systemd.services.inventree-server = {
          description = "Inventree Gunicorn service";
          requiredBy = [ "inventree.target" ];
          partOf = [ "inventree.target" ];
          environment = env;
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = "inventree";
            PrivateTmp = true;
            ExecStart = ''
              ${pkg}/bin/gunicorn InvenTree.wsgi
            '';
            EnvironmentFile = [ "${cfg.dataDir}/config/.env" ];
          };
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
          environment = env;
          serviceConfig = {
            User = cfg.user;
            Group = cfg.group;
            StateDirectory = "inventree";
            PrivateTmp = true;
            ExecStart = ''
              ${pkg}/bin/inventree qcluster
            '';
            EnvironmentFile = [ "${cfg.dataDir}/config/.env" ];
          };
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
      {
        assertions = [
          {
            assertion = !(cfg.settings ? INVENTREE_DB_ENGINE);
            message = ''Using `services.settings.INVENTREE_DB_ENGINE is not supported due to conflict with `services.database.dbtype`. Please consider using `services.database` for database configuration.'';
          }
          {
            assertion = !(cfg.settings ? INVENTREE_DB_NAME);
            message = ''Using `services.settings.INVENTREE_DB_NAME` is not supported due to conflict with `services.database.dbname`. Please consider using `services.database` for database configuration.'';
          }
          {
            assertion = !(cfg.settings ? INVENTREE_DB_HOST);
            message = ''Using `services.settings.INVENTREE_DB_HOST` is not supported due to conflict with `services.database.dbhost`. Please consider using `services.database` for database configuration.'';
          }
          {
            assertion = !(cfg.settings ? INVENTREE_DB_PORT);
            message = ''Using `services.settings.INVENTREE_DB_PORT is not supported due to conflict with `services.database.dbport`. Please consider using `services.database` for database configuration.'';
          }
          {
            assertion = !(cfg.settings ? INVENTREE_DB_USER);
            message = ''Using `services.settings.INVENTREE_DB_USER` is not supported due to conflict with `services.database.dbuser`. Please consider using `services.database` for database configuration.'';
          }
        ];
      }
    ]
  );
}
