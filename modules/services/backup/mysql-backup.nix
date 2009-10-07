{pkgs, config, ...}:

let
  inherit (pkgs.lib) mkOption mkIf singleton concatStrings;
  inherit (pkgs) mysql gzip;

  location = config.services.mysqlBackup.location ;

  mysqlBackupCron = db : ''
    ${config.services.mysqlBackup.period} mysql ${mysql}/bin/mysqldump ${db} | ${gzip}/bin/gzip -c > ${location}/${db}.gz
  ''; 

in

{

  ###### interface
  
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

      databases = mkOption {
        default = [];
        description = ''
          List of database names to dump.
        '';
      };
 
      location = mkOption {
        default = "/var/backup/mysql";
        description = ''
          Location to put the gzipped PostgreSQL database dumps.
        '';
      };
    };

  };

  ###### implementation
  config = mkIf config.services.mysqlBackup.enable {
    services.cron = {
      systemCronJobs = 
        pkgs.lib.optional
          config.services.mysqlBackup.enable
          (concatStrings (map mysqlBackupCron config.services.mysqlBackup.databases));
    };

    system.activationScripts.mysqlBackup = pkgs.stringsWithDeps.noDepEntry ''
         mkdir -m 0700 -p ${config.services.mysqlBackup.location}
         chown mysql ${config.services.mysqlBackup.location}
    '';
  };
  
}
