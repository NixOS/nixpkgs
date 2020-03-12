{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.gitea;
  gitea = cfg.package;
  pg = config.services.postgresql;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
  useSqlite = cfg.database.type == "sqlite3";
  configFile = pkgs.writeText "app.ini" ''
    APP_NAME = ${cfg.appName}
    RUN_USER = ${cfg.user}
    RUN_MODE = prod

    [database]
    DB_TYPE = ${cfg.database.type}
    ${optionalString (usePostgresql || useMysql) ''
      HOST = ${if cfg.database.socket != null then cfg.database.socket else cfg.database.host + ":" + toString cfg.database.port}
      NAME = ${cfg.database.name}
      USER = ${cfg.database.user}
      PASSWD = #dbpass#
    ''}
    ${optionalString useSqlite ''
      PATH = ${cfg.database.path}
    ''}
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
    LFS_JWT_SECRET = #jwtsecret#

    [session]
    COOKIE_NAME = session
    COOKIE_SECURE = ${boolToString cfg.cookieSecure}

    [security]
    SECRET_KEY = #secretkey#
    INSTALL_LOCK = true

    [log]
    ROOT_PATH = ${cfg.log.rootPath}
    LEVEL = ${cfg.log.level}

    [service]
    DISABLE_REGISTRATION = ${boolToString cfg.disableRegistration}

    ${optionalString (cfg.mailerPasswordFile != null) ''
      [mailer]
      PASSWD = #mailerpass#
    ''}

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

        socket = mkOption {
          type = types.nullOr types.path;
          default = if (cfg.database.createDatabase && usePostgresql) then "/run/postgresql" else if (cfg.database.createDatabase && useMysql) then "/run/mysqld/mysqld.sock" else null;
          defaultText = "null";
          example = "/run/mysqld/mysqld.sock";
          description = "Path to the unix socket file to use for authentication.";
        };

        path = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/data/gitea.db";
          description = "Path to the sqlite3 database file.";
        };

        createDatabase = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to create a local database automatically.";
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

      mailerPasswordFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = "/var/lib/secrets/gitea/mailpw";
        description = "Path to a file containing the SMTP password.";
      };

      disableRegistration = mkEnableOption "the registration lock" // {
        description = ''
          By default any user can create an account on this <literal>gitea</literal> instance.
          This can be disabled by using this option.

          <emphasis>Note:</emphasis> please keep in mind that this should be added after the initial
          deploy unless <link linkend="opt-services.gitea.useWizard">services.gitea.useWizard</link>
          is <literal>true</literal> as the first registered user will be the administrator if
          no install wizard is used.
        '';
      };

      extraConfig = mkOption {
        type = types.str;
        default = "";
        description = "Configuration lines appended to the generated gitea configuration file.";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      { assertion = cfg.database.createDatabase -> cfg.database.user == cfg.user;
        message = "services.gitea.database.user must match services.gitea.user if the database is to be automatically provisioned";
      }
    ];

    services.postgresql = optionalAttrs (usePostgresql && cfg.database.createDatabase) {
      enable = mkDefault true;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.mysql = optionalAttrs (useMysql && cfg.database.createDatabase) {
      enable = mkDefault true;
      package = mkDefault pkgs.mariadb;

      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    systemd.tmpfiles.rules = [
      "d '${cfg.stateDir}' - ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/conf' - ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/custom' - ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/custom/conf' - ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/log' - ${cfg.user} gitea - -"
      "d '${cfg.repositoryRoot}' - ${cfg.user} gitea - -"
      "Z '${cfg.stateDir}' - ${cfg.user} gitea - -"

      # If we have a folder or symlink with gitea locales, remove it
      # And symlink the current gitea locales in place
      "L+ '${cfg.stateDir}/conf/locale' - - - - ${gitea.out}/locale"
    ];

    systemd.services.gitea = {
      description = "gitea";
      after = [ "network.target" ] ++ lib.optional usePostgresql "postgresql.service" ++ lib.optional useMysql "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ gitea.bin pkgs.gitAndTools.git ];

      preStart = let
        runConfig = "${cfg.stateDir}/custom/conf/app.ini";
        secretKey = "${cfg.stateDir}/custom/conf/secret_key";
        jwtSecret = "${cfg.stateDir}/custom/conf/jwt_secret";
      in ''
        # copy custom configuration and generate a random secret key if needed
        ${optionalString (cfg.useWizard == false) ''
          cp -f ${configFile} ${runConfig}

          if [ ! -e ${secretKey} ]; then
              ${gitea.bin}/bin/gitea generate secret SECRET_KEY > ${secretKey}
          fi

          if [ ! -e ${jwtSecret} ]; then
              ${gitea.bin}/bin/gitea generate secret LFS_JWT_SECRET > ${jwtSecret}
          fi

          KEY="$(head -n1 ${secretKey})"
          DBPASS="$(head -n1 ${cfg.database.passwordFile})"
          JWTSECRET="$(head -n1 ${jwtSecret})"
          ${if (cfg.mailerPasswordFile == null) then ''
            MAILERPASSWORD="#mailerpass#"
          '' else ''
            MAILERPASSWORD="$(head -n1 ${cfg.mailerPasswordFile} || :)"
          ''}
          sed -e "s,#secretkey#,$KEY,g" \
              -e "s,#dbpass#,$DBPASS,g" \
              -e "s,#jwtsecret#,$JWTSECRET,g" \
              -e "s,#mailerpass#,$MAILERPASSWORD,g" \
              -i ${runConfig}
          chmod 640 ${runConfig} ${secretKey} ${jwtSecret}
        ''}

        # update all hooks' binary paths
        HOOKS=$(find ${cfg.repositoryRoot} -mindepth 4 -maxdepth 6 -type f -wholename "*git/hooks/*")
        if [ "$HOOKS" ]
        then
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/gitea,${gitea.bin}/bin/gitea,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/env,${pkgs.coreutils}/bin/env,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/bash,${pkgs.bash}/bin/bash,g' $HOOKS
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/perl,${pkgs.perl}/bin/perl,g' $HOOKS
        fi

        # update command option in authorized_keys
        if [ -r ${cfg.stateDir}/.ssh/authorized_keys ]
        then
          sed -ri 's,/nix/store/[a-z0-9.-]+/bin/gitea,${gitea.bin}/bin/gitea,g' ${cfg.stateDir}/.ssh/authorized_keys
        fi
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = "gitea";
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${gitea.bin}/bin/gitea web";
        Restart = "always";

        # Filesystem
        ProtectHome = true;
        PrivateDevices = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ReadWritePaths = cfg.stateDir;
        # Caps
        CapabilityBoundingSet = "";
        NoNewPrivileges = true;
        # Misc.
        LockPersonality = true;
        RestrictRealtime = true;
        PrivateMounts = true;
        PrivateUsers = true;
        MemoryDenyWriteExecute = true;
        SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @raw-io @reboot @resources @setuid @swap";
        SystemCallArchitectures = "native";
        RestrictAddressFamilies = "AF_UNIX AF_INET AF_INET6";
      };

      environment = {
        USER = cfg.user;
        HOME = cfg.stateDir;
        GITEA_WORK_DIR = cfg.stateDir;
      };
    };

    users.users = mkIf (cfg.user == "gitea") {
      gitea = {
        description = "Gitea Service";
        home = cfg.stateDir;
        useDefaultShell = true;
        group = "gitea";
        isSystemUser = true;
      };
    };

    users.groups.gitea = {};

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
  meta.maintainers = with lib.maintainers; [ srhb ];
}
