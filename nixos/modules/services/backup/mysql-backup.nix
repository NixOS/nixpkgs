{ config, pkgs, ... }:

with pkgs.lib;

let

  inherit (pkgs) mysql gzip;

  cfg = config.services.mysqlBackup ;
  location = cfg.location ;
  mysqlBackupCron = db : ''
    ${cfg.period} ${cfg.user} ${mysql}/bin/mysqldump ${if cfg.singleTransaction then "--single-transaction" else ""} ${db} | ${gzip}/bin/gzip -c > ${location}/${db}.gz
  '';

in

{
  options = {

    services.mysqlBackup = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable MySQL backups.
        '';
      };

      period = mkOption {
        default = "15 01 * * *";
        description = ''
          This option defines (in the format used by cron) when the
          databases should be dumped.
          The default is to update at 01:15 (at night) every day.
        '';
      };

      user = mkOption {
        default = "mysql";
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

  config = mkIf config.services.mysqlBackup.enable {

    services.cron.systemCronJobs = map mysqlBackupCron config.services.mysqlBackup.databases;

    system.activationScripts.mysqlBackup = stringAfter [ "stdio" "users" ]
      ''
        mkdir -m 0700 -p ${config.services.mysqlBackup.location}
        chown ${config.services.mysqlBackup.user} ${config.services.mysqlBackup.location}
      '';

  };

}
