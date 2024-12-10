{
  config,
  lib,
  pkgs,
  ...
}:
let

  inherit (pkgs) mariadb gzip;

  cfg = config.services.mysqlBackup;
  defaultUser = "mysqlbackup";

  backupScript = ''
    set -o pipefail
    failed=""
    ${lib.concatMapStringsSep "\n" backupDatabaseScript cfg.databases}
    if [ -n "$failed" ]; then
      echo "Backup of database(s) failed:$failed"
      exit 1
    fi
  '';
  backupDatabaseScript = db: ''
    dest="${cfg.location}/${db}.gz"
    if ${mariadb}/bin/mysqldump ${lib.optionalString cfg.singleTransaction "--single-transaction"} ${db} | ${gzip}/bin/gzip -c ${cfg.gzipOptions} > $dest.tmp; then
      mv $dest.tmp $dest
      echo "Backed up to $dest"
    else
      echo "Failed to back up to $dest"
      rm -f $dest.tmp
      failed="$failed ${db}"
    fi
  '';

in

{
  options = {

    services.mysqlBackup = {

      enable = lib.mkEnableOption "MySQL backups";

      calendar = lib.mkOption {
        type = lib.types.str;
        default = "01:15:00";
        description = ''
          Configured when to run the backup service systemd unit (DayOfWeek Year-Month-Day Hour:Minute:Second).
        '';
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = defaultUser;
        description = ''
          User to be used to perform backup.
        '';
      };

      databases = lib.mkOption {
        default = [ ];
        type = lib.types.listOf lib.types.str;
        description = ''
          List of database names to dump.
        '';
      };

      location = lib.mkOption {
        type = lib.types.path;
        default = "/var/backup/mysql";
        description = ''
          Location to put the gzipped MySQL database dumps.
        '';
      };

      singleTransaction = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to create database dump in a single transaction
        '';
      };

      gzipOptions = lib.mkOption {
        default = "--no-name --rsyncable";
        type = lib.types.str;
        description = ''
          Command line options to use when invoking `gzip`.
        '';
      };
    };

  };

  config = lib.mkIf cfg.enable {
    users.users = lib.optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
        createHome = false;
        home = cfg.location;
        group = "nogroup";
      };
    };

    services.mysql.ensureUsers = [
      {
        name = cfg.user;
        ensurePermissions =
          with lib;
          let
            privs = "SELECT, SHOW VIEW, TRIGGER, LOCK TABLES";
            grant = db: lib.nameValuePair "${db}.*" privs;
          in
          lib.listToAttrs (map grant cfg.databases);
      }
    ];

    systemd = {
      timers.mysql-backup = {
        description = "Mysql backup timer";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = cfg.calendar;
          AccuracySec = "5m";
          Unit = "mysql-backup.service";
        };
      };
      services.mysql-backup = {
        description = "MySQL backup service";
        enable = true;
        serviceConfig = {
          Type = "oneshot";
          User = cfg.user;
        };
        script = backupScript;
      };
      tmpfiles.rules = [
        "d ${cfg.location} 0700 ${cfg.user} - - -"
      ];
    };
  };

}
