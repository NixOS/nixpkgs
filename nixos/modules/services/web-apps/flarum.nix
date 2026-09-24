{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.services.flarum;

  # Only placeholders reach the world-readable Nix store; the install
  # script substitutes the real secrets at runtime.
  dbConfig =
    cfg.database
    // optionalAttrs (cfg.databasePasswordFile != null) {
      password = "@databasePassword@";
    };

  flarumInstallConfig = pkgs.writeText "config.json" (
    builtins.toJSON {
      debug = false;
      offline = false;

      baseUrl = cfg.baseUrl;
      databaseConfiguration = dbConfig;
      adminUser = {
        username = cfg.adminUser;
        password =
          if cfg.initialAdminPasswordFile != null then "@adminPassword@" else cfg.initialAdminPassword;
        email = cfg.adminEmail;
      };
      settings = {
        forum_title = cfg.forumTitle;
      };
    }
  );

  phpFormat = pkgs.formats.php { };

  configPhpFile = phpFormat.generate "flarum-config.php" {
    debug = false;
    database = dbConfig;
    url = cfg.baseUrl;
    paths = {
      api = "api";
      admin = "admin";
    };
    headers = {
      poweredByHeader = true;
      referrerPolicy = "same-origin";
    };
    queue = {
      driver = "sync";
    };
  };
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
      description = ''
        Initial password for the adminUser.

        WARNING: This is stored world-readable in the Nix store.
        Use {option}`initialAdminPasswordFile` instead.
      '';
    };

    initialAdminPasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/flarum-admin-password";
      description = ''
        File containing the initial password for adminUser.
        Must be readable by the flarum user.
        Takes precedence over {option}`initialAdminPassword`.

        The password must not contain `"` or `\` characters, as it is
        substituted into a JSON installation config verbatim.
      '';
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

    database = mkOption {
      type =
        with types;
        attrsOf (oneOf [
          str
          bool
          int
        ]);
      description = ''
        MySQL database parameters.

        WARNING: A `password` set here is stored world-readable in the
        Nix store. Use {option}`databasePasswordFile` instead.
      '';
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

    databasePasswordFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/flarum-db-password";
      description = ''
        File containing the database password.
        Must be readable by the flarum user.
        Takes precedence over `database.password`.

        The password must not contain `"` or `\` characters, as it is
        substituted into a JSON installation config verbatim.
      '';
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
        # The secret-filled install config is staged in /tmp
        PrivateTmp = true;
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
        if [ ! -f .flarum-installed ]; then
          if [ ! -f config.php ]; then
            install -m 0600 ${flarumInstallConfig} /tmp/flarum-install.json
            ${optionalString (cfg.initialAdminPasswordFile != null) ''
              ${pkgs.replace-secret}/bin/replace-secret '@adminPassword@' \
                ${escapeShellArg cfg.initialAdminPasswordFile} /tmp/flarum-install.json
            ''}
            ${optionalString (cfg.databasePasswordFile != null) ''
              ${pkgs.replace-secret}/bin/replace-secret '@databasePassword@' \
                ${escapeShellArg cfg.databasePasswordFile} /tmp/flarum-install.json
            ''}
            php flarum install --file=/tmp/flarum-install.json
          fi
          touch .flarum-installed
        fi
      ''
      + ''
        install -m 0600 ${configPhpFile} config.php
        ${optionalString (cfg.databasePasswordFile != null) ''
          ${pkgs.replace-secret}/bin/replace-secret '@databasePassword@' \
            ${escapeShellArg cfg.databasePasswordFile} config.php
        ''}

        php flarum migrate
        php flarum cache:clear
      '';
    };
  };

  meta.maintainers = with lib.maintainers; [
    fsagbuya
    jasonodoom
  ];
}
