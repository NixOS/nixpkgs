# Zabbix agent daemon.
{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.zabbixAgent;

  stateDir = "/var/run/zabbix";

  logDir = "/var/log/zabbix";

  pidFile = "${stateDir}/zabbix_agentd.pid";

  configFile = pkgs.writeText "zabbix_agentd.conf"
    ''
      Server = ${cfg.server}

      LogFile = ${logDir}/zabbix_agentd
  
      PidFile = ${pidFile}

      StartAgents = 5
    '';

in
  
{

  ###### interface

  options = {
  
    services.zabbixAgent = {

      enable = mkOption {
        default = false;
        description = ''
          Whether to run the Zabbix monitoring agent on this machine.
          It will send monitoring data to a Zabbix server.
        '';
      };

      server = mkOption {
        default = "127.0.0.1";
        description = ''
          The IP address or hostname of the Zabbix server to connect to.
        '';
      };

    };

  };
  

  ###### implementation

  config = mkIf cfg.enable {

    users.extraUsers = singleton
      { name = "zabbix";
        uid = config.ids.uids.zabbix;
        description = "Zabbix daemon user";
      };

    jobAttrs.zabbix_agent =
      { #name = "zabbix-agent"; !!! mkIf bug

        description = "Zabbix agent daemon";

        startOn = "network-interfaces/started";
        stopOn = "network-interfaces/stop";

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir} ${logDir}
            chown zabbix ${stateDir} ${logDir}
        
            export PATH=${pkgs.nettools}/bin:$PATH
            ${pkgs.zabbixAgent}/sbin/zabbix_agentd --config ${configFile}
          '';

        postStop =
          ''      
            # !!! this seems to leave processes behind.
            #pid=$(cat ${pidFile})
            #if test -n "$pid"; then
            #  kill $pid 
            #fi

            # So instead kill the agent in a brutal fashion.
            while ${pkgs.procps}/bin/pkill -u zabbix zabbix_agentd; do true; done
          '';
      };

  };

}
