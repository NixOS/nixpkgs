# Zabbix server daemon.
{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.zabbixServer;

  stateDir = "/var/run/zabbix";

  logDir = "/var/log/zabbix";

  libDir = "/var/lib/zabbix";

  pidFile = "${stateDir}/zabbix_server.pid";

  configFile = pkgs.writeText "zabbix_server.conf"
    ''
      LogFile = ${logDir}/zabbix_server

      PidFile = ${pidFile}

      ${optionalString (cfg.dbServer != "localhost") ''
        DBHost = ${cfg.dbServer}
      ''}

      DBName = zabbix

      DBUser = zabbix

      ${optionalString (cfg.dbPassword != "") ''
        DBPassword = ${cfg.dbPassword}
      ''}
    '';

  useLocalPostgres = cfg.dbServer == "localhost" || cfg.dbServer == "";

in

{

  ###### interface

  options = {

    services.zabbixServer.enable = mkOption {
      default = false;
      description = ''
        Whether to run the Zabbix server on this machine.
      '';
    };

    services.zabbixServer.dbServer = mkOption {
      default = "localhost";
      description = ''
        Hostname or IP address of the database server.
        Use an empty string ("") to use peer authentication.
      '';
    };

    services.zabbixServer.dbPassword = mkOption {
      default = "";
      description = "Password used to connect to the database server.";
    };

  };

  ###### implementation

  config = mkIf cfg.enable {

    services.postgresql.enable = useLocalPostgres;

    users.extraUsers = singleton
      { name = "zabbix";
        uid = config.ids.uids.zabbix;
        description = "Zabbix daemon user";
      };

    systemd.services."zabbix-server" =
      { description = "Zabbix Server";

        wantedBy = [ "multi-user.target" ];
        after = optional useLocalPostgres "postgresql.service";

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir} ${logDir} ${libDir}
            chown zabbix ${stateDir} ${logDir} ${libDir}

            if ! test -e "${libDir}/db-created"; then
                ${pkgs.postgresql}/bin/createuser --no-superuser --no-createdb --no-createrole zabbix || true
                ${pkgs.postgresql}/bin/createdb --owner zabbix zabbix || true
                cat ${pkgs.zabbix.server}/share/zabbix/db/schema/postgresql.sql | ${pkgs.su}/bin/su -s "$SHELL" zabbix -c '${pkgs.postgresql}/bin/psql zabbix'
                cat ${pkgs.zabbix.server}/share/zabbix/db/data/images_pgsql.sql | ${pkgs.su}/bin/su -s "$SHELL" zabbix -c '${pkgs.postgresql}/bin/psql zabbix'
                cat ${pkgs.zabbix.server}/share/zabbix/db/data/data.sql | ${pkgs.su}/bin/su -s "$SHELL" zabbix -c '${pkgs.postgresql}/bin/psql zabbix'
                touch "${libDir}/db-created"
            fi
          '';

        path = [ pkgs.nettools ];

        serviceConfig.ExecStart = "@${pkgs.zabbix.server}/sbin/zabbix_server zabbix_server --config ${configFile}";
        serviceConfig.Type = "forking";
        serviceConfig.Restart = "always";
        serviceConfig.RestartSec = 2;
        serviceConfig.PIDFile = pidFile;
      };

  };

}
