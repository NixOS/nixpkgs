# Zabbix proxy daemon.
{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.zabbixProxy;

  StateDirectory = "/run/zabbix";

  LogsDirectory = "/var/log/zabbix";

  RuntimeDirectory = "/var/lib/zabbix";

  pidFile = "${StateDirectory}/zabbix_proxy.pid";

  configFile = pkgs.writeText "zabbix_proxy.conf" ''
      Server = ${cfg.server}

      LogFile = ${LogsDirectory}/zabbix_proxy

      PidFile = ${pidFile}

      ${optionalString (cfg.database.server != "localhost") ''
        DBHost = ${cfg.database.server}
      ''}

      ${optionalString (cfg.database.port != "3306") ''
        DBSocket = ${cfg.database.port}
      ''}

      ${optionalString (cfg.database.schema != "postgresql") ''
        DBSchema = ${cfg.database.schema}
      ''}

      DBName = zabbix

      DBUser = zabbix

      ${optionalString (cfg.database.passwordFile != "") ''
        DBPassword = #dbpass#
      ''}

      ${config.services.zabbixProxy.extraConfig}
  '';

  useLocalPostgres = cfg.database.server == "localhost" || cfg.database.server == "";

in

{

  ###### interface

  options = {

    services.zabbixProxy = {

    enable = mkEnableOption {
      default = false;
      type = types.bool;
      description = ''
        Whether to run the Zabbix proxy on this machine.
      '';
    };

    server = mkOption {
      default = "127.0.0.1";
      type = types.str;
       description = ''
         The IP address or hostname of the Zabbix server to connect to.
       '';
    };

    database = {

      server = mkOption {
       default = "localhost";
       type = types.str;
       description = ''
         Hostname or IP address of the database server.
         Use an empty string ("") to use peer authentication.
       '';
      };

      passwordFile = mkOption {
       default = "";
        type = types.str;
       description = "A file containing the password used to connect to the database server.";
      };

      port = mkOption {
        type = types.str;
        default = "3306";
        description = "Path to MySQL socket. Database port when not using local socket. Ignored for SQLite.";
      };

      schema = mkOption {
        type = types.str;
        default = "postgresql";
        description = "Schema name. Used for IBM DB2 and PostgreSQL.";
      };

   };

    extraConfig = mkOption {
      default = "";
      type = types.lines;
      description = ''
        Configuration that is injected verbatim into the configuration file.
      '';
    };

  };

 };

  ###### implementation

  config = mkIf cfg.enable {

    services.postgresql = {
      enable = true;
      ensureDatabases = [ "zabbix" ];
      ensureUsers = [
        { name = "zabbix";
          ensurePermissions = { "DATABASE zabbix" = "ALL PRIVILEGES"; };
        }
      ];
    };

    users.users = singleton
      { name = "zabbix";
        uid = config.ids.uids.zabbix;
        description = "Zabbix daemon user";
      };

    systemd.tmpfiles.rules = [
        "d '${StateDirectory}' - zabbix - - -"
        "d '${LogsDirectory}' - zabbix - - -"
        "d '${RuntimeDirectory}' - zabbix - - -"
      ];

    systemd.services."zabbix-proxy" =
      { description = "Zabbix Proxy";
        wantedBy = [ "multi-user.target" ];
        after = optional useLocalPostgres "postgresql.service";

        path = with pkgs; [
          config.services.postgresql.package
          nettools
        ];

        preStart =
          ''
            # Handling the password from a file and its permissions
            DBPASS=$(head -n1 ${cfg.database.passwordFile})
            cp -r ${configFile} ${StateDirectory}/zabbix_proxy.conf
            sed -e "s,#dbpass#,$DBPASS,g" -i ${StateDirectory}/zabbix_proxy.conf
            chmod 440 ${StateDirectory}/zabbix_proxy.conf

            if ! test -e "${RuntimeDirectory}/db-schema-imported"; then
                cat ${pkgs.zabbix.server}/share/zabbix/db/schema/postgresql.sql | ${pkgs.postgresql}/bin/psql -U zabbix zabbix
                touch "${RuntimeDirectory}/db-schema-imported"
            fi
          '';

        serviceConfig = {
          ExecStart = "@${pkgs.zabbix.proxy}/sbin/zabbix_proxy zabbix_proxy --config ${configFile}";
          WorkingDirectory = RuntimeDirectory;
          User = "zabbix";
          Type = "forking";
          Restart = "always";
          RestartSec = 2;
          PIDFile = pidFile;
        };
      };

    services.logrotate = {
      enable = true;
      config = ''
        ${LogsDirectory}/*.log {
            daily
            rotate 7
            compress
            missingok
            notifempty
            create 0600 zabbix zabbix
        }
      '';
    };

  };

}
