{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.services.flarum;

  flarumInstallConfig = pkgs.writeText "config.json" (
    builtins.toJSON {
      debug = false;
      offline = false;

      baseUrl = cfg.baseUrl;
      databaseConfiguration = cfg.database;
      adminUser = {
        username = cfg.adminUser;
        password = cfg.initialAdminPassword;
        email = cfg.adminEmail;
      };
      settings = {
        forum_title = cfg.forumTitle;
      };
    }
  );
in
{
  options.services.flarum = {
    enable = mkEnableOption "Flarum discussion platform";

    package = mkPackageOption pkgs "flarum" { };

    forumTitle = mkOption {
      type = types.str;
      default = "A Flarum Forum on NixOS";
      description = "Title of the forum.";
    };

    domain = mkOption {
      type = types.str;
      default = "localhost";
      example = "forum.example.com";
      description = "Domain to serve on.";
    };

    baseUrl = mkOption {
      type = types.str;
      default = "http://localhost";
      example = "https://forum.example.com";
      description = "Change `domain` instead.";
    };

    adminUser = mkOption {
      type = types.str;
      default = "flarum";
      description = "Username for first web application administrator";
    };

    adminEmail = mkOption {
      type = types.str;
      default = "admin@example.com";
      description = "Email for first web application administrator";
    };

    initialAdminPassword = mkOption {
      type = types.str;
      default = "flarum";
      description = "Initial password for the adminUser";
    };

    user = mkOption {
      type = types.str;
      default = "flarum";
      description = "System user to run Flarum";
    };

    group = mkOption {
      type = types.str;
      default = "flarum";
      description = "System group to run Flarum";
    };

    stateDir = mkOption {
      type = types.path;
      default = "/var/lib/flarum";
      description = "Home directory for writable storage";
    };

    database = mkOption rec {
      type =
        with types;
        attrsOf (oneOf [
          str
          bool
          int
        ]);
      description = "MySQL database parameters";
      default = {
        # the database driver; i.e. MySQL; MariaDB...
        driver = "mysql";
        # the host of the connection; localhost in most cases unless using an external service
        host = "localhost";
        # the name of the database in the instance
        database = "flarum";
        # database username
        username = "flarum";
        # database password
        password = "";
        # the prefix for the tables; useful if you are sharing the same database with another service
        prefix = "";
        # the port of the connection; defaults to 3306 with MySQL
        port = 3306;
        strict = false;
      };
    };

    createDatabaseLocally = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Create the database and database user locally, and run installation.

        WARNING: Due to <https://github.com/flarum/framework/issues/4018>, this option is set
        to false by default. The 'flarum install' command may delete existing database tables.
        Only set this to true if you are certain you are working with a fresh, empty database.
      '';
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      home = cfg.stateDir;
      createHome = true;
      homeMode = "755";
      group = cfg.group;
    };
    users.groups.${cfg.group} = { };

    services.phpfpm.pools.flarum = {
      user = cfg.user;
      settings = {
        "listen.owner" = config.services.nginx.user;
        "listen.group" = config.services.nginx.group;
        "listen.mode" = "0600";
        "pm" = mkDefault "dynamic";
        "pm.max_children" = mkDefault 10;
        "pm.max_requests" = mkDefault 500;
        "pm.start_servers" = mkDefault 2;
        "pm.min_spare_servers" = mkDefault 1;
        "pm.max_spare_servers" = mkDefault 3;
      };
      phpOptions = ''
        error_log = syslog
        log_errors = on
      '';
    };

    services.nginx = {
      enable = true;
      virtualHosts."${cfg.domain}" = {
        root = "${cfg.stateDir}/public";
        locations."~ \\.php$".extraConfig = ''
          fastcgi_pass unix:${config.services.phpfpm.pools.flarum.socket};
          fastcgi_index site.php;
        '';
        extraConfig = ''
          index index.php;
          include ${cfg.package}/share/php/flarum/.nginx.conf;
        '';
      };
    };

    services.mysql = mkIf cfg.enable {
      enable = true;
      package = pkgs.mariadb;
      ensureDatabases = [ cfg.database.database ];
      ensureUsers = [
        {
          name = cfg.database.username;
          ensurePermissions = {
            "${cfg.database.database}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    assertions = [
      {
        assertion = !cfg.createDatabaseLocally || cfg.database.driver == "mysql";
        message = "Flarum can only be automatically installed in MySQL/MariaDB.";
      }
    ];

    systemd.services."phpfpm-flarum" = {
      restartTriggers = [ cfg.package ];
    };

    systemd.services.flarum-install = {
      description = "Flarum installation";
      requiredBy = [ "phpfpm-flarum.service" ];
      before = [ "phpfpm-flarum.service" ];
      requires = [ "mysql.service" ];
      after = [ "mysql.service" ];
      serviceConfig = {
        Type = "oneshot";
        User = cfg.user;
        Group = cfg.group;
      };
      path = [ config.services.phpfpm.phpPackage ];
      script = ''
        mkdir -p ${cfg.stateDir}/{extensions,public/assets/avatars}
        mkdir -p ${cfg.stateDir}/storage/{cache,formatter,sessions,views}
        cd ${cfg.stateDir}
        cp -f ${cfg.package}/share/php/flarum/{extend.php,site.php,flarum} .
        ln -sf ${cfg.package}/share/php/flarum/vendor .
        ln -sf ${cfg.package}/share/php/flarum/public/index.php public/
      ''
      + optionalString (cfg.createDatabaseLocally && cfg.database.driver == "mysql") ''
        if [ ! -f config.php ]; then
          php flarum install --file=${flarumInstallConfig}
        fi
      ''
      + ''
        if [ -f config.php ]; then
          php flarum migrate
          php flarum cache:clear
        fi
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [
    fsagbuya
    jasonodoom
  ];
}
