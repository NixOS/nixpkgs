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

      StartAgents = 1
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

    jobs.zabbix_agent =
      { name = "zabbix-agent";

        description = "Zabbix agent daemon";

        startOn = "ip-up";
        stopOn = "stopping network-interfaces";

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir} ${logDir}
            chown zabbix ${stateDir} ${logDir}

            # Grrr, zabbix_agentd cannot be properly monitored by
            # Upstart.  Upstart's "expect fork/daemon" feature doesn't
            # work because zabbix_agentd runs some programs on
            # startup, and zabbix_agentd doesn't have a flag to
            # prevent daemonizing.
            export PATH=${pkgs.nettools}/bin:$PATH
            ${pkgs.zabbix.agent}/sbin/zabbix_agentd --config ${configFile}
          '';

        postStop =
          ''
            pid=$(cat ${pidFile})
            test -n "$pid" && kill "$pid"
            # Wait until they're really gone.
            while ${pkgs.procps}/bin/pgrep -u zabbix zabbix_agentd > /dev/null; do sleep 1; done
          '';
      };

    environment.systemPackages = [ pkgs.zabbix.agent ];

  };

}
