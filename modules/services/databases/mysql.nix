{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.mysql;

  mysql = pkgs.mysql;

  pidFile = "${cfg.pidDir}/mysqld.pid";

  mysqldOptions =
    "--user=${cfg.user} --datadir=${cfg.dataDir} " +
    "--log-error=${cfg.logError} --pid-file=${pidFile}";

in

{

  ###### interface

  options = {
  
    services.mysql = {
    
      enable = mkOption {
        default = false;
        description = "
          Whether to enable the MySQL server.
        ";
      };

      port = mkOption {
        default = "3306";
        description = "Port of MySQL"; 
      };

      user = mkOption {
        default = "mysql";
        description = "User account under which MySQL runs";
      };

      dataDir = mkOption {
        default = "/var/mysql"; # !!! should be /var/db/mysql
        description = "Location where MySQL stores its table files";
      };

      logError = mkOption {
        default = "/var/log/mysql_err.log";
        description = "Location of the MySQL error logfile";
      };

      pidDir = mkOption {
        default = "/var/run/mysql";
        description = "Location of the file which stores the PID of the MySQL server";
      };

    };
    
  };


  ###### implementation

  config = mkIf config.services.mysql.enable {

    users.extraUsers = singleton
      { name = "mysql";
        description = "MySQL server user";
      };

    environment.systemPackages = [mysql];

    jobAttrs.mysql =
      { description = "MySQL server";

        startOn = "filesystems";
        stopOn = "shutdown";

        preStart =
          ''
            if ! test -e ${cfg.dataDir}/mysql; then
                mkdir -m 0700 -p ${cfg.dataDir}
                chown -R ${cfg.user} ${cfg.dataDir}
                ${mysql}/bin/mysql_install_db ${mysqldOptions}
            fi

            mkdir -m 0700 -p ${cfg.pidDir}
            chown -R ${cfg.user} ${cfg.pidDir}
          '';

        exec = "${mysql}/bin/mysqld ${mysqldOptions}";

        postStop =
          ''
            pid=$(cat ${pidFile})
            kill "$pid"
            ${mysql}/bin/mysql_waitpid "$pid" 1000
          '';
      };

  };

}
