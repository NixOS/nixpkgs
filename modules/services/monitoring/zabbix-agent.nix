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
          '';

        # Zabbix doesn't have an option not to daemonize, and doesn't
        # daemonize in a way that allows Upstart to track it.  So to
        # make sure that we notice when it goes down, we start Zabbix
        # with an open connection to a fifo, with a `cat' on the other
        # side.  If Zabbix dies, then `cat' will exit as well, so we
        # just monitor `cat'.
        script =
          ''
            export PATH=${pkgs.nettools}/bin:$PATH
            rm -f ${stateDir}/dummy2
            mkfifo ${stateDir}/dummy2
            cat ${stateDir}/dummy2 &
            pid=$!
            ${pkgs.zabbix.agent}/sbin/zabbix_agentd --config ${configFile} 100>${stateDir}/dummy2
            wait "$pid"
          '';
        
        postStop =
          ''
            pid=$(cat ${pidFile} 2> /dev/null || true)
            (test -n "$pid" && kill "$pid") || true
            # Wait until they're really gone.
            while ${pkgs.procps}/bin/pgrep -u zabbix zabbix_agentd > /dev/null; do sleep 1; done
          '';
      };

    environment.systemPackages = [ pkgs.zabbix.agent ];

  };

}
