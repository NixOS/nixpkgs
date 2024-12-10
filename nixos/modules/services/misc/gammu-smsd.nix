{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.gammu-smsd;

  configFile = pkgs.writeText "gammu-smsd.conf" ''
    [gammu]
    Device = ${cfg.device.path}
    Connection = ${cfg.device.connection}
    SynchronizeTime = ${if cfg.device.synchronizeTime then "yes" else "no"}
    LogFormat = ${cfg.log.format}
    ${lib.optionalString (cfg.device.pin != null) "PIN = ${cfg.device.pin}"}
    ${cfg.extraConfig.gammu}


    [smsd]
    LogFile = ${cfg.log.file}
    Service = ${cfg.backend.service}

    ${lib.optionalString (cfg.backend.service == "files") ''
      InboxPath = ${cfg.backend.files.inboxPath}
      OutboxPath = ${cfg.backend.files.outboxPath}
      SentSMSPath = ${cfg.backend.files.sentSMSPath}
      ErrorSMSPath = ${cfg.backend.files.errorSMSPath}
    ''}

    ${lib.optionalString (cfg.backend.service == "sql" && cfg.backend.sql.driver == "sqlite") ''
      Driver = ${cfg.backend.sql.driver}
      DBDir = ${cfg.backend.sql.database}
    ''}

    ${lib.optionalString (cfg.backend.service == "sql" && cfg.backend.sql.driver == "native_pgsql") (
      with cfg.backend;
      ''
        Driver = ${sql.driver}
        ${lib.optionalString (sql.database != null) "Database = ${sql.database}"}
        ${lib.optionalString (sql.host != null) "Host = ${sql.host}"}
        ${lib.optionalString (sql.user != null) "User = ${sql.user}"}
        ${lib.optionalString (sql.password != null) "Password = ${sql.password}"}
      ''
    )}

    ${cfg.extraConfig.smsd}
  '';

  initDBDir = "share/doc/gammu/examples/sql";

  gammuPackage =
    with cfg.backend;
    (pkgs.gammu.override {
      dbiSupport = service == "sql" && sql.driver == "sqlite";
      postgresSupport = service == "sql" && sql.driver == "native_pgsql";
    });

in
{
  options = {
    services.gammu-smsd = {

      enable = lib.mkEnableOption "gammu-smsd daemon";

      user = lib.mkOption {
        type = lib.types.str;
        default = "smsd";
        description = "User that has access to the device";
      };

      device = {
        path = lib.mkOption {
          type = lib.types.path;
          description = "Device node or address of the phone";
          example = "/dev/ttyUSB2";
        };

        group = lib.mkOption {
          type = lib.types.str;
          default = "root";
          description = "Owner group of the device";
          example = "dialout";
        };

        connection = lib.mkOption {
          type = lib.types.str;
          default = "at";
          description = "Protocol which will be used to talk to the phone";
        };

        synchronizeTime = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to set time from computer to the phone during starting connection";
        };

        pin = lib.mkOption {
          type = lib.types.nullOr lib.types.str;
          default = null;
          description = "PIN code for the simcard";
        };
      };

      log = {
        file = lib.mkOption {
          type = lib.types.str;
          default = "syslog";
          description = "Path to file where information about communication will be stored";
        };

        format = lib.mkOption {
          type = lib.types.enum [
            "nothing"
            "text"
            "textall"
            "textalldate"
            "errors"
            "errorsdate"
            "binary"
          ];
          default = "errors";
          description = "Determines what will be logged to the LogFile";
        };
      };

      extraConfig = {
        gammu = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = "Extra config lines to be added into [gammu] section";
        };

        smsd = lib.mkOption {
          type = lib.types.lines;
          default = "";
          description = "Extra config lines to be added into [smsd] section";
        };
      };

      backend = {
        service = lib.mkOption {
          type = lib.types.enum [
            "null"
            "files"
            "sql"
          ];
          default = "null";
          description = "Service to use to store sms data.";
        };

        files = {
          inboxPath = lib.mkOption {
            type = lib.types.path;
            default = "/var/spool/sms/inbox/";
            description = "Where the received SMSes are stored";
          };

          outboxPath = lib.mkOption {
            type = lib.types.path;
            default = "/var/spool/sms/outbox/";
            description = "Where SMSes to be sent should be placed";
          };

          sentSMSPath = lib.mkOption {
            type = lib.types.path;
            default = "/var/spool/sms/sent/";
            description = "Where the transmitted SMSes are placed";
          };

          errorSMSPath = lib.mkOption {
            type = lib.types.path;
            default = "/var/spool/sms/error/";
            description = "Where SMSes with error in transmission is placed";
          };
        };

        sql = {
          driver = lib.mkOption {
            type = lib.types.enum [
              "native_mysql"
              "native_pgsql"
              "odbc"
              "dbi"
            ];
            description = "DB driver to use";
          };

          sqlDialect = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "SQL dialect to use (odbc driver only)";
          };

          database = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "Database name to store sms data";
          };

          host = lib.mkOption {
            type = lib.types.str;
            default = "localhost";
            description = "Database server address";
          };

          user = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "User name used for connection to the database";
          };

          password = lib.mkOption {
            type = lib.types.nullOr lib.types.str;
            default = null;
            description = "User password used for connection to the database";
          };
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.user} = {
      description = "gammu-smsd user";
      isSystemUser = true;
      group = cfg.device.group;
    };

    environment.systemPackages =
      with cfg.backend;
      [ gammuPackage ] ++ lib.optionals (service == "sql" && sql.driver == "sqlite") [ pkgs.sqlite ];

    systemd.services.gammu-smsd = {
      description = "gammu-smsd daemon";

      wantedBy = [ "multi-user.target" ];

      wants =
        with cfg.backend;
        [ ] ++ lib.optionals (service == "sql" && sql.driver == "native_pgsql") [ "postgresql.service" ];

      preStart =
        with cfg.backend;

        lib.optionalString (service == "files") (
          with files;
          ''
            mkdir -m 755 -p ${inboxPath} ${outboxPath} ${sentSMSPath} ${errorSMSPath}
            chown ${cfg.user} -R ${inboxPath}
            chown ${cfg.user} -R ${outboxPath}
            chown ${cfg.user} -R ${sentSMSPath}
            chown ${cfg.user} -R ${errorSMSPath}
          ''
        )
        + lib.optionalString (service == "sql" && sql.driver == "sqlite") ''
          cat "${gammuPackage}/${initDBDir}/sqlite.sql" \
          | ${pkgs.sqlite.bin}/bin/sqlite3 ${sql.database}
        ''
        + (
          let
            execPsql =
              extraArgs:
              lib.concatStringsSep " " [
                (lib.optionalString (sql.password != null) "PGPASSWORD=${sql.password}")
                "${config.services.postgresql.package}/bin/psql"
                (lib.optionalString (sql.host != null) "-h ${sql.host}")
                (lib.optionalString (sql.user != null) "-U ${sql.user}")
                "$extraArgs"
                "${sql.database}"
              ];
          in
          lib.optionalString (service == "sql" && sql.driver == "native_pgsql") ''
            echo '\i '"${gammuPackage}/${initDBDir}/pgsql.sql" | ${execPsql ""}
          ''
        );

      serviceConfig = {
        User = "${cfg.user}";
        Group = "${cfg.device.group}";
        PermissionsStartOnly = true;
        ExecStart = "${gammuPackage}/bin/gammu-smsd -c ${configFile}";
      };

    };
  };
}
