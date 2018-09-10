{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitea;
  gitea = cfg.package;

  pg = config.services.postgresql;

  usePostgresql = cfg.database.type == "postgres";
  configFile = pkgs.writeText "app.ini" ''
    APP_NAME = ${cfg.appName}
    RUN_USER = ${cfg.user}
    RUN_MODE = prod

    [database]
    DB_TYPE = ${cfg.database.type}
    HOST = ${cfg.database.host}:${toString cfg.database.port}
    NAME = ${cfg.database.name}
    USER = ${cfg.database.user}
    PASSWD = #dbpass#
    PATH = ${cfg.database.path}
    ${optionalString usePostgresql ''
      SSL_MODE = disable
    ''}

    [repository]
    ROOT = ${cfg.repositoryRoot}

    [server]
    DOMAIN = ${cfg.domain}
    HTTP_ADDR = ${cfg.httpAddress}
    HTTP_PORT = ${toString cfg.httpPort}
    ROOT_URL = ${cfg.rootUrl}
    STATIC_ROOT_PATH = ${cfg.staticRootPath}

    [session]
    COOKIE_NAME = session
    COOKIE_SECURE = ${boolToString cfg.cookieSecure}

    [security]
    SECRET_KEY = #secretkey#
    INSTALL_LOCK = true

    [log]
    ROOT_PATH = ${cfg.log.rootPath}
    LEVEL = ${cfg.log.level}

    ${cfg.extraConfig}
  '';
in

{
  options = {
    services.gitea = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = "Enable Gitea Service.";
      };

      package = mkOption {
        default = pkgs.gitea;
        type = types.package;
        defaultText = "pkgs.gitea";
        description = "gitea derivation to use";
      };

      useWizard = mkOption {
        default = false;
        type = types.bool;
        description = "Do not generate a configuration and use gitea' installation wizard instead. The first registered user will be administrator.";
      };

      stateDir = mkOption {
        default = "/var/lib/gitea";
        type = types.str;
        description = "gitea data directory.";
      };

      log = {
        rootPath = mkOption {
          default = "${cfg.stateDir}/log";
          type = types.str;
          description = "Root path for log files.";
        };
        level = mkOption {
          default = "Trace";
          type = types.enum [ "Trace" "Debug" "Info" "Warn" "Error" "Critical" ];
          description = "General log level.";
        };
      };

      user = mkOption {
        type = types.str;
        default = "gitea";
        description = "User account under which gitea runs.";
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
          default = (if !usePostgresql then 3306 else pg.port);
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
          description = ''
            The password corresponding to <option>database.user</option>.
            Warning: this is stored in cleartext in the Nix store!
            Use <option>database.passwordFile</option> instead.
          '';
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/gitea-dbpassword";
          description = ''
            A file containing the password corresponding to
            <option>database.user</option>.
          '';
        };

        path = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/data/gitea.db";
          description = "Path to the sqlite3 database file.";
        };

        createDatabase = mkOption {
          type = types.bool;
          default = true;
          description = ''
            Whether to create a local postgresql database automatically.
            This only applies if database type "postgres" is selected.
          '';
        };
      };

      dump = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = ''
            Enable a timer that runs gitea dump to generate backup-files of the
            current gitea database and repositories.
          '';
        };

        interval = mkOption {
          type = types.str;
          default = "04:31";
          example = "hourly";
          description = ''
            Run a gitea dump at this interval. Runs by default at 04:31 every day.

            The format is described in
            <citerefentry><refentrytitle>systemd.time</refentrytitle>
            <manvolnum>7</manvolnum></citerefentry>.
          '';
        };
      };

      appName = mkOption {
        type = types.str;
        default = "gitea: Gitea Service";
        description = "Application name.";
      };

      repositoryRoot = mkOption {
        type = types.str;
        default = "${cfg.stateDir}/repositories";
        description = "Path to the git repositories.";
      };

      domain = mkOption {
        type = types.str;
        default = "localhost";
        description = "Domain name of your server.";
      };

      rootUrl = mkOption {
        type = types.str;
        default = "http://localhost:3000/";
        description = "Full public URL of gitea server.";
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

      cookieSecure = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Marks session cookies as "secure" as a hint for browsers to only send
          them via HTTPS. This option is recommend, if gitea is being served over HTTPS.
        '';
      };

      staticRootPath = mkOption {
        type = types.str;
        default = "${gitea.data}";
        example = "/var/lib/gitea/data";
        description = "Upper level of template and static files path.";
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Configuration lines appended to the generated gitea configuration file.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.postgresql.enable = mkIf usePostgresql (mkDefault true);

    systemd.services.gitea = {
      description = "gitea";
      after = [ "network.target" "postgresql.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ gitea.bin ];

      preStart = let
        runConfig = "${cfg.stateDir}/custom/conf/app.ini";
        secretKey = "${cfg.stateDir}/custom/conf/secret_key";
      in ''
        # Make sure that the stateDir exists, as well as the conf dir in there
        mkdir -p ${cfg.stateDir}/conf

        # copy custom configuration and generate a random secret key if needed
        ${optionalString (cfg.useWizard == false) ''
          mkdir -p ${cfg.stateDir}/custom/conf
          cp -f ${configFile} ${runConfig}

          if [ ! -e ${secretKey} ]; then
              head -c 16 /dev/urandom | base64 > ${secretKey}
          fi

          KEY=$(head -n1 ${secretKey})
          DBPASS=$(head -n1 ${cfg.database.passwordFile})
          sed -e "s,#secretkey#,$KEY,g" \
              -e "s,#dbpass#,$DBPASS,g" \
              -i ${runConfig}
          chmod 640 ${runConfig} ${secretKey}
        ''}

        mkdir -p ${cfg.repositoryRoot}
        # update all hooks' binary paths
        HOOKS=$(find ${cfg.repositoryRoot} -mindepth 4 -maxdepth 6 -type f -wholename "*git/hooks/*")
        if [ "$HOOKS" ]
        then
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/gitea,${gitea.bin}/bin/gitea,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/env,${pkgs.coreutils}/bin/env,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/bash,${pkgs.bash}/bin/bash,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/perl,${pkgs.perl}/bin/perl,g' $HOOKS
        fi
        # If we have a folder or symlink with gitea locales, remove it
        if [ -e ${cfg.stateDir}/conf/locale ]
        then
          rm -r ${cfg.stateDir}/conf/locale
        fi
        # And symlink the current gitea locales in place
        ln -s ${gitea.out}/locale ${cfg.stateDir}/conf/locale
        # update command option in authorized_keys
        if [ -r ${cfg.stateDir}/.ssh/authorized_keys ]
        then
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/gitea,${gitea.bin}/bin/gitea,g' ${cfg.stateDir}/.ssh/authorized_keys
        fi
      '' + optionalString (usePostgresql && cfg.database.createDatabase) ''
        if ! test -e "${cfg.stateDir}/db-created"; then
          echo "CREATE ROLE ${cfg.database.user}
                  WITH ENCRYPTED PASSWORD '$(head -n1 ${cfg.database.passwordFile})'
                  NOCREATEDB NOCREATEROLE LOGIN"   |
            ${pkgs.sudo}/bin/sudo -u ${pg.superUser} ${pg.postgresqlPackage}/bin/psql
          ${pkgs.sudo}/bin/sudo -u ${pg.superUser} \
            ${pg.postgresqlPackage}/bin/createdb   \
            --owner=${cfg.database.user}           \
            --encoding=UTF8                        \
            --lc-collate=C                         \
            --lc-ctype=C                           \
            --template=template0                   \
            ${cfg.database.name}
          touch "${cfg.stateDir}/db-created"
        fi
      '' + ''
        chown ${cfg.user} -R ${cfg.stateDir}
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        WorkingDirectory = cfg.stateDir;
        PermissionsStartOnly = true;
        ExecStart = "${gitea.bin}/bin/gitea web";
        Restart = "always";
      };

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        GITEA_WORK_DIR = cfg.stateDir;
      };
    };

    users = mkIf (cfg.user == "gitea") {
      users.gitea = {
        description = "Gitea Service";
        home = cfg.stateDir;
        createHome = true;
        useDefaultShell = true;
      };
    };

    warnings = optional (cfg.database.password != "")
      ''config.services.gitea.database.password will be stored as plaintext
        in the Nix store. Use database.passwordFile instead.'';

    # Create database passwordFile default when password is configured.
    services.gitea.database.passwordFile =
      (mkDefault (toString (pkgs.writeTextFile {
        name = "gitea-database-password";
        text = cfg.database.password;
      })));

    systemd.services.gitea-dump = mkIf cfg.dump.enable {
       description = "gitea dump";
       after = [ "gitea.service" ];
       wantedBy = [ "default.target" ];
       path = [ gitea.bin ];

       environment = {
         USER = cfg.user;
         HOME = cfg.stateDir;
         GITEA_WORK_DIR = cfg.stateDir;
       };

       serviceConfig = {
         Type = "oneshot";
         User = cfg.user;
         ExecStart = "${gitea.bin}/bin/gitea dump";
         WorkingDirectory = cfg.stateDir;
       };
    };

    systemd.timers.gitea-dump = mkIf cfg.dump.enable {
      description = "Update timer for gitea-dump";
      partOf = [ "gitea-dump.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.dump.interval;
    };
  };
}
