{ config, lib, pkgs, ... }:

let
  inherit (lib) mkDefault mkEnableOption mkForce mkIf mkMerge mkOption types;
  inherit (lib) concatStringsSep literalExample mapAttrsToList optional optionalString;

  cfg = config.services.moodle;
  fpm = config.services.phpfpm.pools.moodle;

  user = "moodle";
  group = config.services.httpd.group;
  stateDir = "/var/lib/moodle";

  moodleConfig = pkgs.writeText "config.php" ''
  <?php  // Moodle configuration file

  unset($CFG);
  global $CFG;
  $CFG = new stdClass();

  $CFG->dbtype    = '${ { mysql = "mariadb"; pgsql = "pgsql"; }.${cfg.database.type} }';
  $CFG->dblibrary = 'native';
  $CFG->dbhost    = '${cfg.database.host}';
  $CFG->dbname    = '${cfg.database.name}';
  $CFG->dbuser    = '${cfg.database.user}';
  ${optionalString (cfg.database.passwordFile != null) "$CFG->dbpass = file_get_contents('${cfg.database.passwordFile}');"}
  $CFG->prefix    = 'mdl_';
  $CFG->dboptions = array (
    'dbpersist' => 0,
    'dbport' => '${toString cfg.database.port}',
    ${optionalString (cfg.database.socket != null) "'dbsocket' => '${cfg.database.socket}',"}
    'dbcollation' => 'utf8mb4_unicode_ci',
  );

  $CFG->wwwroot   = '${if cfg.virtualHost.addSSL || cfg.virtualHost.forceSSL || cfg.virtualHost.onlySSL then "https" else "http"}://${cfg.virtualHost.hostName}';
  $CFG->dataroot  = '${stateDir}';
  $CFG->admin     = 'admin';

  $CFG->directorypermissions = 02777;
  $CFG->disableupdateautodeploy = true;

  $CFG->pathtogs = '${pkgs.ghostscript}/bin/gs';
  $CFG->pathtophp = '${pkgs.php}/bin/php';
  $CFG->pathtodu = '${pkgs.coreutils}/bin/du';
  $CFG->aspellpath = '${pkgs.aspell}/bin/aspell';
  $CFG->pathtodot = '${pkgs.graphviz}/bin/dot';

  ${cfg.extraConfig}

  require_once('${cfg.package}/share/moodle/lib/setup.php');

  // There is no php closing tag in this file,
  // it is intentional because it prevents trailing whitespace problems!
  '';

  mysqlLocal = cfg.database.createLocally && cfg.database.type == "mysql";
  pgsqlLocal = cfg.database.createLocally && cfg.database.type == "pgsql";
