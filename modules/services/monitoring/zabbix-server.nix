# Zabbix server daemon.
{config, pkgs, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {
      zabbixServer = {
        enable = mkOption {
          default = false;
          description = "
            Whether to run the Zabbix server on this machine.
          ";
        };
      };
    };
  };
in

###### implementation
let

  stateDir = "/var/run/zabbix";

  logDir = "/var/log/zabbix";

  libDir = "/var/lib/zabbix";

  pidFile = "${stateDir}/zabbix_server.pid";

  configFile = pkgs.writeText "zabbix_server.conf" ''
    LogFile = ${logDir}/zabbix_server
  
    PidFile = ${pidFile}

    DBName = zabbix

    DBUser = zabbix
  '';

  user = {
    name = "zabbix";
    uid = config.ids.uids.zabbix;
    description = "Zabbix daemon user";
  };

  job = {
    name = "zabbix-server";

    job = ''
      description "Zabbix server daemon"

      start on postgresql/started
      stop on shutdown

      start script
        mkdir -m 0755 -p ${stateDir} ${logDir} ${libDir}
        chown zabbix ${stateDir} ${logDir} ${libDir}

        if ! test -e "${libDir}/db-created"; then
            ${pkgs.postgresql}/bin/createuser --no-superuser --no-createdb --no-createrole zabbix || true
            ${pkgs.postgresql}/bin/createdb --owner zabbix zabbix || true
            cat ${pkgs.zabbixServer}/share/zabbix/db/schema/postgresql.sql | ${pkgs.su}/bin/su -s "$SHELL" zabbix -c 'psql zabbix'
            cat ${pkgs.zabbixServer}/share/zabbix/db/data/data.sql | ${pkgs.su}/bin/su -s "$SHELL" zabbix -c 'psql zabbix'
            cat ${pkgs.zabbixServer}/share/zabbix/db/data/images_pgsql.sql | ${pkgs.su}/bin/su -s "$SHELL" zabbix -c 'psql zabbix'
            touch "${libDir}/db-created"
        fi
        
        export PATH=${pkgs.nettools}/bin:$PATH
        ${pkgs.zabbixServer}/sbin/zabbix_server --config ${configFile}
      end script

      respawn sleep 100000
      
      stop script
        while ${pkgs.procps}/bin/pkill -u zabbix zabbix_server; do true; done
      end script
    '';
    
  };

  ifEnable = pkgs.lib.ifEnable config.services.zabbixServer.enable;
in

{
  require = [
    # ../upstart-jobs/default.nix
    # ../system/user.nix # users = { .. }
    options
  ];

  services = {
    extraJobs = ifEnable [job];
  };

  users = {
    extraUsers = ifEnable [user];
  };
}
