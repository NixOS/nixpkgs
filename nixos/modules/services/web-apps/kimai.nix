{
  config,
  pkgs,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.kimai;
  eachSite = cfg.sites;
  user = "kimai";
  webserver = config.services.${cfg.webserver};
  stateDir = hostName: "/var/lib/kimai/${hostName}";

  pkg =
    hostName: cfg:
    pkgs.stdenv.mkDerivation rec {
      pname = "kimai-${hostName}";
      src = cfg.package;
      version = src.version;

      installPhase = ''
        mkdir -p $out
        cp -r * $out/

        # Symlink .env file. This will be dynamically created at the service
        # startup.
        ln -sf ${stateDir hostName}/.env $out/share/php/kimai/.env

        # Symlink the var/ folder
        # TODO: we may have to symlink individual folders if we want to also
        # manage plugins from Nix.
        rm -rf $out/share/php/kimai/var
        ln -s ${stateDir hostName} $out/share/php/kimai/var

        # Symlink local.yaml.
        ln -s ${kimaiConfig hostName cfg} $out/share/php/kimai/config/packages/local.yaml
      '';
    };

  kimaiConfig =
    hostName: cfg:
    pkgs.writeTextFile {
      name = "kimai-config-${hostName}.yaml";
      text = generators.toYAML { } cfg.settings;
    };

  siteOpts =
    {
      lib,
      name,
      config,
      ...
    }:
    {
      options = {
        package = mkPackageOption pkgs "kimai" { };

        database = {
          host = mkOption {
            type = types.str;
            default = "localhost";
            description = "Database host address.";
          };

          port = mkOption {
            type = types.port;
            default = 3306;
            description = "Database host port.";
          };

          name = mkOption {
            type = types.str;
            default = "kimai";
            description = "Database name.";
          };

          user = mkOption {
            type = types.str;
            default = "kimai";
            description = "Database user.";
          };

          passwordFile = mkOption {
            type = types.nullOr types.path;
            default = null;
            example = "/run/keys/kimai-dbpassword";
            description = ''
              A file containing the password corresponding to
              {option}`database.user`.
            '';
          };

          socket = mkOption {
            type = types.nullOr types.path;
            default = null;
            defaultText = literalExpression "/run/mysqld/mysqld.sock";
            description = "Path to the unix socket file to use for authentication.";
          };

          charset = mkOption {
            type = types.str;
            default = "utf8mb4";
            description = "Database charset.";
          };

          serverVersion = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = ''
              MySQL *exact* version string. Not used if `createdLocally` is set,
              but must be set otherwise. See
              https://www.kimai.org/documentation/installation.html#column-table_name-in-where-clause-is-ambiguous
              for how to set this value, especially if you're using MariaDB.
            '';
          };

          createLocally = mkOption {
            type = types.bool;
            default = true;
            description = "Create the database and database user locally.";
          };
        };

        poolConfig = mkOption {
          type =
            with types;
            attrsOf (oneOf [
              str
              int
              bool
            ]);
          default = {
            "pm" = "dynamic";
            "pm.max_children" = 32;
            "pm.start_servers" = 2;
            "pm.min_spare_servers" = 2;
            "pm.max_spare_servers" = 4;
            "pm.max_requests" = 500;
          };
          description = ''
            Options for the Kimai PHP pool. See the documentation on `php-fpm.conf`
            for details on configuration directives.
          '';
        };

        settings = mkOption {
          type = types.attrsOf types.anything;
          default = { };
          description = ''
            Structural Kimai's local.yaml configuration.
            Refer to <https://www.kimai.org/documentation/local-yaml.html#localyaml>
            for details.
          '';
          example = literalExpression ''
            {
              kimai = {
                timesheet = {
                  rounding = {
                    default = {
                      begin = 15;
                      end = 15;
                    };
                  };
                };
              };
            }
          '';
        };

        environmentFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/secrets/kimai.env";
          description = ''
            Securely pass environment variabels to Kimai. This can be used to
            set other environement variables such as MAILER_URL.
          '';
        };
      };
    };
