{ config, lib, pkgs, ... }:

let

  inherit (lib) mkDefault mkEnableOption mkForce mkIf mkMerge mkOption;
  inherit (lib) literalExpression mapAttrs optional optionalString types;

  cfg = config.services.limesurvey;
  fpm = config.services.phpfpm.pools.limesurvey;

  user = "limesurvey";
  group = config.services.httpd.group;
  stateDir = "/var/lib/limesurvey";

  pkg = pkgs.limesurvey;

  configType = with types; oneOf [ (attrsOf configType) str int bool ] // {
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
    enable = mkEnableOption (lib.mdDoc "Limesurvey web application.");

    database = {
      type = mkOption {
        type = types.enum [ "mysql" "pgsql" "odbc" "mssql" ];
        example = "pgsql";
        default = "mysql";
        description = lib.mdDoc "Database engine to use.";
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = lib.mdDoc "Database host address.";
      };

      port = mkOption {
        type = types.port;
        default = if cfg.database.type == "pgsql" then 5442 else 3306;
        defaultText = literalExpression "3306";
        description = lib.mdDoc "Database host port.";
      };

      name = mkOption {
        type = types.str;
        default = "limesurvey";
        description = lib.mdDoc "Database name.";
      };

      user = mkOption {
        type = types.str;
        default = "limesurvey";
        description = lib.mdDoc "Database user.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/limesurvey-dbpassword";
        description = lib.mdDoc ''
          A file containing the password corresponding to
          {option}`database.user`.
        '';
      };

      socket = mkOption {
        type = types.nullOr types.path;
        default =
          if mysqlLocal then "/run/mysqld/mysqld.sock"
          else if pgsqlLocal then "/run/postgresql"
          else null
        ;
        defaultText = literalExpression "/run/mysqld/mysqld.sock";
        description = lib.mdDoc "Path to the unix socket file to use for authentication.";
      };

      createLocally = mkOption {
        type = types.bool;
        default = cfg.database.type == "mysql";
        defaultText = literalExpression "true";
        description = lib.mdDoc ''
          Create the database and database user locally.
          This currently only applies if database type "mysql" is selected.
        '';
      };
    };

    virtualHost = mkOption {
      type = types.submodule (import ../web-servers/apache-httpd/vhost-options.nix);
      example = literalExpression ''
        {
          hostName = "survey.example.org";
          adminAddr = "webmaster@example.org";
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = lib.mdDoc ''
        Apache configuration can be done by adapting `services.httpd.virtualHosts.<name>`.
        See [](#opt-services.httpd.virtualHosts) for further information.
      '';
    };

    poolConfig = mkOption {
      type = with types; attrsOf (oneOf [ str int bool ]);
      default = {
        "pm" = "dynamic";
        "pm.max_children" = 32;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 2;
        "pm.max_spare_servers" = 4;
        "pm.max_requests" = 500;
      };
      description = lib.mdDoc ''
        Options for the LimeSurvey PHP pool. See the documentation on `php-fpm.conf`
        for details on configuration directives.
      '';
    };

    config = mkOption {
      type = configType;
      default = {};
      description = lib.mdDoc ''
        LimeSurvey configuration. Refer to
        <https://manual.limesurvey.org/Optional_settings>
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
        force_ssl = mkIf (cfg.virtualHost.addSSL || cfg.virtualHost.forceSSL || cfg.virtualHost.onlySSL) "on";
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
      inherit user group;
      phpEnv.LIMESURVEY_CONFIG = "${limesurveyConfig}";
      settings = {
        "listen.owner" = config.services.httpd.user;
        "listen.group" = config.services.httpd.group;
      } // cfg.poolConfig;
    };

    services.httpd = {
      enable = true;
      adminAddr = mkDefault cfg.virtualHost.adminAddr;
      extraModules = [ "proxy_fcgi" ];
      virtualHosts.${cfg.virtualHost.hostName} = mkMerge [ cfg.virtualHost {
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
                SetHandler "proxy:unix:${fpm.socket}|fcgi://localhost/"
              </If>
            </FilesMatch>

            AllowOverride all
            Options -Indexes
            DirectoryIndex index.php
          </Directory>
        '';
      } ];
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

    users.users.${user} = {
      group = group;
      isSystemUser = true;
    };

  };
}