in
{
  # interface
  options.services.moodle = {
    enable = mkEnableOption "Moodle web application";

    package = mkOption {
      type = types.package;
      default = pkgs.moodle;
      defaultText = "pkgs.moodle";
      description = "The Moodle package to use.";
    };

    initialPassword = mkOption {
      type = types.str;
      example = "correcthorsebatterystaple";
      description = ''
        Specifies the initial password for the admin, i.e. the password assigned if the user does not already exist.
        The password specified here is world-readable in the Nix store, so it should be changed promptly.
      '';
    };

    database = {
      type = mkOption {
        type = types.enum [ "mysql" "pgsql" ];
        default = "mysql";
        description = ''Database engine to use.'';
      };

      host = mkOption {
        type = types.str;
        default = "localhost";
        description = "Database host address.";
      };

      port = mkOption {
        type = types.int;
        description = "Database host port.";
        default = {
          mysql = 3306;
          pgsql = 5432;
        }.${cfg.database.type};
        defaultText = "3306";
      };

      name = mkOption {
        type = types.str;
        default = "moodle";
        description = "Database name.";
      };

      user = mkOption {
        type = types.str;
        default = "moodle";
        description = "Database user.";
      };

      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        example = "/run/keys/moodle-dbpassword";
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
          else null;
        defaultText = "/run/mysqld/mysqld.sock";
        description = "Path to the unix socket file to use for authentication.";
      };

      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = "Create the database and database user locally.";
      };
    };

    virtualHost = mkOption {
      type = types.submodule (import ../web-servers/apache-httpd/vhost-options.nix);
      example = literalExample ''
        {
          hostName = "moodle.example.org";
          adminAddr = "webmaster@example.org";
          forceSSL = true;
          enableACME = true;
        }
      '';
      description = ''
        Apache configuration can be done by adapting <option>services.httpd.virtualHosts</option>.
        See <xref linkend="opt-services.httpd.virtualHosts"/> for further information.
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
      description = ''
        Options for the Moodle PHP pool. See the documentation on <literal>php-fpm.conf</literal>
        for details on configuration directives.
      '';
    };

    extraConfig = mkOption {
      type = types.lines;
      default = "";
      description = ''
        Any additional text to be appended to the config.php
        configuration file. This is a PHP script. For configuration
        details, see <link xlink:href="https://docs.moodle.org/37/en/Configuration_file"/>.
      '';
      example = ''
        $CFG->disableupdatenotifications = true;
      '';
    };
  };

  # implementation
  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.database.createLocally -> cfg.database.user == user;
        message = "services.moodle.database.user must be set to ${user} if services.moodle.database.createLocally is set true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.moodle.database.createLocally is set to true";
      }
    ];

    services.mysql = mkIf mysqlLocal {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = {
            "${cfg.database.name}.*" = "SELECT, INSERT, UPDATE, DELETE, CREATE, CREATE TEMPORARY TABLES, DROP, INDEX, ALTER";
          };
        }
      ];
    };

    services.postgresql = mkIf pgsqlLocal {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.phpfpm.pools.moodle = {
      inherit user group;
      phpEnv.MOODLE_CONFIG = "${moodleConfig}";
      phpOptions = ''
        zend_extension = opcache.so
        opcache.enable = 1
      '';
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
        documentRoot = mkForce "${cfg.package}/share/moodle";
        extraConfig = ''
          <Directory "${cfg.package}/share/moodle">
            <FilesMatch "\.php$">
              <If "-f %{REQUEST_FILENAME}">
                SetHandler "proxy:unix:${fpm.socket}|fcgi://localhost/"
              </If>
            </FilesMatch>
            Options -Indexes
            DirectoryIndex index.php
          </Directory>
        '';
      } ];
    };

    systemd.tmpfiles.rules = [
      "d '${stateDir}' 0750 ${user} ${group} - -"
    ];

    systemd.services.moodle-init = {
      wantedBy = [ "multi-user.target" ];
      before = [ "phpfpm-moodle.service" ];
      after = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";
      environment.MOODLE_CONFIG = moodleConfig;
      script = ''
        ${pkgs.php}/bin/php ${cfg.package}/share/moodle/admin/cli/check_database_schema.php && rc=$? || rc=$?

        [ "$rc" == 1 ] && ${pkgs.php}/bin/php ${cfg.package}/share/moodle/admin/cli/upgrade.php \
          --non-interactive \
          --allow-unstable

        [ "$rc" == 2 ] && ${pkgs.php}/bin/php ${cfg.package}/share/moodle/admin/cli/install_database.php \
          --agree-license \
          --adminpass=${cfg.initialPassword}

        true
      '';
      serviceConfig = {
        User = user;
        Group = group;
        Type = "oneshot";
      };
    };

    systemd.services.moodle-cron = {
      description = "Moodle cron service";
      after = [ "moodle-init.service" ];
      environment.MOODLE_CONFIG = moodleConfig;
      serviceConfig = {
        User = user;
        Group = group;
        ExecStart = "${pkgs.php}/bin/php ${cfg.package}/share/moodle/admin/cli/cron.php";
      };
    };

    systemd.timers.moodle-cron = {
      description = "Moodle cron timer";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "minutely";
      };
    };

    systemd.services.httpd.after = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";

    users.users.${user} = {
      group = group;
      isSystemUser = true;
    };
  };
}