in
{
  # interface
  options = {
    services.kimai = {
      sites = mkOption {
        type = types.attrsOf (types.submodule siteOpts);
        default = { };
        description = "Specification of one or more Kimai sites to serve";
      };

      webserver = mkOption {
        type = types.enum [ "nginx" ];
        default = "nginx";
        description = ''
          The webserver to configure for the PHP frontend.

          At the moment, only `nginx` is supported. PRs are welcome for support
          for other web servers.
        '';
      };
    };
  };

  # implementation
  config = mkIf (eachSite != { }) (mkMerge [
    {

      assertions =
        (mapAttrsToList (hostName: cfg: {
          assertion = cfg.database.createLocally -> cfg.database.user == user;
          message = ''services.kimai.sites."${hostName}".database.user must be ${user} if the database is to be automatically provisioned'';
        }) eachSite)
        ++ (mapAttrsToList (hostName: cfg: {
          assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
          message = ''services.kimai.sites."${hostName}".database.passwordFile cannot be specified if services.kimai.sites."${hostName}".database.createLocally is set to true.'';
        }) eachSite)
        ++ (mapAttrsToList (hostName: cfg: {
          assertion = !cfg.database.createLocally -> cfg.database.serverVersion != null;
          message = ''services.kimai.sites."${hostName}".database.serverVersion must be specified if services.kimai.sites."${hostName}".database.createLocally is set to false.'';
        }) eachSite);

      services.mysql = mkIf (any (v: v.database.createLocally) (attrValues eachSite)) {
        enable = true;
        package = mkDefault pkgs.mariadb;
        ensureDatabases = mapAttrsToList (hostName: cfg: cfg.database.name) eachSite;
        ensureUsers = mapAttrsToList (hostName: cfg: {
          name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "ALL PRIVILEGES";
          };
        }) eachSite;
      };

      services.phpfpm.pools = mapAttrs' (
        hostName: cfg:
        (nameValuePair "kimai-${hostName}" {
          inherit user;
          group = webserver.group;
          settings = {
            "listen.owner" = webserver.user;
            "listen.group" = webserver.group;
          } // cfg.poolConfig;
        })
      ) eachSite;

    }

    {
      systemd.tmpfiles.rules = flatten (
        mapAttrsToList (hostName: cfg: [
          "d '${stateDir hostName}' 0770 ${user} ${webserver.group} - -"
        ]) eachSite
      );

      systemd.services = mkMerge [
        (mapAttrs' (
          hostName: cfg:
          (nameValuePair "kimai-init-${hostName}" {
            wantedBy = [ "multi-user.target" ];
            before = [ "phpfpm-kimai-${hostName}.service" ];
            after = optional cfg.database.createLocally "mysql.service";
            script =
              let
                envFile = "${stateDir hostName}/.env";
                appSecretFile = "${stateDir hostName}/.app_secret";
                mysql = "${config.services.mysql.package}/bin/mysql";

                dbUser = cfg.database.user;
                dbPwd = if cfg.database.passwordFile != null then ":$(cat ${cfg.database.passwordFile})" else "";
                dbHost = cfg.database.host;
                dbPort = toString cfg.database.port;
                dbName = cfg.database.name;
                dbCharset = cfg.database.charset;
                dbUnixSocket = if cfg.database.socket != null then "&unixSocket=${cfg.database.socket}" else "";
                # Note: serverVersion is a shell variable. See below.
                dbUri =
                  "mysql://${dbUser}${dbPwd}@${dbHost}:${dbPort}"
                  + "/${dbName}?charset=${dbCharset}"
                  + "&serverVersion=$serverVersion${dbUnixSocket}";
              in
              ''
                set -eu

                serverVersion=${
                  if !cfg.database.createLocally then
                    cfg.database.serverVersion
                  else
                    # Obtain MySQL version string dynamically from the running
                    # instance. Doctrine ORM's doc said it should be possible to
                    # autodetect this, however Kimai's doc insists that it has to
                    # be set.
                    # https://www.doctrine-project.org/projects/doctrine-dbal/en/latest/reference/configuration.html#mysql
                    # https://stackoverflow.com/q/9558867
                    "$(${mysql} --silent --skip-column-names --execute 'SELECT VERSION();')"
                }

                # Create .env file containing DATABASE_URL and other default
                # variables. Set umask to make sure .env is not readable by
                # unrelated users.
                oldUmask=$(umask)
                umask 177

                if ! [ -e ${appSecretFile} ]; then
                  tr -dc A-Za-z0-9 </dev/urandom | head -c 20 >${appSecretFile}
                fi

                cat >${envFile} <<EOF
                DATABASE_URL=${dbUri}
                MAILER_FROM=kimai@example.com
                MAILER_URL=null://null
                APP_ENV=prod
                APP_SECRET=$(cat ${appSecretFile})
                CORS_ALLOW_ORIGIN=^https?://localhost(:[0-9]+)?\$
                EOF

                umask $oldUmask

                # Run kimai:install to ensure database is created or updated.
                # Note that kimai:update is an alias to kimai:install.
                ${pkg hostName cfg}/bin/console kimai:install
              '';

            serviceConfig = {
              Type = "oneshot";
              User = user;
              Group = webserver.group;
              EnvironmentFile = [ cfg.environmentFile ];
            };
          })
        ) eachSite)

        (mapAttrs' (
          hostName: cfg:
          (nameValuePair "phpfpm-kimai-${hostName}.service" {
            serviceConfig = {
              EnvironmentFile = [ cfg.environmentFile ];
            };
          })
        ) eachSite)

        (optionalAttrs (any (v: v.database.createLocally) (attrValues eachSite)) {
          "${cfg.webserver}".after = [ "mysql.service" ];
        })
      ];

      users.users.${user} = {
        group = webserver.group;
        isSystemUser = true;
      };
    }

    (mkIf (cfg.webserver == "nginx") {
      services.nginx = {
        enable = true;
        virtualHosts = mapAttrs (hostName: cfg: {
          serverName = mkDefault hostName;
          root = "${pkg hostName cfg}/share/php/kimai/public";
          extraConfig = ''
            index index.php;
          '';
          locations = {
            "/" = {
              priority = 200;
              extraConfig = ''
                try_files $uri /index.php$is_args$args;
              '';
            };
            "~ ^/index\\.php(/|$)" = {
              priority = 500;
              extraConfig = ''
                fastcgi_split_path_info ^(.+\.php)(/.+)$;
                fastcgi_pass unix:${config.services.phpfpm.pools."kimai-${hostName}".socket};
                fastcgi_index index.php;
                include "${config.services.nginx.package}/conf/fastcgi.conf";
                fastcgi_param PATH_INFO $fastcgi_path_info;
                fastcgi_param PATH_TRANSLATED $document_root$fastcgi_path_info;
                # Mitigate https://httpoxy.org/ vulnerabilities
                fastcgi_param HTTP_PROXY "";
                fastcgi_intercept_errors off;
                fastcgi_buffer_size 16k;
                fastcgi_buffers 4 16k;
                fastcgi_connect_timeout 300;
                fastcgi_send_timeout 300;
                fastcgi_read_timeout 300;
              '';
            };
            "~ \\.php$" = {
              priority = 800;
              extraConfig = ''
                return 404;
              '';
            };
          };
        }) eachSite;
      };
    })

  ]);
}
