{ config, lib, pkgs, ... }:

let

  inherit (lib) mkDefault mkEnableOption mkForce mkIf mkMerge mkOption;
  inherit (lib) mapAttrs optional optionalString types;

  cfg = config.services.limesurvey;
  fpm = config.services.phpfpm.pools.limesurvey;

  user = "limesurvey";
  group = config.services.httpd.group;
  stateDir = "/var/lib/limesurvey";

  pkg = pkgs.limesurvey;

  configType = with types; either (either (attrsOf configType) str) (either int bool) // {
    description = "limesurvey config type (str, int, bool or attribute set thereof)";
  };

  limesurveyConfig = pkgs.writeText "config.php" ''
    <?php
      return json_decode('${builtins.toJSON cfg.config}', true);
    ?>
  '';

  mysqlLocal = cfg.database.createLocally && cfg.database.type == "mysql";
  pgsqlLocal = cfg.database.createLocally && cfg.database.type == "pgsql";

in
{
  # interface

  options.services.limesurvey = {
    enable = mkEnableOption "Limesurvey web application.";

    database = {
      type = mkOption {
        type = types.enum [ "mysql" "pgsql" "odbc" "mssql" ];
        example = "pgsql";
        default = "mysql";
        description = "Database engine to use.";
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Database host address.";
      };

      port = mkOption {
        type = types.int;
        default = if cfg.database.type == "pgsql" then 5442 else 3306;
        defaultText = "3306";
        description = "Database host port.";
      };

      name = mkOption {
        type = types.str;
        default = "limesurvey";
        description = "Database name.";
      };

      user = mkOption {
        type = types.str;
        default = "limesurvey";
        description = "Database user.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/limesurvey-dbpassword";
        description = ''
          A file containing the password corresponding to
          <option>database.user</option>.
        '';
      };

      socket = mkOption {
        type = types.nullOr types.path;
        default =
          if mysqlLocal then "/run/mysqld/mysqld.sock"
          else if pgsqlLocal then "/run/postgresql"
          else null
        ;
        defaultText = "/run/mysqld/mysqld.sock";
        description = "Path to the unix socket file to use for authentication.";
      };

      createLocally = mkOption {
        type = types.bool;
        default = cfg.database.type == "mysql";
        defaultText = "true";
        description = ''
          Create the database and database user locally.
          This currently only applies if database type "mysql" is selected.
        '';
      };
    };

    virtualHost = mkOption {
      type = types.submodule ({
        options = import ../web-servers/apache-httpd/per-server-options.nix {
          inherit lib;
          forMainServer = false;
        };
      });
      example = {
        hostName = "survey.example.org";
        enableSSL = true;
        adminAddr = "webmaster@example.org";
        sslServerCert = "/var/lib/acme/survey.example.org/full.pem";
        sslServerKey = "/var/lib/acme/survey.example.org/key.pem";
      };
      description = ''
        Apache configuration can be done by adapting <literal>services.httpd.virtualHosts.&lt;name&gt;</literal>.
        See <xref linkend="opt-services.httpd.virtualHosts"/> for further information.
      '';
    };

    poolConfig = mkOption {
      type = types.lines;
      default = ''
        pm = dynamic
        pm.max_children = 32
        pm.start_servers = 2
        pm.min_spare_servers = 2
        pm.max_spare_servers = 4
        pm.max_requests = 500
      '';
      description = ''
        Options for the LimeSurvey PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    config = mkOption {
      type = configType;
      default = {};
      description = ''
        LimeSurvey configuration. Refer to
        <link xlink:href="https://manual.limesurvey.org/Optional_settings"/>
        for details on supported values.
      '';
    };
  };

  # implementation

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.database.createLocally -> cfg.database.type == "mysql";
        message = "services.limesurvey.createLocally is currently only supported for database type 'mysql'";
      }
      { assertion = cfg.database.createLocally -> cfg.database.user == user;
        message = "services.limesurvey.database.user must be set to ${user} if services.limesurvey.database.createLocally is set true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.socket != null;
        message = "services.limesurvey.database.socket must be set if services.limesurvey.database.createLocally is set to true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.limesurvey.database.createLocally is set to true";
      }
    ];

    services.limesurvey.config = mapAttrs (name: mkDefault) {
      runtimePath = "${stateDir}/tmp/runtime";
      components = {
        db = {
          connectionString = "${cfg.database.type}:dbname=${cfg.database.name};host=${if pgsqlLocal then cfg.database.socket else cfg.database.host};port=${toString cfg.database.port}" +
            optionalString mysqlLocal ";socket=${cfg.database.socket}";
          username = cfg.database.user;
          password = mkIf (cfg.database.passwordFile != null) "file_get_contents(\"${toString cfg.database.passwordFile}\");";
          tablePrefix = "limesurvey_";
        };
        assetManager.basePath = "${stateDir}/tmp/assets";
        urlManager = {
          urlFormat = "path";
          showScriptName = false;
        };
      };
      config = {
        tempdir = "${stateDir}/tmp";
        uploaddir = "${stateDir}/upload";
        force_ssl = mkIf cfg.virtualHost.enableSSL "on";
        config.defaultlang = "en";
      };
    };

    services.mysql = mkIf mysqlLocal {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "SELECT, CREATE, INSERT, UPDATE, DELETE, ALTER, DROP, INDEX";
          };
        }
      ];
    };

    services.phpfpm.pools.limesurvey = {
      listen = "/run/phpfpm/limesurvey.sock";
      extraConfig = ''
        listen.owner = ${config.services.httpd.user};
        listen.group = ${config.services.httpd.group};
        user = ${user};
        group = ${group};

        env[LIMESURVEY_CONFIG] = ${limesurveyConfig}

        ${cfg.poolConfig}
      '';
    };

    services.httpd = {
      enable = true;
      adminAddr = mkDefault cfg.virtualHost.adminAddr;
      extraModules = [ "proxy_fcgi" ];
      virtualHosts = [ (mkMerge [
        cfg.virtualHost {
          documentRoot = mkForce "${pkg}/share/limesurvey";
          extraConfig = ''
            Alias "/tmp" "${stateDir}/tmp"
            <Directory "${stateDir}">
              AllowOverride all
              Require all granted
              Options -Indexes +FollowSymlinks
            </Directory>

            Alias "/upload" "${stateDir}/upload"
            <Directory "${stateDir}/upload">
              AllowOverride all
              Require all granted
              Options -Indexes
            </Directory>

            <Directory "${pkg}/share/limesurvey">
              <FilesMatch "\.php$">
                <If "-f %{REQUEST_FILENAME}">
                  SetHandler "proxy:unix:${fpm.listen}|fcgi://localhost/"
                </If>
              </FilesMatch>

              AllowOverride all
              Options -Indexes
              DirectoryIndex index.php
            </Directory>
          '';
        }
      ]) ];
    };

    systemd.tmpfiles.rules = [
      "d ${stateDir} 0750 ${user} ${group} - -"
      "d ${stateDir}/tmp 0750 ${user} ${group} - -"
      "d ${stateDir}/tmp/assets 0750 ${user} ${group} - -"
      "d ${stateDir}/tmp/runtime 0750 ${user} ${group} - -"
      "d ${stateDir}/tmp/upload 0750 ${user} ${group} - -"
      "C ${stateDir}/upload 0750 ${user} ${group} - ${pkg}/share/limesurvey/upload"
    ];

    systemd.services.limesurvey-init = {
      wantedBy = [ "multi-user.target" ];
      before = [ "phpfpm-limesurvey.service" ];
      after = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";
      environment.LIMESURVEY_CONFIG = limesurveyConfig;
      script = ''
        # update or install the database as required
        ${pkgs.php}/bin/php ${pkg}/share/limesurvey/application/commands/console.php updatedb || \
        ${pkgs.php}/bin/php ${pkg}/share/limesurvey/application/commands/console.php install admin password admin admin@example.com verbose
      '';
      serviceConfig = {
        User = user;
        Group = group;
        Type = "oneshot";
      };
    };

    systemd.services.httpd.after = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";

    users.users."${user}".group = group;

  };
}
