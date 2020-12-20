{ config, lib, pkgs, ... }:

with lib;

let

  inherit (pkgs) mysql gzip;

  cfg = config.services.mysqlBackup;
  defaultUser = "mysqlbackup";

  backupScript = ''
    set -o pipefail
    failed=""
    ${concatMapStringsSep "\n" backupDatabaseScript cfg.databases}
    if [ -n "$failed" ]; then
      echo "Backup of database(s) failed:$failed"
      exit 1
    fi
  '';
  backupDatabaseScript = db: ''
    dest="${cfg.location}/${db}.gz"
    if ${mysql}/bin/mysqldump ${if cfg.singleTransaction then "--single-transaction" else ""} ${db} | ${gzip}/bin/gzip -c > $dest.tmp; then
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

      enable = mkEnableOption "MySQL backups";

      calendar = mkOption {
        type = types.str;
        default = "01:15:00";
        description = ''
          Configured when to run the backup service systemd unit (DayOfWeek Year-Month-Day Hour:Minute:Second).
        '';
      };

      user = mkOption {
        default = defaultUser;
        description = ''
          User to be used to perform backup.
        '';
      };

      databases = mkOption {
        default = [];
        description = ''
          List of database names to dump.
        '';
      };

      location = mkOption {
        default = "/var/backup/mysql";
        description = ''
          Location to put the gzipped MySQL database dumps.
        '';
      };

      singleTransaction = mkOption {
        default = false;
        description = ''
          Whether to create database dump in a single transaction
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    users.users = optionalAttrs (cfg.user == defaultUser) {
      ${defaultUser} = {
        isSystemUser = true;
        createHome = false;
        home = cfg.location;
        group = "nogroup";
      };
    };

    services.mysql.activationScripts.mysql-backup =
      let
        unix_socket = if (lib.getName config.services.mysql.package == lib.getName pkgs.mariadb) then "unix_socket" else "auth_socket";
      in ''

        ( echo "create user if not exists '${cfg.user}'@'localhost' identified with ${unix_socket};"
          ${concatMapStringsSep "\n" (db: ''echo "grant select, show view, trigger, lock tables on \`${db}\`.* to '${cfg.user}'@'localhost';"'') cfg.databases}
        ) | ${config.services.mysql.package}/bin/mysql -N
      '';

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
        description = "Mysql backup service";
        after = [ "mysql-activation-scripts.service" ];
        enable = true;
        serviceConfig = {
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
