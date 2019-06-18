# Zabbix server daemon.
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.zabbixServer;

  stateDir = "/run/zabbix";

  logDir = "/var/log/zabbix";

  libDir = "/var/lib/zabbix";

  pidFile = "${stateDir}/zabbix_server.pid";

  configFile = pkgs.writeText "zabbix_server.conf"
    ''
      ListenPort = ${cfg.listenPort}

      LogFile = ${logDir}/zabbix_server

      PidFile = ${pidFile}

      ${optionalString (cfg.dbServer != "localhost") ''
        DBHost = ${cfg.dbServer}
      ''}

      DBName = ${cfg.dbName}

      DBUser = ${cfg.dbUser}

      DBPort = ${cfg.dbPort}

      DBPassword = ${cfg.dbPassword}

      ${config.services.zabbixServer.extraConfig}
    '';

  useLocalMysql = cfg.dbServer == "localhost" || cfg.dbServer == "";

in

{

  ###### interface

  options = {

    services.zabbixServer.enable = mkOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to run the Zabbix server on this machine.
      '';
    };

    services.zabbixServer.dbServer = mkOption {
      default = "localhost";
      type = types.str;
      description = ''
        Hostname or IP address of the database server.
        Use an empty string ("") to use peer authentication.
      '';
    };

    services.zabbixServer.dbPassword = mkOption {
      type = types.str;
      description = "Password used to connect to the database server.";
    };

    services.zabbixServer.dbUser = mkOption {
      default = "zabbix";
      type = types.str;
      description = "User used to connect to the database server.";
    };

    services.zabbixServer.dbPort = mkOption {
      default = "3306";
      type = types.str;
      description = "Port used to connect to the database server.";
    };

    services.zabbixServer.dbName = mkOption {
      default = "zabbix";
      type = types.str;
      description = "Port used to connect to the database server.";
    };

    services.zabbixServer.listenPort = mkOption {
      default = "10051";
      type = types.str;
      description = "Port used to listen to the agent.";
    };

    services.zabbixServer.extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Configuration that is injected verbatim into the configuration file.
      '';
    };
  };

  ###### implementation

  config = mkIf cfg.enable {

    services.mysql.enable = useLocalMysql;
    services.mysql.package = pkgs.mysql;

    users.users = singleton
      { name = "zabbix";
        uid = config.ids.uids.zabbix;
        description = "Zabbix daemon user";
      };

    systemd.services."zabbix-server" =
      { description = "Zabbix Server";

        wantedBy = [ "multi-user.target" ];
        after = optional useLocalMysql "mysql.service";

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir} ${logDir} ${libDir}
            chown zabbix ${stateDir} ${logDir} ${libDir}
            ${lib.optionalString (useLocalMysql) ''
              if ! test -e "${libDir}/db-created"; then
                ${pkgs.sudo}/bin/sudo -u ${config.services.mysql.user} ${pkgs.mysql}/bin/mysql -uroot -e 'CREATE DATABASE ${cfg.dbName}'
                ${pkgs.sudo}/bin/sudo -u ${config.services.mysql.user} ${pkgs.mysql}/bin/mysql -uroot -e "GRANT ALL ON ${cfg.dbName}.* TO ${cfg.dbUser}@localhost IDENTIFIED BY \"${cfg.dbPassword}\";"
                cat ${pkgs.zabbix.server}/share/zabbix/db/schema/mysql.sql | ${pkgs.sudo}/bin/sudo -u zabbix ${pkgs.mysql}/bin/mysql -u${cfg.dbUser} -p${cfg.dbPassword} ${cfg.dbName}
                cat ${pkgs.zabbix.server}/share/zabbix/db/data/images.sql | ${pkgs.sudo}/bin/sudo -u zabbix ${pkgs.mysql}/bin/mysql -u${cfg.dbUser} -p${cfg.dbPassword} ${cfg.dbName}
                cat ${pkgs.zabbix.server}/share/zabbix/db/data/data.sql | ${pkgs.sudo}/bin/sudo -u zabbix ${pkgs.mysql}/bin/mysql -u${cfg.dbUser} -p${cfg.dbPassword} ${cfg.dbName}
                touch "${libDir}/db-created"
              fi''}
          '';

        path = [ pkgs.nettools ];

        serviceConfig.ExecStart = "${pkgs.zabbix.server}/sbin/zabbix_server --config ${configFile}";
        serviceConfig.Type = "forking";
        serviceConfig.PIDFile = pidFile;
      };
  };
}
