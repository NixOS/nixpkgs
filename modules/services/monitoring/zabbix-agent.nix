# Zabbix agent daemon.
{config, pkgs, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption;

  options = {
    services = {
      zabbixAgent = {

        enable = mkOption {
          default = false;
          description = "
            Whether to run the Zabbix monitoring agent on this machine.
            It will send monitoring data to a Zabbix server.
          ";
        };

        server = mkOption {
          default = "127.0.0.1";
          description = ''
            The IP address or hostname of the Zabbix server to connect to.
          '';
        };

      };
    };
  };
in

###### implementation
let

  cfg = config.services.zabbixAgent;

  stateDir = "/var/run/zabbix";

  logDir = "/var/log/zabbix";

  pidFile = "${stateDir}/zabbix_agentd.pid";

  configFile = pkgs.writeText "zabbix_agentd.conf" ''
    Server = ${cfg.server}

    LogFile = ${logDir}/zabbix_agentd
  
    PidFile = ${pidFile}

    StartAgents = 5
  '';

  user = {
    name = "zabbix";
    uid = (import ../../../system/ids.nix).uids.zabbix;
    description = "Zabbix daemon user";
  };

  job = {
    name = "zabbix-agent";
    
    job = ''
      start on network-interfaces/started
      stop on network-interfaces/stop

      description "Zabbix agent daemon"

      start script
        mkdir -m 0755 -p ${stateDir} ${logDir}
        chown zabbix ${stateDir} ${logDir}
        
        export PATH=${pkgs.nettools}/bin:$PATH
        ${pkgs.zabbixAgent}/sbin/zabbix_agentd --config ${configFile}
      end script

      respawn sleep 100000
      
      stop script
        # !!! this seems to leave processes behind.
        #pid=$(cat ${pidFile})
        #if test -n "$pid"; then
        #  kill $pid 
        #fi

        # So instead kill the agent in a brutal fashion.
        while ${pkgs.procps}/bin/pkill -u zabbix zabbix_agentd; do true; done
      end script
    '';
  };

  ifEnable = pkgs.lib.ifEnable cfg.enable;
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
