{ config, lib, pkgs, ... }:

with lib;

let

  giteaUser = "gitea";
  giteaGroup = "gitea";

  cfg = config.services.gitea;

  postgresql = config.services.postgresql.package;
  gitea = pkgs.gitea.bin;

  useLocalPostgresqlDatabase = (
    cfg.database.type == "postgres" && cfg.database.host == "127.0.0.1"
  );

  toConfigBool = bool: if bool then "true" else "false";

  configFile = pkgs.writeText "app.ini" ''
    APP_NAME = ${cfg.appName}
    RUN_USER = ${cfg.user}
    RUN_MODE = prod

    [repository]
    ROOT = ${cfg.repository.root}
    FORCE_PRIVATE = ${toConfigBool cfg.repository.forcePrivate}

    [server]
    DOMAIN = ${cfg.server.domain}
    HTTP_ADDR = ${cfg.server.httpAddress}
    HTTP_PORT = ${toString cfg.server.httpPort}
    ROOT_URL = ${cfg.server.rootUrl}
    DISABLE_SSH = true
    OFFLINE_MODE = true

    [database]
    DB_TYPE = ${cfg.database.type}
    HOST = ${cfg.database.host}:${toString cfg.database.port}
    NAME = ${cfg.database.name}
    USER = ${cfg.database.user}
    PASSWD = ${cfg.database.password}
    PATH = ${cfg.database.path}
    SSL_MODE = ${cfg.database.sslMode}

    [security]
    SECRET_KEY = #secretkey#
    INSTALL_LOCK = true

    [service]
    DISABLE_REGISTRATION = ${toConfigBool (!cfg.service.enableRegistration)}
    SHOW_REGISTRATION_BUTTON = ${toConfigBool cfg.service.enableRegistration}
    REGISTER_EMAIL_CONFIRM = ${toConfigBool cfg.service.requireMailConfirmation}
    ENABLE_NOTIFY_MAIL = ${toConfigBool cfg.service.enableMailNotification}
    REQUIRE_SIGNIN_VIEW = ${toConfigBool cfg.service.requireLogin}

    [mailer]
    ENABLED = ${toConfigBool cfg.mail.enable}
    HOST = ${cfg.mail.host}:${toString cfg.mail.port}
    FROM = ${cfg.mail.from}
    USER = ${cfg.mail.user}
    PASSWD = ${cfg.mail.password}

    [other]
    SHOW_FOOTER_BRANDING = ${toConfigBool cfg.footer.branding}
    SHOW_FOOTER_VERSION = ${toConfigBool cfg.footer.version}
    SHOW_FOOTER_TEMPLATE_LOAD_TIME = ${toConfigBool cfg.footer.loadtime}

    [log]
    LEVEL = Warn

    ${cfg.extraConfig}
  '';
in

