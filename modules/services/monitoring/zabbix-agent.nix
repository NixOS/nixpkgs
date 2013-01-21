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

      ${config.services.zabbixAgent.extraConfig}
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

      extraConfig = mkOption {
        default = "";
        description = ''
          Configuration that is injected verbatim into the configuration file.
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

    systemd.services."zabbix-agent" =
      { description = "Zabbix Agent";

        wantedBy = [ "multi-user.target" ];

        path = [ pkgs.nettools ];

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir} ${logDir}
            chown zabbix ${stateDir} ${logDir}
          '';

        serviceConfig.ExecStart = "@${pkgs.zabbix.agent}/sbin/zabbix_agentd zabbix_agentd --config ${configFile}";
        serviceConfig.Type = "forking";
        serviceConfig.RemainAfterExit = true;
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = 2;
      };

    environment.systemPackages = [ pkgs.zabbix.agent ];

  };

}
