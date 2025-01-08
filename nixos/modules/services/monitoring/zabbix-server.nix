{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  cfg = config.services.zabbixServer;
  opt = options.services.zabbixServer;
  pgsql = config.services.postgresql;
  mysql = config.services.mysql;

  inherit (lib.generators) toKeyValue;

  user = "zabbix";
  group = "zabbix";
  runtimeDir = "/run/zabbix";
  stateDir = "/var/lib/zabbix";
  passwordFile = "${runtimeDir}/zabbix-dbpassword.conf";

  moduleEnv = pkgs.symlinkJoin {
    name = "zabbix-server-module-env";
    paths = lib.attrValues cfg.modules;
  };

  configFile = pkgs.writeText "zabbix_server.conf" (
    toKeyValue { listsAsDuplicateKeys = true; } cfg.settings
  );

  mysqlLocal = cfg.database.createLocally && cfg.database.type == "mysql";
  pgsqlLocal = cfg.database.createLocally && cfg.database.type == "pgsql";

in

{
  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "zabbixServer" "dbServer" ]
      [ "services" "zabbixServer" "database" "host" ]
    )
    (lib.mkRemovedOptionModule [
      "services"
      "zabbixServer"
      "dbPassword"
    ] "Use services.zabbixServer.database.passwordFile instead.")
    (lib.mkRemovedOptionModule [
      "services"
      "zabbixServer"
      "extraConfig"
    ] "Use services.zabbixServer.settings instead.")
  ];

  # interface

  options = {

    services.zabbixServer = {
      enable = lib.mkEnableOption "the Zabbix Server";

      package = lib.mkOption {
        type = lib.types.package;
        default =
          if cfg.database.type == "mysql" then pkgs.zabbix.server-mysql else pkgs.zabbix.server-pgsql;
        defaultText = lib.literalExpression "pkgs.zabbix.server-pgsql";
        description = "The Zabbix package to use.";
      };

      extraPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = with pkgs; [
          nettools
          nmap
          traceroute
        ];
        defaultText = lib.literalExpression "[ nettools nmap traceroute ]";
        description = ''
          Packages to be added to the Zabbix {env}`PATH`.
          Typically used to add executables for scripts, but can be anything.
        '';
      };

      modules = lib.mkOption {
        type = lib.types.attrsOf lib.types.package;
        description = "A set of modules to load.";
        default = { };
        example = lib.literalExpression ''
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
        type = lib.mkOption {
          type = lib.types.enum [
            "mysql"
            "pgsql"
          ];
          example = "mysql";
          default = "pgsql";
          description = "Database engine to use.";
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = "Database host address.";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = if cfg.database.type == "mysql" then mysql.port else pgsql.settings.port;
          defaultText = lib.literalExpression ''
            if config.${opt.database.type} == "mysql"
            then config.${options.services.mysql.port}
            else config.services.postgresql.settings.port
          '';
          description = "Database host port.";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "zabbix";
          description = "Database name.";
        };

        user = lib.mkOption {
          type = lib.types.str;
          default = "zabbix";
          description = "Database user.";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/keys/zabbix-dbpassword";
          description = ''
            A file containing the password corresponding to
            {option}`database.user`.
          '';
        };

        socket = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          example = "/run/postgresql";
          description = "Path to the unix socket file to use for authentication.";
        };

        createLocally = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Whether to create a local database automatically.";
        };
      };

      listen = {
        ip = lib.mkOption {
          type = lib.types.str;
          default = "0.0.0.0";
          description = ''
            List of comma delimited IP addresses that the trapper should listen on.
            Trapper will listen on all network interfaces if this parameter is missing.
          '';
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 10051;
          description = ''
            Listen port for trapper.
          '';
        };
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Open ports in the firewall for the Zabbix Server.
        '';
      };

      settings = lib.mkOption {
        type =
          with lib.types;
          attrsOf (oneOf [
            int
            str
            (listOf str)
          ]);
        default = { };
        description = ''
          Zabbix Server configuration. Refer to
          <https://www.zabbix.com/documentation/current/manual/appendix/config/zabbix_server>
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

  config = lib.mkIf cfg.enable {

    assertions = [
      {
        assertion =
          cfg.database.createLocally -> cfg.database.user == user && cfg.database.user == cfg.database.name;
        message = "services.zabbixServer.database.user must be set to ${user} if services.zabbixServer.database.createLocally is set true";
      }
      {
        assertion = cfg.database.createLocally -> cfg.database.passwordFile == null;
        message = "a password cannot be specified if services.zabbixServer.database.createLocally is set to true";
      }
    ];

    services.zabbixServer.settings = lib.mkMerge [
      {
        LogType = "console";
        ListenIP = cfg.listen.ip;
        ListenPort = cfg.listen.port;
        # TODO: set to cfg.database.socket if database type is pgsql?
        DBHost = lib.optionalString (cfg.database.createLocally != true) cfg.database.host;
        DBName = cfg.database.name;
        DBUser = cfg.database.user;
        PidFile = "${runtimeDir}/zabbix_server.pid";
        SocketDir = runtimeDir;
        FpingLocation = "/run/wrappers/bin/fping";
        LoadModule = builtins.attrNames cfg.modules;
      }
      (lib.mkIf (cfg.database.createLocally != true) { DBPort = cfg.database.port; })
      (lib.mkIf (cfg.database.passwordFile != null) { Include = [ "${passwordFile}" ]; })
      (lib.mkIf (mysqlLocal && cfg.database.socket != null) { DBSocket = cfg.database.socket; })
      (lib.mkIf (cfg.modules != { }) { LoadModulePath = "${moduleEnv}/lib"; })
    ];

    networking.firewall = lib.mkIf cfg.openFirewall {
      allowedTCPPorts = [ cfg.listen.port ];
    };

    services.mysql = lib.optionalAttrs mysqlLocal {
      enable = true;
      package = lib.mkDefault pkgs.mariadb;
    };

    systemd.services.mysql.postStart = lib.mkAfter (
      lib.optionalString mysqlLocal ''
        ( echo "CREATE DATABASE IF NOT EXISTS \`${cfg.database.name}\` CHARACTER SET utf8 COLLATE utf8_bin;"
          echo "CREATE USER IF NOT EXISTS '${cfg.database.user}'@'localhost' IDENTIFIED WITH ${
            if (lib.getName config.services.mysql.package == lib.getName pkgs.mariadb) then
              "unix_socket"
            else
              "auth_socket"
          };"
          echo "GRANT ALL PRIVILEGES ON \`${cfg.database.name}\`.* TO '${cfg.database.user}'@'localhost';"
        ) | ${config.services.mysql.package}/bin/mysql -N
      ''
    );

    services.postgresql = lib.optionalAttrs pgsqlLocal {
      enable = true;
      ensureDatabases = [ cfg.database.name ];
      ensureUsers = [
        {
          name = cfg.database.user;
          ensureDBOwnership = true;
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
      fping = {
        setuid = true;
        owner = "root";
        group = "root";
        source = "${pkgs.fping}/bin/fping";
      };
    };

    systemd.services.zabbix-server = {
      description = "Zabbix Server";

      wantedBy = [ "multi-user.target" ];
      after = lib.optional mysqlLocal "mysql.service" ++ lib.optional pgsqlLocal "postgresql.service";

      path = [ "/run/wrappers" ] ++ cfg.extraPackages;
      preStart =
        ''
          # pre 19.09 compatibility
          if test -e "${runtimeDir}/db-created"; then
            mv "${runtimeDir}/db-created" "${stateDir}/"
          fi
        ''
        + lib.optionalString pgsqlLocal ''
          if ! test -e "${stateDir}/db-created"; then
            cat ${cfg.package}/share/zabbix/database/postgresql/schema.sql | ${pgsql.package}/bin/psql ${cfg.database.name}
            cat ${cfg.package}/share/zabbix/database/postgresql/images.sql | ${pgsql.package}/bin/psql ${cfg.database.name}
            cat ${cfg.package}/share/zabbix/database/postgresql/data.sql | ${pgsql.package}/bin/psql ${cfg.database.name}
            touch "${stateDir}/db-created"
          fi
        ''
        + lib.optionalString mysqlLocal ''
          if ! test -e "${stateDir}/db-created"; then
            cat ${cfg.package}/share/zabbix/database/mysql/schema.sql | ${mysql.package}/bin/mysql ${cfg.database.name}
            cat ${cfg.package}/share/zabbix/database/mysql/images.sql | ${mysql.package}/bin/mysql ${cfg.database.name}
            cat ${cfg.package}/share/zabbix/database/mysql/data.sql | ${mysql.package}/bin/mysql ${cfg.database.name}
            touch "${stateDir}/db-created"
          fi
        ''
        + lib.optionalString (cfg.database.passwordFile != null) ''
          # create a copy of the supplied password file in a format zabbix can consume
          install -m 0600 <(echo "DBPassword = $(cat ${cfg.database.passwordFile})") ${passwordFile}
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
      lib.optional (config.services.zabbixWeb.enable && mysqlLocal) "mysql.service"
      ++ lib.optional (config.services.zabbixWeb.enable && pgsqlLocal) "postgresql.service";

  };

}
