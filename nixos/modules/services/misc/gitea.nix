{ config, lib, options, pkgs, ... }:

with lib;

let
  cfg = config.services.gitea;
  opt = options.services.gitea;
  gitea = cfg.package;
  pg = config.services.postgresql;
  useMysql = cfg.database.type == "mysql";
  usePostgresql = cfg.database.type == "postgres";
  useSqlite = cfg.database.type == "sqlite3";
  configFile = pkgs.writeText "app.ini" ''
    APP_NAME = ${cfg.appName}
    RUN_USER = ${cfg.user}
    RUN_MODE = prod

    ${generators.toINI {} cfg.settings}

    ${optionalString (cfg.extraConfig != null) cfg.extraConfig}
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
        defaultText = literalExpression "pkgs.gitea";
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
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/log"'';
          type = types.str;
          description = "Root path for log files.";
        };
        level = mkOption {
          default = "Info";
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
          type = types.port;
          default = (if !usePostgresql then 3306 else pg.port);
          defaultText = literalExpression ''
            if config.${opt.database.type} != "postgresql"
            then 3306
            else config.${options.services.postgresql.port}
          '';
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
          defaultText = literalExpression "null";
          example = "/run/mysqld/mysqld.sock";
          description = "Path to the unix socket file to use for authentication.";
        };

        path = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/data/gitea.db";
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/data/gitea.db"'';
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

        backupDir = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/dump";
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/dump"'';
          description = "Path to the dump files.";
        };

        type = mkOption {
          type = types.enum [ "zip" "rar" "tar" "sz" "tar.gz" "tar.xz" "tar.bz2" "tar.br" "tar.lz4" ];
          default = "zip";
          description = "Archive format used to store the dump file.";
        };

        file = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Filename to be used for the dump. If `null` a default name is choosen by gitea.";
          example = "gitea-dump";
        };
      };

      ssh = {
        enable = mkOption {
          type = types.bool;
          default = true;
          description = "Enable external SSH feature.";
        };

        clonePort = mkOption {
          type = types.int;
          default = 22;
          example = 2222;
          description = ''
            SSH port displayed in clone URL.
            The option is required to configure a service when the external visible port
            differs from the local listening port i.e. if port forwarding is used.
          '';
        };
      };

      lfs = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Enables git-lfs support.";
        };

        contentDir = mkOption {
          type = types.str;
          default = "${cfg.stateDir}/data/lfs";
          defaultText = literalExpression ''"''${config.${opt.stateDir}}/data/lfs"'';
          description = "Where to store LFS files.";
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
        defaultText = literalExpression ''"''${config.${opt.stateDir}}/repositories"'';
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

      enableUnixSocket = mkOption {
        type = types.bool;
        default = false;
        description = "Configure Gitea to listen on a unix socket instead of the default TCP port.";
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
        type = types.either types.str types.path;
        default = gitea.data;
        defaultText = literalExpression "package.data";
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

      settings = mkOption {
        type = with types; attrsOf (attrsOf (oneOf [ bool int str ]));
        default = {};
        description = ''
          Gitea configuration. Refer to <link xlink:href="https://docs.gitea.io/en-us/config-cheat-sheet/"/>
          for details on supported values.
        '';
        example = literalExpression ''
          {
            "cron.sync_external_users" = {
              RUN_AT_START = true;
              SCHEDULE = "@every 24h";
              UPDATE_EXISTING = true;
            };
            mailer = {
              ENABLED = true;
              MAILER_TYPE = "sendmail";
              FROM = "do-not-reply@example.org";
              SENDMAIL_PATH = "''${pkgs.system-sendmail}/bin/sendmail";
            };
            other = {
              SHOW_FOOTER_VERSION = false;
            };
          }
        '';
      };

      extraConfig = mkOption {
        type = with types; nullOr str;
        default = null;
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

    services.gitea.settings = {
      database = mkMerge [
        {
          DB_TYPE = cfg.database.type;
        }
        (mkIf (useMysql || usePostgresql) {
          HOST = if cfg.database.socket != null then cfg.database.socket else cfg.database.host + ":" + toString cfg.database.port;
          NAME = cfg.database.name;
          USER = cfg.database.user;
          PASSWD = "#dbpass#";
        })
        (mkIf useSqlite {
          PATH = cfg.database.path;
        })
        (mkIf usePostgresql {
          SSL_MODE = "disable";
        })
      ];

      repository = {
        ROOT = cfg.repositoryRoot;
      };

      server = mkMerge [
        {
          DOMAIN = cfg.domain;
          STATIC_ROOT_PATH = toString cfg.staticRootPath;
          LFS_JWT_SECRET = "#lfsjwtsecret#";
          ROOT_URL = cfg.rootUrl;
        }
        (mkIf cfg.enableUnixSocket {
          PROTOCOL = "unix";
          HTTP_ADDR = "/run/gitea/gitea.sock";
        })
        (mkIf (!cfg.enableUnixSocket) {
          HTTP_ADDR = cfg.httpAddress;
          HTTP_PORT = cfg.httpPort;
        })
        (mkIf cfg.ssh.enable {
          DISABLE_SSH = false;
          SSH_PORT = cfg.ssh.clonePort;
        })
        (mkIf (!cfg.ssh.enable) {
          DISABLE_SSH = true;
        })
        (mkIf cfg.lfs.enable {
          LFS_START_SERVER = true;
          LFS_CONTENT_PATH = cfg.lfs.contentDir;
        })

      ];

      session = {
        COOKIE_NAME = "session";
        COOKIE_SECURE = cfg.cookieSecure;
      };

      security = {
        SECRET_KEY = "#secretkey#";
        INTERNAL_TOKEN = "#internaltoken#";
        INSTALL_LOCK = true;
      };

      log = {
        ROOT_PATH = cfg.log.rootPath;
        LEVEL = cfg.log.level;
      };

      service = {
        DISABLE_REGISTRATION = cfg.disableRegistration;
      };

      mailer = mkIf (cfg.mailerPasswordFile != null) {
        PASSWD = "#mailerpass#";
      };

      oauth2 = {
        JWT_SECRET = "#oauth2jwtsecret#";
      };
    };

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
      "d '${cfg.dump.backupDir}' 0750 ${cfg.user} gitea - -"
      "z '${cfg.dump.backupDir}' 0750 ${cfg.user} gitea - -"
      "Z '${cfg.dump.backupDir}' - ${cfg.user} gitea - -"
      "d '${cfg.lfs.contentDir}' 0750 ${cfg.user} gitea - -"
      "z '${cfg.lfs.contentDir}' 0750 ${cfg.user} gitea - -"
      "Z '${cfg.lfs.contentDir}' - ${cfg.user} gitea - -"
      "d '${cfg.repositoryRoot}' 0750 ${cfg.user} gitea - -"
      "z '${cfg.repositoryRoot}' 0750 ${cfg.user} gitea - -"
      "Z '${cfg.repositoryRoot}' - ${cfg.user} gitea - -"
      "d '${cfg.stateDir}' 0750 ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/conf' 0750 ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/custom' 0750 ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/custom/conf' 0750 ${cfg.user} gitea - -"
      "d '${cfg.stateDir}/log' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/.ssh' 0700 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/conf' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/custom' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/custom/conf' 0750 ${cfg.user} gitea - -"
      "z '${cfg.stateDir}/log' 0750 ${cfg.user} gitea - -"
      "Z '${cfg.stateDir}' - ${cfg.user} gitea - -"

      # If we have a folder or symlink with gitea locales, remove it
      # And symlink the current gitea locales in place
      "L+ '${cfg.stateDir}/conf/locale' - - - - ${gitea.out}/locale"
    ];

    systemd.services.gitea = {
      description = "gitea";
      after = [ "network.target" ] ++ lib.optional usePostgresql "postgresql.service" ++ lib.optional useMysql "mysql.service";
      wantedBy = [ "multi-user.target" ];
      path = [ gitea pkgs.git ];

      # In older versions the secret naming for JWT was kind of confusing.
      # The file jwt_secret hold the value for LFS_JWT_SECRET and JWT_SECRET
      # wasn't persistant at all.
      # To fix that, there is now the file oauth2_jwt_secret containing the
      # values for JWT_SECRET and the file jwt_secret gets renamed to
      # lfs_jwt_secret.
      # We have to consider this to stay compatible with older installations.
      preStart = let
        runConfig = "${cfg.stateDir}/custom/conf/app.ini";
        secretKey = "${cfg.stateDir}/custom/conf/secret_key";
        oauth2JwtSecret = "${cfg.stateDir}/custom/conf/oauth2_jwt_secret";
        oldLfsJwtSecret = "${cfg.stateDir}/custom/conf/jwt_secret"; # old file for LFS_JWT_SECRET
        lfsJwtSecret = "${cfg.stateDir}/custom/conf/lfs_jwt_secret"; # new file for LFS_JWT_SECRET
        internalToken = "${cfg.stateDir}/custom/conf/internal_token";
      in ''
        # copy custom configuration and generate a random secret key if needed
        ${optionalString (cfg.useWizard == false) ''
          function gitea_setup {
            cp -f ${configFile} ${runConfig}

            if [ ! -e ${secretKey} ]; then
                ${gitea}/bin/gitea generate secret SECRET_KEY > ${secretKey}
            fi

            # Migrate LFS_JWT_SECRET filename
            if [[ -e ${oldLfsJwtSecret} && ! -e ${lfsJwtSecret} ]]; then
                mv ${oldLfsJwtSecret} ${lfsJwtSecret}
            fi

            if [ ! -e ${oauth2JwtSecret} ]; then
                ${gitea}/bin/gitea generate secret JWT_SECRET > ${oauth2JwtSecret}
            fi

            if [ ! -e ${lfsJwtSecret} ]; then
                ${gitea}/bin/gitea generate secret LFS_JWT_SECRET > ${lfsJwtSecret}
            fi

            if [ ! -e ${internalToken} ]; then
                ${gitea}/bin/gitea generate secret INTERNAL_TOKEN > ${internalToken}
            fi

            SECRETKEY="$(head -n1 ${secretKey})"
            DBPASS="$(head -n1 ${cfg.database.passwordFile})"
            OAUTH2JWTSECRET="$(head -n1 ${oauth2JwtSecret})"
            LFSJWTSECRET="$(head -n1 ${lfsJwtSecret})"
            INTERNALTOKEN="$(head -n1 ${internalToken})"
            ${if (cfg.mailerPasswordFile == null) then ''
              MAILERPASSWORD="#mailerpass#"
            '' else ''
              MAILERPASSWORD="$(head -n1 ${cfg.mailerPasswordFile} || :)"
            ''}
            sed -e "s,#secretkey#,$SECRETKEY,g" \
                -e "s,#dbpass#,$DBPASS,g" \
                -e "s,#oauth2jwtsecret#,$OAUTH2JWTSECRET,g" \
                -e "s,#lfsjwtsecret#,$LFSJWTSECRET,g" \
                -e "s,#internaltoken#,$INTERNALTOKEN,g" \
                -e "s,#mailerpass#,$MAILERPASSWORD,g" \
                -i ${runConfig}
          }
          (umask 027; gitea_setup)
        ''}

        # run migrations/init the database
        ${gitea}/bin/gitea migrate

        # update all hooks' binary paths
        ${gitea}/bin/gitea admin regenerate hooks

        # update command option in authorized_keys
        if [ -r ${cfg.stateDir}/.ssh/authorized_keys ]
        then
          ${gitea}/bin/gitea admin regenerate keys
        fi
      '';

      serviceConfig = {
        Type = "simple";
        User = cfg.user;
        Group = "gitea";
        WorkingDirectory = cfg.stateDir;
        ExecStart = "${gitea}/bin/gitea web --pid /run/gitea/gitea.pid";
        Restart = "always";
        # Runtime directory and mode
        RuntimeDirectory = "gitea";
        RuntimeDirectoryMode = "0755";
        # Access write directories
        ReadWritePaths = [ cfg.dump.backupDir cfg.repositoryRoot cfg.stateDir cfg.lfs.contentDir ];
        UMask = "0027";
        # Capabilities
        CapabilityBoundingSet = "";
        # Security
        NoNewPrivileges = true;
        # Sandboxing
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        ProtectHostname = true;
        ProtectClock = true;
        ProtectKernelTunables = true;
        ProtectKernelModules = true;
        ProtectKernelLogs = true;
        ProtectControlGroups = true;
        RestrictAddressFamilies = [ "AF_UNIX AF_INET AF_INET6" ];
        LockPersonality = true;
        MemoryDenyWriteExecute = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        PrivateMounts = true;
        # System Call Filtering
        SystemCallArchitectures = "native";
        SystemCallFilter = "~@clock @cpu-emulation @debug @keyring @memlock @module @mount @obsolete @raw-io @reboot @resources @setuid @swap";
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

    warnings =
      optional (cfg.database.password != "") "config.services.gitea.database.password will be stored as plaintext in the Nix store. Use database.passwordFile instead." ++
      optional (cfg.extraConfig != null) ''
        services.gitea.`extraConfig` is deprecated, please use services.gitea.`settings`.
      '';

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
       path = [ gitea ];

       environment = {
         USER = cfg.user;
         HOME = cfg.stateDir;
         GITEA_WORK_DIR = cfg.stateDir;
       };

       serviceConfig = {
         Type = "oneshot";
         User = cfg.user;
         ExecStart = "${gitea}/bin/gitea dump --type ${cfg.dump.type}" + optionalString (cfg.dump.file != null) " --file ${cfg.dump.file}";
         WorkingDirectory = cfg.dump.backupDir;
       };
    };

    systemd.timers.gitea-dump = mkIf cfg.dump.enable {
      description = "Update timer for gitea-dump";
      partOf = [ "gitea-dump.service" ];
      wantedBy = [ "timers.target" ];
      timerConfig.OnCalendar = cfg.dump.interval;
    };
  };
  meta.maintainers = with lib.maintainers; [ srhb ma27 ];
}
