{
  pkgs,
  lib,
  config,
  ...
}:

with lib;
let
  cfg = config.services.gammu-smsd;

  configFile = pkgs.writeText "gammu-smsd.conf" ''
    [gammu]
    Device = ${cfg.device.path}
    Connection = ${cfg.device.connection}
    SynchronizeTime = ${if cfg.device.synchronizeTime then "yes" else "no"}
    LogFormat = ${cfg.log.format}
    ${optionalString (cfg.device.pin != null) "PIN = ${cfg.device.pin}"}
    ${cfg.extraConfig.gammu}


    [smsd]
    LogFile = ${cfg.log.file}
    Service = ${cfg.backend.service}

    ${optionalString (cfg.backend.service == "files") ''
      InboxPath = ${cfg.backend.files.inboxPath}
      OutboxPath = ${cfg.backend.files.outboxPath}
      SentSMSPath = ${cfg.backend.files.sentSMSPath}
      ErrorSMSPath = ${cfg.backend.files.errorSMSPath}
    ''}

    ${optionalString (cfg.backend.service == "sql" && cfg.backend.sql.driver == "sqlite") ''
      Driver = ${cfg.backend.sql.driver}
      DBDir = ${cfg.backend.sql.database}
    ''}

    ${optionalString (cfg.backend.service == "sql" && cfg.backend.sql.driver == "native_pgsql") (
      with cfg.backend;
      ''
        Driver = ${sql.driver}
        ${optionalString (sql.database != null) "Database = ${sql.database}"}
        ${optionalString (sql.host != null) "Host = ${sql.host}"}
        ${optionalString (sql.user != null) "User = ${sql.user}"}
        ${optionalString (sql.password != null) "Password = ${sql.password}"}
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

      enable = mkEnableOption "gammu-smsd daemon";

      user = mkOption {
        type = types.str;
        default = "smsd";
        description = "User that has access to the device";
      };

      device = {
        path = mkOption {
          type = types.path;
          description = "Device node or address of the phone";
          example = "/dev/ttyUSB2";
        };

        group = mkOption {
          type = types.str;
          default = "root";
          description = "Owner group of the device";
          example = "dialout";
        };

        connection = mkOption {
          type = types.str;
          default = "at";
          description = "Protocol which will be used to talk to the phone";
        };

        synchronizeTime = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to set time from computer to the phone during starting connection";
        };

        pin = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "PIN code for the simcard";
        };
      };

      log = {
        file = mkOption {
          type = types.str;
          default = "syslog";
          description = "Path to file where information about communication will be stored";
        };

        format = mkOption {
          type = types.enum [
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
        gammu = mkOption {
          type = types.lines;
          default = "";
          description = "Extra config lines to be added into [gammu] section";
        };

        smsd = mkOption {
          type = types.lines;
          default = "";
          description = "Extra config lines to be added into [smsd] section";
        };
      };

      backend = {
        service = mkOption {
          type = types.enum [
            "null"
            "files"
            "sql"
          ];
          default = "null";
          description = "Service to use to store sms data.";
        };

        files = {
          inboxPath = mkOption {
            type = types.path;
            default = "/var/spool/sms/inbox/";
            description = "Where the received SMSes are stored";
          };

          outboxPath = mkOption {
            type = types.path;
            default = "/var/spool/sms/outbox/";
            description = "Where SMSes to be sent should be placed";
          };

          sentSMSPath = mkOption {
            type = types.path;
            default = "/var/spool/sms/sent/";
            description = "Where the transmitted SMSes are placed";
          };

          errorSMSPath = mkOption {
            type = types.path;
            default = "/var/spool/sms/error/";
            description = "Where SMSes with error in transmission is placed";
          };
        };

        sql = {
          driver = mkOption {
            type = types.enum [
              "native_mysql"
              "native_pgsql"
              "odbc"
              "dbi"
            ];
            description = "DB driver to use";
          };

          sqlDialect = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "SQL dialect to use (odbc driver only)";
          };

          database = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Database name to store sms data";
          };

          host = mkOption {
            type = types.str;
            default = "localhost";
            description = "Database server address";
          };

          user = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "User name used for connection to the database";
          };

          password = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "User password used for connection to the database";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      description = "gammu-smsd user";
      isSystemUser = true;
      group = cfg.device.group;
    };

    environment.systemPackages =
      with cfg.backend;
      [ gammuPackage ] ++ optionals (service == "sql" && sql.driver == "sqlite") [ pkgs.sqlite ];

    systemd.services.gammu-smsd = {
      description = "gammu-smsd daemon";

      wantedBy = [ "multi-user.target" ];

      wants =
        with cfg.backend;
        [ ] ++ optionals (service == "sql" && sql.driver == "native_pgsql") [ "postgresql.service" ];

      preStart =
        with cfg.backend;

        optionalString (service == "files") (
          with files;
          ''
            mkdir -m 755 -p ${inboxPath} ${outboxPath} ${sentSMSPath} ${errorSMSPath}
            chown ${cfg.user} -R ${inboxPath}
            chown ${cfg.user} -R ${outboxPath}
            chown ${cfg.user} -R ${sentSMSPath}
            chown ${cfg.user} -R ${errorSMSPath}
          ''
        )
        + optionalString (service == "sql" && sql.driver == "sqlite") ''
          cat "${gammuPackage}/${initDBDir}/sqlite.sql" \
          | ${pkgs.sqlite.bin}/bin/sqlite3 ${sql.database}
        ''
        + (
          let
            execPsql =
              extraArgs:
              concatStringsSep " " [
                (optionalString (sql.password != null) "PGPASSWORD=${sql.password}")
                "${config.services.postgresql.package}/bin/psql"
                (optionalString (sql.host != null) "-h ${sql.host}")
                (optionalString (sql.user != null) "-U ${sql.user}")
                "$extraArgs"
                "${sql.database}"
              ];
          in
          optionalString (service == "sql" && sql.driver == "native_pgsql") ''
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
