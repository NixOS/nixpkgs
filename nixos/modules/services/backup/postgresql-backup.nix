{ config, pkgs, ... }:

with pkgs.lib;

let
  inherit (pkgs) postgresql gzip;

  location = config.services.postgresqlBackup.location ;

  postgresqlBackupCron = db:
    ''
      ${config.services.postgresqlBackup.period} root ${postgresql}/bin/pg_dump ${db} | ${gzip}/bin/gzip -c > ${location}/${db}.gz
    '';

in

{

  options = {

    services.postgresqlBackup = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to enable PostgreSQL dumps.
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

      databases = mkOption {
        default = [];
        description = ''
          List of database names to dump.
        '';
      };

      location = mkOption {
        default = "/var/backup/postgresql";
        description = ''
          Location to put the gzipped PostgreSQL database dumps.
        '';
      };
    };

  };

  config = mkIf config.services.postgresqlBackup.enable {
    services.cron.systemCronJobs = map postgresqlBackupCron config.services.postgresqlBackup.databases;

    system.activationScripts.postgresqlBackup = stringAfter [ "stdio" "users" ]
      ''
        mkdir -m 0700 -p ${config.services.postgresqlBackup.location}
        chown root ${config.services.postgresqlBackup.location}
      '';
  };

}
