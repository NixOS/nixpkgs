{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.seafile;
  settingsFormat = pkgs.formats.ini { };
  filterNull = lib.attrsets.filterAttrsRecursive (k: v: v != null);

  ccnetConf = settingsFormat.generate "ccnet.conf" (filterNull cfg.ccnetSettings);

  seafileConf = settingsFormat.generate "seafile.conf" (filterNull cfg.seafileSettings);

  seahubDatabaseJson = builtins.toJSON (filterNull {
    default = {
      ENGINE = "django.db.backends.mysql";
      NAME = cfg.database.seahubName;
      HOST = lib.concatStrings (
        builtins.filter (v: v != null) [
          cfg.database.unixSocket
          cfg.database.host
        ]
      );
      PORT = cfg.database.port;
      USER = cfg.database.user;
      # password is read programatically below
    };
  });

  seahubSettings =
    pkgs.writeText "seahub_settings.py" ''
      FILE_SERVER_ROOT = '${cfg.ccnetSettings.General.SERVICE_URL}/seafhttp'
      DATABASES = ${seahubDatabaseJson}
      MEDIA_ROOT = '${seahubDir}/media/'
      THUMBNAIL_ROOT = '${seahubDir}/thumbnail/'

      SERVICE_URL = '${cfg.ccnetSettings.General.SERVICE_URL}'

      CSRF_TRUSTED_ORIGINS = ["${cfg.ccnetSettings.General.SERVICE_URL}"]

      with open('${seafRoot}/.seahubSecret') as f:
          SECRET_KEY = f.readline().rstrip()

    ''
    + (lib.optionalString (cfg.database.passwordFile != null) ''
      import configparser
      passwordConfig = configparser.ConfigParser()
      passwordConfig.read('${cfg.database.passwordFile}')
      DATABASES.default.password = passwordConfig['client']['password']
    '')
    + cfg.seahubExtraConf;

  seafRoot = "/var/lib/seafile";
  ccnetDir = "${seafRoot}/ccnet";
  seahubDir = "${seafRoot}/seahub";
  defaultUser = "seafile";

in
{

  ###### Interface

  options.services.seafile = {
    enable = mkEnableOption "Seafile server";

    ccnetSettings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          General = {
            SERVICE_URL = mkOption {
              type = types.singleLineStr;
              example = "https://www.example.com";
              description = ''
                Seahub public URL.
              '';
            };
          };
          Database = {
            ENGINE = mkOption {
              type = types.str;
              default = "mysql";
              visible = false;
            };
            UNIX_SOCKET = mkOption {
              type = types.nullOr types.str;
              default = cfg.database.unixSocket;
              visible = false;
            };
            HOST = mkOption {
              type = types.nullOr types.str;
              default = cfg.database.host;
              visible = false;
            };
            PORT = mkOption {
              type = types.nullOr types.str;
              default = cfg.database.port;
              visible = false;
            };
            USER = mkOption {
              type = types.nullOr types.str;
              default = cfg.database.user;
              visible = false;
            };
            # PASSWD = mkOption {
            #   type = types.nullOr types.str;
            #   default = cfg.database.password;
            #   visible = false;
            # };
            DB = mkOption {
              type = types.nullOr types.str;
              default = cfg.database.ccnetName;
              visible = false;
            };
            CONNECTION_CHARSET = mkOption {
              type = types.str;
              default = "utf8";
              visible = false;
            };
          };
        };
      };
      default = { };
      description = ''
        Configuration for ccnet, see
        <https://manual.seafile.com/config/ccnet-conf/>
        for supported values.
      '';
    };

    seafileSettings = mkOption {
      type = types.submodule {
        freeformType = settingsFormat.type;

        options = {
          fileserver = {
            port = mkOption {
              type = types.port;
              default = 8082;
              description = ''
                The tcp port used by seafile fileserver.
              '';
            };
            host = mkOption {
              type = types.singleLineStr;
              default = "ipv4:127.0.0.1";
              example = "unix:/run/seafile/server.sock";
              description = ''
                The binding address used by seafile fileserver.

                The addr can be defined as one of the following:
                ipv6:<ipv6addr> for binding to an IPv6 address.
                unix:<named pipe> for binding to a unix named socket
                ipv4:<ipv4addr> for binding to an ipv4 address
                Otherwise the addr is assumed to be ipv4.
              '';
            };
          };
          database = {
            type = mkOption {
              type = types.str;
              default = "mysql";
              visible = false;
            };
            unix_socket = mkOption {
              type = types.nullOr types.str;
              default = cfg.database.unixSocket;
              visible = false;
            };
            host = mkOption {
              type = types.nullOr types.str;
              default = cfg.database.host;
              visible = false;
            };
            port = mkOption {
              type = types.nullOr types.str;
              default = cfg.database.port;
              visible = false;
            };
            user = mkOption {
              type = types.nullOr types.str;
              default = cfg.database.user;
              visible = false;
            };
            # password = mkOption {
            #   type = types.nullOr types.str;
            #   default = cfg.database.password;
            #   visible = false;
            # };
            db_name = mkOption {
              type = types.nullOr types.str;
              default = cfg.database.seafileName;
              visible = false;
            };
            connection_charset = mkOption {
              type = types.str;
              default = "utf8";
              visible = false;
            };
          };
        };
      };
      default = { };
      description = ''
        Configuration for seafile-server, see
        <https://manual.seafile.com/config/seafile-conf/>
        for supported values.
      '';
    };

    seahubAddress = lib.mkOption {
      type = types.singleLineStr;
      default = "unix:/run/seahub/gunicorn.sock";
      example = "[::1]:8083";
      description = ''
        Which address to bind the seahub server to, of the form:
        HOST, HOST:PORT, unix:PATH.
        IPv6 HOSTs must be wrapped in brackets.
      '';
    };

    workers = mkOption {
      type = types.int;
      default = 4;
      example = 10;
      description = ''
        The number of gunicorn worker processes for handling requests.
      '';
    };

    adminEmail = mkOption {
      example = "john@example.com";
      type = types.singleLineStr;
      description = ''
        Seafile Seahub Admin Account Email.
      '';
    };

    initialAdminPassword = mkOption {
      example = "someStrongPass";
      type = types.singleLineStr;
      description = ''
        Seafile Seahub Admin Account initial password.
        Should be changed via Seahub web front-end.
      '';
    };

    seahubPackage = mkPackageOption pkgs "seahub" { };

    user = mkOption {
      type = types.singleLineStr;
      default = defaultUser;
      description = "User account under which seafile runs.";
    };

    group = mkOption {
      type = types.singleLineStr;
      default = defaultUser;
      description = "Group under which seafile runs.";
    };

    database = {
      unixSocket = mkOption {
        type = types.nullOr types.path;
        default = "/var/run/mysqld/mysqld.sock";
        description = "Path to the MySQL unix socket.";
      };
      host = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Hostname of the MySQL server.";
      };
      port = mkOption {
        type = types.nullOr types.port;
        default = null;
        description = "Port of the MySQL server to connect to.";
      };
      user = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = ''
          MySQL user to authenticate as.
          Optional when connecting with the unix socket.
        '';
      };
      passwordFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = ''
          Path to a MySQL option file containing the password for the MySQL user, in INI format.
          Example:
          ```
          [client]
          password=mysupersecurepassword
          ```
        '';
      };
      createLocally = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to enable a MySQL server locally and create the required databases.
          It is recommended to leave the connection and authentication options
          at their defaults when using this option.
        '';
      };
      ccnetName = mkOption {
        type = types.str;
        default = "ccnet_db";
        description = "Database to use for ccnet data";
      };
      seafileName = mkOption {
        type = types.str;
        default = "seafile_db";
        description = "Database to use for seafile-server data";
      };
      seahubName = mkOption {
        type = types.str;
        default = "seahub_db";
        description = "Database to use for seahub data";
      };
    };

    dataDir = mkOption {
      type = types.path;
      default = "${seafRoot}/data";
      description = "Path in which to store user data";
    };

    gc = {
      enable = mkEnableOption "automatic garbage collection on stored data blocks.";

      dates = mkOption {
        type = types.listOf types.singleLineStr;
        default = [ "Sun 03:00:00" ];
        description = ''
          When to run garbage collection on stored data blocks.
          The time format is described in {manpage}`systemd.time(7)`.
        '';
      };

      randomizedDelaySec = lib.mkOption {
        default = "0";
        type = types.singleLineStr;
        example = "45min";
        description = ''
          Add a randomized delay before each garbage collection.
          The delay will be chosen between zero and this value.
          This value must be a time span in the format specified by
          {manpage}`systemd.time(7)`
        '';
      };

      persistent = lib.mkOption {
        default = true;
        type = types.bool;
        example = false;
        description = ''
          Takes a boolean argument. If true, the time when the service
          unit was last triggered is stored on disk. When the timer is
          activated, the service unit is triggered immediately if it
          would have been triggered at least once during the time when
          the timer was inactive. Such triggering is nonetheless
          subject to the delay imposed by RandomizedDelaySec=. This is
          useful to catch up on missed runs of the service when the
          system was powered down.
        '';
      };
    };

    seahubExtraConf = mkOption {
      default = "";
      example = ''
        CSRF_TRUSTED_ORIGINS = ["https://example.com"]
      '';
      type = types.lines;
      description = ''
        Extra config to append to `seahub_settings.py` file.
        Refer to <https://manual.seafile.com/config/seahub_settings_py/>
        for all available options.
      '';
    };
  };

  ###### Implementation

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.unixSocket != null || cfg.database.host != null;
        message = "One of services.seafile.database.unixSocket or services.seafile.database.host must be set";
      }
      {
        assertion = cfg.database.unixSocket == null || cfg.database.host == null;
        message = "services.seafile.database.unixSocket and services.seafile.database.host cannot both be set";
      }
      {
        assertion = cfg.database.host != null -> cfg.database.port != null;
        message = "services.seafile.database.port must be set when using a remote database server";
      }
      {
        assertion = cfg.database.host != null -> cfg.database.user != null && cfg.database.password != null;
        message = "services.seafile.database.user and services.seafile.database.password must be set when using a remote database server";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.unixSocket != null;
        message = "services.seafile.database.unixSocket must be set if services.seafile.database.createLocally is set true";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.user == null;
        message = "services.seafile.database.user must not be set if services.seafile.database.createLocally is set true";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.seafile.database.createLocally is set to true";
      }
    ];

    services.mysql = mkIf cfg.database.createLocally {
      enable = true;
      package = lib.mkDefault pkgs.mariadb;
      ensureDatabases = [
        cfg.database.ccnetName
        cfg.database.seafileName
        cfg.database.seahubName
      ];
      ensureUsers = [
        {
          name = cfg.user;
          ensurePermissions = {
            "${cfg.database.ccnetName}.*" = "ALL PRIVILEGES";
            "${cfg.database.seafileName}.*" = "ALL PRIVILEGES";
            "${cfg.database.seahubName}.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };

    environment.etc."seafile/ccnet.conf".source = ccnetConf;
    environment.etc."seafile/seafile.conf".source = seafileConf;
    environment.etc."seafile/seahub_settings.py".source = seahubSettings;

    users.users = lib.optionalAttrs (cfg.user == defaultUser) {
      "${defaultUser}" = {
        group = cfg.group;
        isSystemUser = true;
      };
    };

    users.groups = lib.optionalAttrs (cfg.group == defaultUser) { "${defaultUser}" = { }; };

    systemd.targets.seafile = {
      wantedBy = [ "multi-user.target" ];
      description = "Seafile components";
    };

    systemd.services =
      let
        serviceOptions = {
          ProtectHome = true;
          PrivateUsers = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectClock = true;
          ProtectHostname = true;
          ProtectProc = "invisible";
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectKernelLogs = true;
          ProtectControlGroups = true;
          RestrictNamespaces = true;
          RemoveIPC = true;
          LockPersonality = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          NoNewPrivileges = true;
          MemoryDenyWriteExecute = true;
          SystemCallArchitectures = "native";
          RestrictAddressFamilies = [
            "AF_UNIX"
            "AF_INET"
          ];

          User = cfg.user;
          Group = cfg.group;
          StateDirectory = "seafile";
          RuntimeDirectory = "seafile";
          LogsDirectory = "seafile";
          ConfigurationDirectory = "seafile";
          ReadWritePaths = lib.lists.optional (cfg.dataDir != "${seafRoot}/data") cfg.dataDir;
        };

        mysqlServer = lib.lists.optional cfg.database.createLocally "mysql.service";
        mysqlCommand = lib.strings.concatStrings [
          "${pkgs.mysql-client}/bin/mysql"
          (lib.optionalString (cfg.database.unixSocket != null) " --socket=${cfg.database.unixSocket}")
          (lib.optionalString (cfg.database.host != null) " --host=${cfg.database.host}")
          (lib.optionalString (cfg.database.port != null) " --port=${cfg.database.port}")
          (lib.optionalString (cfg.database.user != null) " --user=${cfg.database.user}")
          (lib.optionalString (
            cfg.database.passwordFile != null
          ) " --defaults-extra-file==${cfg.database.passwordFile}")
        ];
      in
      {
        seaf-server = {
          description = "Seafile server";
          partOf = [ "seafile.target" ];
          unitConfig.RequiresMountsFor = lib.lists.optional (cfg.dataDir != "${seafRoot}/data") cfg.dataDir;
          requires = mysqlServer;
          after = [ "network.target" ] ++ mysqlServer;
          wantedBy = [ "seafile.target" ];
          restartTriggers = [
            ccnetConf
            seafileConf
          ];
          serviceConfig = serviceOptions // {
            ExecStart = ''
              ${lib.getExe cfg.seahubPackage.seafile-server} \
              --foreground \
              -F /etc/seafile \
              -c ${ccnetDir} \
              -d ${cfg.dataDir} \
              -l /var/log/seafile/server.log \
              -P /run/seafile/server.pid \
              -p /run/seafile
            '';
          };
          preStart = ''
            if [ ! -f "${seafRoot}/server-setup" ]; then
                mkdir -p ${cfg.dataDir}/library-template
                # Load schema on first install
                ${mysqlCommand} --database=${cfg.database.ccnetName} < ${cfg.seahubPackage.seafile-server}/share/seafile/sql/mysql/ccnet.sql
                ${mysqlCommand} --database=${cfg.database.seafileName} < ${cfg.seahubPackage.seafile-server}/share/seafile/sql/mysql/seafile.sql
                echo "${cfg.seahubPackage.seafile-server.version}-mysql" > "${seafRoot}"/server-setup
                echo Loaded MySQL schemas for first install
            fi
            # checking for upgrades and handling them
            installedMajor=$(cat "${seafRoot}/server-setup" | cut -d"-" -f1 | cut -d"." -f1)
            installedMinor=$(cat "${seafRoot}/server-setup" | cut -d"-" -f1 | cut -d"." -f2)
            pkgMajor=$(echo "${cfg.seahubPackage.seafile-server.version}" | cut -d"." -f1)
            pkgMinor=$(echo "${cfg.seahubPackage.seafile-server.version}" | cut -d"." -f2)

            if [[ $installedMajor == $pkgMajor && $installedMinor == $pkgMinor ]]; then
               :
            elif [[ $installedMajor == 10 && $installedMinor == 0 && $pkgMajor == 11 && $pkgMinor == 0 ]]; then
                # Upgrade from 10.0 to 11.0: migrate to mysql
                echo Migrating from version 10 to 11

                # From https://github.com/haiwen/seahub/blob/e12f941bfef7191795d8c72a7d339c01062964b2/scripts/sqlite2mysql.sh

                echo Migrating ccnet database to MySQL
                ${lib.getExe pkgs.sqlite} ${ccnetDir}/PeerMgr/usermgr.db ".dump" | \
                  ${lib.getExe cfg.seahubPackage.python3} ${cfg.seahubPackage}/scripts/sqlite2mysql.py > ${ccnetDir}/ccnet.sql
                ${lib.getExe pkgs.sqlite} ${ccnetDir}/GroupMgr/groupmgr.db ".dump" | \
                  ${lib.getExe cfg.seahubPackage.python3} ${cfg.seahubPackage}/scripts/sqlite2mysql.py >> ${ccnetDir}/ccnet.sql
                sed 's/ctime INTEGER/ctime BIGINT/g' -i ${ccnetDir}/ccnet.sql
                sed 's/email TEXT, role TEXT/email VARCHAR(255), role TEXT/g' -i ${ccnetDir}/ccnet.sql
                ${mysqlCommand} --database=${cfg.database.ccnetName} < ${ccnetDir}/ccnet.sql

                echo Migrating seafile database to MySQL
                ${lib.getExe pkgs.sqlite} ${cfg.dataDir}/seafile.db ".dump" | \
                  ${lib.getExe cfg.seahubPackage.python3} ${cfg.seahubPackage}/scripts/sqlite2mysql.py > ${cfg.dataDir}/seafile.sql
                sed 's/owner_id TEXT/owner_id VARCHAR(255)/g' -i ${cfg.dataDir}/seafile.sql
                sed 's/user_name TEXT/user_name VARCHAR(255)/g' -i ${cfg.dataDir}/seafile.sql
                ${mysqlCommand} --database=${cfg.database.seafileName} < ${cfg.dataDir}/seafile.sql

                echo Migrating seahub database to MySQL
                echo 'SET FOREIGN_KEY_CHECKS=0;' > ${seahubDir}/seahub.sql
                ${lib.getExe pkgs.sqlite} ${seahubDir}/seahub.db ".dump" | \
                  ${lib.getExe cfg.seahubPackage.python3} ${cfg.seahubPackage}/scripts/sqlite2mysql.py >> ${seahubDir}/seahub.sql
                sed 's/`permission` , `reporter` text NOT NULL/`permission` longtext NOT NULL/g' -i ${seahubDir}/seahub.sql
                sed 's/varchar(256) NOT NULL UNIQUE/varchar(255) NOT NULL UNIQUE/g' -i ${seahubDir}/seahub.sql
                sed 's/,    UNIQUE (`user_email`, `contact_email`)//g' -i ${seahubDir}/seahub.sql
                sed '/INSERT INTO `base_dirfileslastmodifiedinfo`/d' -i ${seahubDir}/seahub.sql
                sed '/INSERT INTO `notifications_usernotification`/d' -i ${seahubDir}/seahub.sql
                sed 's/DEFERRABLE INITIALLY DEFERRED//g' -i ${seahubDir}/seahub.sql
                ${mysqlCommand} --database=${cfg.database.seahubName} < ${seahubDir}/seahub.sql

                echo "${cfg.seahubPackage.seafile-server.version}-mysql" > "${seafRoot}"/server-setup
                echo Migration complete
            else
                echo "Unsupported upgrade: $installedMajor.$installedMinor to $pkgMajor.$pkgMinor" >&2
                exit 1
            fi
          '';

          postStart = ''
            # Fix unix socket permissions
            host="${cfg.seafileSettings.fileserver.host}"
            if [[ "''${host:0:5}" =~ ^unix:.* ]]; then
              while [[ ! -S "''${host:5}" ]]; do sleep 1; done
              chmod 666 "''${host:5}"
            fi
          '';
        };

        seahub = {
          description = "Seafile Server Web Frontend";
          wantedBy = [ "seafile.target" ];
          partOf = [ "seafile.target" ];
          unitConfig.RequiresMountsFor = lib.lists.optional (cfg.dataDir != "${seafRoot}/data") cfg.dataDir;
          requires = [ "seaf-server.service" ] ++ mysqlServer;
          after = [
            "network.target"
            "seaf-server.service"
          ] ++ mysqlServer;
          restartTriggers = [ seahubSettings ];
          environment = {
            PYTHONPATH = "${cfg.seahubPackage.pythonPath}:${cfg.seahubPackage}/thirdpart:${cfg.seahubPackage}";
            DJANGO_SETTINGS_MODULE = "seahub.settings";
            CCNET_CONF_DIR = ccnetDir;
            SEAFILE_CONF_DIR = cfg.dataDir;
            SEAFILE_CENTRAL_CONF_DIR = "/etc/seafile";
            SEAFILE_RPC_PIPE_PATH = "/run/seafile";
            SEAHUB_LOG_DIR = "/var/log/seafile";
          };
          serviceConfig = serviceOptions // {
            RuntimeDirectory = "seahub";
            ExecStart = ''
              ${lib.getExe cfg.seahubPackage.python3.pkgs.gunicorn} seahub.wsgi:application \
              --name seahub \
              --workers ${toString cfg.workers} \
              --log-level=info \
              --preload \
              --timeout=1200 \
              --limit-request-line=8190 \
              --bind ${cfg.seahubAddress}
            '';
          };
          preStart = ''
            mkdir -p ${seahubDir}/media
            # Link all media except avatars
            for m in `find ${cfg.seahubPackage}/media/ -maxdepth 1 -not -name "avatars"`; do
              ln -sf $m ${seahubDir}/media/
            done
            if [ ! -e "${seafRoot}/.seahubSecret" ]; then
                (
                  umask 377 &&
                  ${lib.getExe cfg.seahubPackage.python3} ${cfg.seahubPackage}/tools/secret_key_generator.py > ${seafRoot}/.seahubSecret
                )
            fi
            if [ ! -f "${seafRoot}/seahub-setup" ]; then
                # avatars directory should be writable
                install -D -t ${seahubDir}/media/avatars/ ${cfg.seahubPackage}/media/avatars/default.png
                install -D -t ${seahubDir}/media/avatars/groups ${cfg.seahubPackage}/media/avatars/groups/default.png
                # init database
                ${cfg.seahubPackage}/manage.py migrate
                # create admin account
                ${lib.getExe pkgs.expect} -c 'spawn ${cfg.seahubPackage}/manage.py createsuperuser --email=${cfg.adminEmail}; expect "Password: "; send "${cfg.initialAdminPassword}\r"; expect "Password (again): "; send "${cfg.initialAdminPassword}\r"; expect "Superuser created successfully."'
                echo "${cfg.seahubPackage.version}-mysql" > "${seafRoot}/seahub-setup"
            fi
            if [ $(cat "${seafRoot}/seahub-setup" | cut -d"-" -f1) != "${pkgs.seahub.version}" ]; then
                # run django migrations
                ${cfg.seahubPackage}/manage.py migrate
                echo "${cfg.seahubPackage.version}-mysql" > "${seafRoot}/seahub-setup"
            fi
          '';
        };

        seaf-gc = {
          description = "Seafile storage garbage collection";
          conflicts = [
            "seaf-server.service"
            "seahub.service"
          ];
          after = [
            "seaf-server.service"
            "seahub.service"
          ];
          unitConfig.RequiresMountsFor = lib.lists.optional (cfg.dataDir != "${seafRoot}/data") cfg.dataDir;
          onSuccess = [
            "seaf-server.service"
            "seahub.service"
          ];
          onFailure = [
            "seaf-server.service"
            "seahub.service"
          ];
          startAt = lib.lists.optionals cfg.gc.enable cfg.gc.dates;
          serviceConfig = serviceOptions // {
            Type = "oneshot";
          };
          script = ''
            if [ ! -f "${seafRoot}/server-setup" ]; then
                echo "Server not setup yet, GC not needed" >&2
                exit
            fi

            # checking for pending upgrades
            installedMajor=$(cat "${seafRoot}/server-setup" | cut -d"-" -f1 | cut -d"." -f1)
            installedMinor=$(cat "${seafRoot}/server-setup" | cut -d"-" -f1 | cut -d"." -f2)
            pkgMajor=$(echo "${cfg.seahubPackage.seafile-server.version}" | cut -d"." -f1)
            pkgMinor=$(echo "${cfg.seahubPackage.seafile-server.version}" | cut -d"." -f2)

            if [[ $installedMajor != $pkgMajor || $installedMinor != $pkgMinor ]]; then
                echo "Server not upgraded yet" >&2
                exit
            fi

            # Clean up user-deleted blocks and libraries
            ${cfg.seahubPackage.seafile-server}/bin/seafserv-gc \
              -F /etc/seafile \
              -c ${ccnetDir} \
              -d ${cfg.dataDir} \
              --rm-fs
          '';
        };
      };

    systemd.timers.seaf-gc = lib.mkIf cfg.gc.enable {
      timerConfig = {
        randomizedDelaySec = cfg.gc.randomizedDelaySec;
        Persistent = cfg.gc.persistent;
      };
    };
  };

  meta.maintainers = with maintainers; [
    greizgh
    schmittlauch
  ];
}