{
  options = {
    services.gitea = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable Go Git Service.";
      };

      useWizard = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Use Gitea installation wizard instead of creating a 
          configuration file.
          The first registered user will be administrator.
        '';
      };

      appName = mkOption {
        type = types.str;
        default = "Gitea: Git with a cup of tea";
        description = "Application name.";
      };

      repository = {
        root = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/repositories";
          description = "Path to the git repositories.";
        };
        forcePrivate = mkOption {
          type = types.bool;
          default = false;
          description = "Force every new repository to be private.";
        };
      };

      server = {
        domain = mkOption {
          type = types.str;
          default = "localhost";
          description = "Domain name of your server.";
        };

        rootUrl = mkOption {
          type = types.str;
          default = "http://localhost:3000/";
          description = "Full public URL of Gitea server.";
        };

        httpAddress = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = "HTTP listen address.";
        };

        httpPort = mkOption {
          type = types.int;
          default = 3000;
          description = "HTTP listen port.";
        };
      };

      database = {
        type = mkOption {
          type = types.enum [ "sqlite3" "mysql" "postgres" ];
          example = "mysql";
          default = "sqlite3";
          description = "Database engine to use.";
        };

        host = mkOption {
          type = types.str;
          default = "127.0.0.1";
          description = "Database host address.";
        };

        port = mkOption {
          type = types.int;
          default = 3306;
          description = "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "gitea";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "gitea";
          description = "Database user.";
        };

        password = mkOption {
          type = types.str;
          default = "";
          description = "Database password.";
        };

        path = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/data/gitea.db";
          description = "Path to the sqlite3 database file.";
        };

        sslMode = mkOption {
          type = types.string;
          default = "disable";
          description = ''
            (For PostgreSQL only).
            only "require", "verify-full", "verify-ca",
            and "disable" supported.
          '';
        };
      };

      service = {
        enableRegistration = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable account-registration.

            If disabled only the admin can create accounts.
          '';
        };

        enableMailNotification = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable email-notifications for watched repositories.
          '';
        };

        requireMailConfirmation = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable email-confirmation for account-registration
          '';
        };

        requireLogin = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Require users to login to view any page.
          '';
        };
      };

      mail = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enable mail delivery using SMTP.";
        };

        host = mkOption {
          type = types.string;
          default = "localhost";
          description = "The host to use for sending mails.";
        };

        port = mkOption {
          type = types.int;
          default = 25;
          description = "The port to use for the SMTP server.";
        };

        user = mkOption {
          type = types.string;
          default = "";
          description = "The username to use for the SMTP server.";
        };

        password = mkOption {
          type = types.string;
          default = "";
          description = "The password to use for the SMTP server.";
        };

        from = mkOption {
          type = types.string;
          default = "gitea@localhost";
          description = "The email address to use for sending mails.";
        };
      };

      footer = {
        branding = mkOption {
          type = types.bool;
          default = true;
          description = "Show branding in footer.";
        };

        version = mkOption {
          type = types.bool;
          default = true;
          description = "Show version in footer.";
        };

        loadtime = mkOption {
          type = types.bool;
          default = true;
          description = "Show loadtime in footer.";
        };
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Configuration lines appended to the generated Gitea configuration file.";
      };

      stateDir = mkOption {
        default = "/var/lib/gitea";
        type = types.str;
        description = "Gitea data directory.";
      };

      user = mkOption {
        type = types.str;
        default = giteaUser;
        description = "User account under which Gitea runs.";
      };

      group = mkOption {
        type = types.str;
        default = giteaGroup;
        description = "Group account under which Gitea runs.";
      };
    };
  };

  config = mkIf cfg.enable {

    users.extraUsers = optional (cfg.user == giteaUser) {
      name = giteaUser;
      uid = config.ids.uids.gitea;
      group = cfg.group;
      description = "Go Git Service";
      home = cfg.stateDir;
      createHome = true;
      shell = pkgs.bash;
    };

    users.extraGroups = optional (cfg.group == giteaGroup) {
      name = giteaGroup;
      gid = config.ids.gids.gitea;
    };

    services.postgresql = mkIf useLocalPostgresqlDatabase {
      enable = true;
    };

    system.activationScripts.gitea = ''
      mkdir -p ${cfg.stateDir}
      chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir}
    '';

    systemd.services.gitea = {
      description = "Gitea (Go Git Service)";

      wantedBy = [ "multi-user.target" ];
      requires = [ "network.target" ]
        ++ optional useLocalPostgresqlDatabase "postgresql.service";
      after = [ "network.target" ]
        ++ optional useLocalPostgresqlDatabase "postgresql.service";

      path = [ pkgs.gitea.bin ];

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        GITEA_WORK_DIR = cfg.stateDir;
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${pkgs.gitea.bin}/bin/gitea web";
        Restart = "always";
        PermissionsStartOnly = true;
        PrivateDevices = true;
        PrivateTmp = mkIf (!useLocalPostgresqlDatabase) true;
        JoinsNamespaceOf = mkIf useLocalPostgresqlDatabase "postgresql.service";
      };

      preStart = ''
        # copy custom configuration and generate a random secret key if needed
        ${optionalString (cfg.useWizard == false) ''
          mkdir -p ${cfg.stateDir}/custom/conf
          cp -f ${configFile} ${cfg.stateDir}/custom/conf/app.ini
          KEY=$(head -c 16 /dev/urandom | tr -dc A-Za-z0-9)
          sed -i "s,#secretkey#,$KEY,g" ${cfg.stateDir}/custom/conf/app.ini
        ''}

        mkdir -p ${cfg.repository.root}
        # update all hooks' binary paths
        HOOKS=$(find ${cfg.repository.root} -mindepth 4 -maxdepth 4 -type f -wholename "*git/hooks/*")
        if [ "$HOOKS" ]
        then
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/gitea,${pkgs.gitea.bin}/bin/gitea,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/env,${pkgs.coreutils}/bin/env,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/bash,${pkgs.bash}/bin/bash,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/perl,${pkgs.perl}/bin/perl,g' $HOOKS
        fi

        # setup postgres user
        ${optionalString useLocalPostgresqlDatabase ''
          if ! [ -e ${cfg.stateDir}/.db-created ]; then
            ${pkgs.postgresql}/bin/psql \
              postgres -c "CREATE USER ${cfg.database.user} WITH PASSWORD '${cfg.database.password}';";
            ${pkgs.postgresql}/bin/createdb \
              ${cfg.database.name} -O ${cfg.database.user}
            touch ${cfg.stateDir}/.db-created
          fi
        ''}
      chown -R ${cfg.user}:${cfg.group} ${cfg.stateDir}
      '';
    };
  };
}
