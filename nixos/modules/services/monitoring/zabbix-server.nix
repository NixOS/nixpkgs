{ config, lib, pkgs, ... }:

let
  cfg = config.services.zabbixServer;
  pgsql = config.services.postgresql;
  mysql = config.services.mysql;

  inherit (lib) mkDefault mkEnableOption mkIf mkMerge mkOption;
  inherit (lib) attrValues concatMapStringsSep literalExample optional optionalAttrs optionalString types;
  inherit (lib.generators) toKeyValue;

  user = "zabbix";
  group = "zabbix";
  runtimeDir = "/run/zabbix";
  stateDir = "/var/lib/zabbix";
  passwordFile = "${runtimeDir}/zabbix-dbpassword.conf";

  moduleEnv = pkgs.symlinkJoin {
    name = "zabbix-server-module-env";
    paths = attrValues cfg.modules;
  };

  configFile = pkgs.writeText "zabbix_server.conf" (toKeyValue { listsAsDuplicateKeys = true; } cfg.settings);

  mysqlLocal = cfg.database.createLocally && cfg.database.type == "mysql";
  pgsqlLocal = cfg.database.createLocally && cfg.database.type == "pgsql";

in

{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "zabbixServer" "dbServer" ] [ "services" "zabbixServer" "database" "host" ])
    (lib.mkRemovedOptionModule [ "services" "zabbixServer" "dbPassword" ] "Use services.zabbixServer.database.passwordFile instead.")
    (lib.mkRemovedOptionModule [ "services" "zabbixServer" "extraConfig" ] "Use services.zabbixServer.settings instead.")
  ];

  # interface

  options = {

    services.zabbixServer = {
      enable = mkEnableOption "the Zabbix Server";

      package = mkOption {
        type = types.package;
        default = if cfg.database.type == "mysql" then pkgs.zabbix.server-mysql else pkgs.zabbix.server-pgsql;
        defaultText = "pkgs.zabbix.server-pgsql";
        description = "The Zabbix package to use.";
      };

      extraPackages = mkOption {
        type = types.listOf types.package;
        default = with pkgs; [ nettools nmap traceroute ];
        defaultText = "[ nettools nmap traceroute ]";
        description = ''
          Packages to be added to the Zabbix <envar>PATH</envar>.
          Typically used to add executables for scripts, but can be anything.
        '';
      };

      modules = mkOption {
        type = types.attrsOf types.package;
        description = "A set of modules to load.";
        default = {};
        example = literalExample ''
          {
            "dummy.so" = pkgs.stdenv.mkDerivation {
              name = "zabbix-dummy-module-''${cfg.package.version}";
              src = cfg.package.src;
              buildInputs = [ cfg.package ];
              sourceRoot = "zabbix-''${cfg.package.version}/src/modules/dummy";
              installPhase = '''
                mkdir -p $out/lib
                cp dummy.so $out/lib/
              ''';
            };
          }
        '';
      };

      database = {
        type = mkOption {
          type = types.enum [ "mysql" "pgsql" ];
          example = "mysql";
          default = "pgsql";
          description = "Database engine to use.";
        };

        host = mkOption {
          type = types.str;
          default = "localhost";
          description = "Database host address.";
        };

        port = mkOption {
          type = types.int;
          default = if cfg.database.type == "mysql" then mysql.port else pgsql.port;
          description = "Database host port.";
        };

        name = mkOption {
          type = types.str;
          default = "zabbix";
          description = "Database name.";
        };

        user = mkOption {
          type = types.str;
          default = "zabbix";
          description = "Database user.";
        };

        passwordFile = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/keys/zabbix-dbpassword";
          description = ''
            A file containing the password corresponding to
            <option>database.user</option>.
          '';
        };

        socket = mkOption {
          type = types.nullOr types.path;
          default = null;
          example = "/run/postgresql";
          description = "Path to the unix socket file to use for authentication.";
        };

        createLocally = mkOption {
          type = types.bool;
          default = true;
          description = "Whether to create a local database automatically.";
        };
      };

      listen = {
        ip = mkOption {
          type = types.str;
          default = "0.0.0.0";
          description = ''
            List of comma delimited IP addresses that the trapper should listen on.
            Trapper will listen on all network interfaces if this parameter is missing.
          '';
        };

        port = mkOption {
          type = types.port;
          default = 10051;
          description = ''
            Listen port for trapper.
          '';
        };
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Zabbix Server.
        '';
      };

      settings = mkOption {
        type = with types; attrsOf (oneOf [ int str (listOf str) ]);
        default = {};
        description = ''
          Zabbix Server configuration. Refer to
          <link xlink:href="https://www.zabbix.com/documentation/current/manual/appendix/config/zabbix_server"/>
          for details on supported values.
        '';
        example = {
          CacheSize = "1G";
          SSHKeyLocation = "/var/lib/zabbix/.ssh";
          StartPingers = 32;
        };
      };

    };

  };

  # implementation

  config = mkIf cfg.enable {

    assertions = [
      { assertion = cfg.database.createLocally -> cfg.database.user == user;
        message = "services.zabbixServer.database.user must be set to ${user} if services.zabbixServer.database.createLocally is set true";
      }
      { assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.zabbixServer.database.createLocally is set to true";
      }
    ];

    services.zabbixServer.settings = mkMerge [
      {
        LogType = "console";
        ListenIP = cfg.listen.ip;
        ListenPort = cfg.listen.port;
        # TODO: set to cfg.database.socket if database type is pgsql?
        DBHost = optionalString (cfg.database.createLocally != true) cfg.database.host;
        DBName = cfg.database.name;
        DBUser = cfg.database.user;
        PidFile = "${runtimeDir}/zabbix_server.pid";
        SocketDir = runtimeDir;
        FpingLocation = "/run/wrappers/bin/fping";
        LoadModule = builtins.attrNames cfg.modules;
      }
      (mkIf (cfg.database.createLocally != true) { DBPort = cfg.database.port; })
      (mkIf (cfg.database.passwordFile != null) { Include = [ "${passwordFile}" ]; })
      (mkIf (mysqlLocal && cfg.database.socket != null) { DBSocket = cfg.database.socket; })
      (mkIf (cfg.modules != {}) { LoadModulePath = "${moduleEnv}/lib"; })
    ];

    networking.firewall = mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ];
    };

    services.mysql = optionalAttrs mysqlLocal {
      enable = true;
      package = mkDefault pkgs.mariadb;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "${cfg.database.name}.*" = "ALL PRIVILEGES"; };
        }
      ];
    };

    services.postgresql = optionalAttrs pgsqlLocal {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        { name = cfg.database.user;
          ensurePermissions = { "DATABASE ${cfg.database.name}" = "ALL PRIVILEGES"; };
        }
      ];
    };

    users.users.${user} = {
      description = "Zabbix daemon user";
      uid = config.ids.uids.zabbix;
      inherit group;
    };

    users.groups.${group} = {
      gid = config.ids.gids.zabbix;
    };

    security.wrappers = {
      fping.source = "${pkgs.fping}/bin/fping";
    };

    systemd.services.zabbix-server = {
      description = "Zabbix Server";

      wantedBy = [ "multi-user.target" ];
      after = optional mysqlLocal "mysql.service" ++ optional pgsqlLocal "postgresql.service";

      path = [ "/run/wrappers" ] ++ cfg.extraPackages;
      preStart = ''
        # pre 19.09 compatibility
        if test -e "${runtimeDir}/db-created"; then
          mv "${runtimeDir}/db-created" "${stateDir}/"
        fi
      '' + optionalString pgsqlLocal ''
        if ! test -e "${stateDir}/db-created"; then
          cat ${cfg.package}/share/zabbix/database/postgresql/schema.sql | ${pgsql.package}/bin/psql ${cfg.database.name}
          cat ${cfg.package}/share/zabbix/database/postgresql/images.sql | ${pgsql.package}/bin/psql ${cfg.database.name}
          cat ${cfg.package}/share/zabbix/database/postgresql/data.sql | ${pgsql.package}/bin/psql ${cfg.database.name}
          touch "${stateDir}/db-created"
        fi
      '' + optionalString mysqlLocal ''
        if ! test -e "${stateDir}/db-created"; then
          cat ${cfg.package}/share/zabbix/database/mysql/schema.sql | ${mysql.package}/bin/mysql ${cfg.database.name}
          cat ${cfg.package}/share/zabbix/database/mysql/images.sql | ${mysql.package}/bin/mysql ${cfg.database.name}
          cat ${cfg.package}/share/zabbix/database/mysql/data.sql | ${mysql.package}/bin/mysql ${cfg.database.name}
          touch "${stateDir}/db-created"
        fi
      '' + optionalString (cfg.database.passwordFile != null) ''
        # create a copy of the supplied password file in a format zabbix can consume
        touch ${passwordFile}
        chmod 0600 ${passwordFile}
        echo -n "DBPassword = " > ${passwordFile}
        cat ${cfg.database.passwordFile} >> ${passwordFile}
      '';

      serviceConfig = {
        ExecStart = "@${cfg.package}/sbin/zabbix_server zabbix_server -f --config ${configFile}";
        Restart = "always";
        RestartSec = 2;

        User = user;
        Group = group;
        RuntimeDirectory = "zabbix";
        StateDirectory = "zabbix";
        PrivateTmp = true;
      };
    };

    systemd.services.httpd.after =
      optional (config.services.zabbixWeb.enable && mysqlLocal) "mysql.service" ++
      optional (config.services.zabbixWeb.enable && pgsqlLocal) "postgresql.service";

  };

}
