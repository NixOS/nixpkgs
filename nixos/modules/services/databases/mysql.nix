{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mysql;

  mysql = cfg.package;

  isMariaDB = lib.getName mysql == lib.getName pkgs.mariadb;

  mysqldOptions =
    "--user=${cfg.user} --datadir=${cfg.dataDir} --basedir=${mysql}";

  settingsFile = pkgs.writeText "my.cnf" (
    generators.toINI { listsAsDuplicateKeys = true; } cfg.settings +
    optionalString (cfg.extraOptions != null) "[mysqld]\n${cfg.extraOptions}"
  );

  statementsScript = pkgs.writeText "startup.sql" cfg.statements;

in

{
  imports = [
    (mkRemovedOptionModule [ "services" "mysql" "pidDir" ] "Don't wait for pidfiles, describe dependencies through systemd")
    (mkRemovedOptionModule [ "services" "mysql" "rootPassword" ] "Use socket authentication or set the password outside of the nix store.")
    (mkRemovedOptionModule [ "services" "mysql" "initialDatabases" ] "This option often resulted in systems which weren't reproducible. If you wish to provision databases please review the services.mysql.statements option and carefully consider the pros and cons of this option with respect to reproduciblity.")
    (mkRemovedOptionModule [ "services" "mysql" "ensureDatabases" ] "This option often resulted in systems which weren't reproducible. If you wish to provision databases please review the services.mysql.statements option and carefully consider the pros and cons of this option with respect to reproduciblity.")
    (mkRemovedOptionModule [ "services" "mysql" "ensureUsers" ] "This option often resulted in systems which weren't reproducible. If you wish to provision databases please review the services.mysql.statements option and carefully consider the pros and cons of this option with respect to reproduciblity.")
  ];

  ###### interface

  options = {

    services.mysql = {

      enable = mkEnableOption "MySQL server";

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.mysql";
        description = "
          Which MySQL derivation to use. MariaDB packages are supported too.
        ";
      };

      bind = mkOption {
        type = types.nullOr types.str;
        default = null;
        example = literalExample "0.0.0.0";
        description = "Address to bind to. The default is to bind to all addresses";
      };

      port = mkOption {
        type = types.int;
        default = 3306;
        description = "Port of MySQL";
      };

      user = mkOption {
        type = types.str;
        default = "mysql";
        description = "User account under which MySQL runs";
      };

      dataDir = mkOption {
        type = types.path;
        example = "/var/lib/mysql";
        description = "Location where MySQL stores its table files";
      };

      configFile = mkOption {
        type = types.path;
        default = settingsFile;
        defaultText = "settingsFile";
        description = ''
          Override the configuration file used by MySQL. By default,
          NixOS generates one automatically from <option>services.mysql.settings</option>.
        '';
        example = literalExample ''
          pkgs.writeText "my.cnf" '''
            [mysqld]
            datadir = /var/lib/mysql
            bind-address = 127.0.0.1
            port = 3336

            !includedir /etc/mysql/conf.d/
          ''';
        '';
      };

      settings = mkOption {
        type = with types; attrsOf (attrsOf (oneOf [ bool int str (listOf str) ]));
        default = {};
        description = ''
          MySQL configuration. Refer to
          <link xlink:href="https://dev.mysql.com/doc/refman/5.7/en/server-system-variables.html"/>,
          <link xlink:href="https://dev.mysql.com/doc/refman/8.0/en/server-system-variables.html"/>,
          and <link xlink:href="https://mariadb.com/kb/en/server-system-variables/"/>
          for details on supported values.

          <note>
            <para>
              MySQL configuration options such as <literal>--quick</literal> should be treated as
              boolean options and provided values such as <literal>true</literal>, <literal>false</literal>,
              <literal>1</literal>, or <literal>0</literal>. See the provided example below.
            </para>
          </note>
        '';
        example = literalExample ''
          {
            mysqld = {
              key_buffer_size = "6G";
              table_cache = 1600;
              log-error = "/var/log/mysql_err.log";
              plugin-load-add = [ "server_audit" "ed25519=auth_ed25519" ];
            };
            mysqldump = {
              quick = true;
              max_allowed_packet = "16M";
            };
          }
        '';
      };

      statements = mkOption {
        type = types.lines;
        default = "";
        description = ''
          <emphasis>Idempotent</emphasis> SQL statements to be executed by MySQL. Useful for:
          <itemizedlist>
            <listitem><para>creating databases</para></listitem>
            <listitem><para>creating local accounts with socket authentication</para></listitem>
            <listitem><para>granting certain permissions on a database</para></listitem>
          </itemizedlist>

          <warning>
            <para>
              This should <emphasis>NOT</emphasis> contain any sensitive data such as credentials
              because the contents of this option will end up in the world readable nix store.
            </para>
            <para>
              Using this option can result in systems which are not reproducible, working against
              the general Nix philosophy. You are advised to exercise caution when using this
              option, carefully weighing the pros and cons with respect to reproduciblity.
            </para>
          </warning>
        '';
        example = literalExample ''
          create database if not exists `nextcloud`;
          create user if not exists 'nextcloud'@'localhost' identified with unix_socket;
          grant all privileges on nextcloud.* to 'nextcloud'@'localhost';
        '';
      };

      extraOptions = mkOption {
        type = with types; nullOr lines;
        default = null;
        example = ''
          key_buffer_size = 6G
          table_cache = 1600
          log-error = /var/log/mysql_err.log
        '';
        description = ''
          Provide extra options to the MySQL configuration file.

          Please note, that these options are added to the
          <literal>[mysqld]</literal> section so you don't need to explicitly
          state it again.
        '';
      };

      initialScript = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "A file containing SQL statements to be executed on the first startup. Can be used for granting certain permissions on the database";
      };

      replication = {
        role = mkOption {
          type = types.enum [ "master" "slave" "none" ];
          default = "none";
          description = "Role of the MySQL server instance.";
        };

        serverId = mkOption {
          type = types.int;
          default = 1;
          description = "Id of the MySQL server instance. This number must be unique for each instance";
        };

        masterHost = mkOption {
          type = types.str;
          description = "Hostname of the MySQL master server";
        };

        slaveHost = mkOption {
          type = types.str;
          description = "Hostname of the MySQL slave server";
        };

        masterUser = mkOption {
          type = types.str;
          description = "Username of the MySQL replication user";
        };

        masterPassword = mkOption {
          type = types.str;
          description = "Password of the MySQL replication user";
        };

        masterPort = mkOption {
          type = types.int;
          default = 3306;
          description = "Port number on which the MySQL master server runs";
        };
      };
    };

  };


  ###### implementation

  config = mkIf config.services.mysql.enable {

    warnings = optional (cfg.extraOptions != null) "services.mysql.`extraOptions` is deprecated, please use services.mysql.`settings`.";

    services.mysql.dataDir =
      mkDefault (if versionAtLeast config.system.stateVersion "17.09" then "/var/lib/mysql"
                 else "/var/mysql");

    services.mysql.settings.mysqld = mkMerge [
      {
        datadir = cfg.dataDir;
        bind-address = mkIf (cfg.bind != null) cfg.bind;
        port = cfg.port;
      }
      (mkIf (cfg.replication.role == "master" || cfg.replication.role == "slave") {
        log-bin = "mysql-bin-${toString cfg.replication.serverId}";
        log-bin-index = "mysql-bin-${toString cfg.replication.serverId}.index";
        relay-log = "mysql-relay-bin";
        server-id = cfg.replication.serverId;
        binlog-ignore-db = [ "information_schema" "performance_schema" "mysql" ];
      })
      (mkIf (!isMariaDB) {
        plugin-load-add = optional (cfg.ensureUsers != []) "auth_socket.so";
      })
    ];

    users.users.mysql = {
      description = "MySQL server user";
      group = "mysql";
      uid = config.ids.uids.mysql;
    };

    users.groups.mysql.gid = config.ids.gids.mysql;

    environment.systemPackages = [mysql];

    environment.etc."my.cnf".source = cfg.configFile;

    systemd.tmpfiles.rules = [
      "d '${cfg.dataDir}' 0700 ${cfg.user} mysql - -"
      "z '${cfg.dataDir}' 0700 ${cfg.user} mysql - -"
    ];

    systemd.services.mysql = let
      hasNotify = (cfg.package == pkgs.mariadb);
    in {
        description = "MySQL Server";

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ cfg.configFile statementsScript ];

        unitConfig.RequiresMountsFor = "${cfg.dataDir}";

        path = [
          # Needed for the mysql_install_db command in the preStart script
          # which calls the hostname command.
          pkgs.nettools
        ];

        preStart = if isMariaDB then ''
          if ! test -e ${cfg.dataDir}/mysql; then
            ${mysql}/bin/mysql_install_db --defaults-file=/etc/my.cnf ${mysqldOptions}
            touch ${cfg.dataDir}/mysql_init
          fi
        '' else ''
          if ! test -e ${cfg.dataDir}/mysql; then
            ${mysql}/bin/mysqld --defaults-file=/etc/my.cnf ${mysqldOptions} --initialize-insecure
            touch ${cfg.dataDir}/mysql_init
          fi
        '';

        serviceConfig = {
          Type = if hasNotify then "notify" else "simple";
          Restart = "on-abort";
          RestartSec = "5s";
          # The last two environment variables are used for starting Galera clusters
          ExecStart = "${mysql}/bin/mysqld --defaults-file=/etc/my.cnf ${mysqldOptions} $_WSREP_NEW_CLUSTER $_WSREP_START_POSITION";
          ExecStartPost =
            let
              setupScript = pkgs.writeScript "mysql-setup" ''
                #!${pkgs.runtimeShell} -e

                ${optionalString (!hasNotify) ''
                  # Wait until the MySQL server is available for use
                  count=0
                  while [ ! -e /run/mysqld/mysqld.sock ]
                  do
                      if [ $count -eq 30 ]
                      then
                          echo "Tried 30 times, giving up..."
                          exit 1
                      fi

                      echo "MySQL daemon not yet started. Waiting for 1 second..."
                      count=$((count++))
                      sleep 1
                  done
                ''}

                if [ -f ${cfg.dataDir}/mysql_init ]
                then
                    ${optionalString (cfg.replication.role == "master")
                      ''
                        # Set up the replication master

                        ( echo "use mysql;"
                          echo "CREATE USER '${cfg.replication.masterUser}'@'${cfg.replication.slaveHost}' IDENTIFIED WITH mysql_native_password;"
                          echo "SET PASSWORD FOR '${cfg.replication.masterUser}'@'${cfg.replication.slaveHost}' = PASSWORD('${cfg.replication.masterPassword}');"
                          echo "GRANT REPLICATION SLAVE ON *.* TO '${cfg.replication.masterUser}'@'${cfg.replication.slaveHost}';"
                        ) | ${mysql}/bin/mysql -u root -N
                      ''}

                    ${optionalString (cfg.replication.role == "slave")
                      ''
                        # Set up the replication slave

                        ( echo "stop slave;"
                          echo "change master to master_host='${cfg.replication.masterHost}', master_user='${cfg.replication.masterUser}', master_password='${cfg.replication.masterPassword}';"
                          echo "start slave;"
                        ) | ${mysql}/bin/mysql -u root -N
                      ''}

                    ${optionalString (cfg.initialScript != null)
                      ''
                        # Execute initial script
                        # using toString to avoid copying the file to nix store if given as path instead of string,
                        # as it might contain credentials
                        cat ${toString cfg.initialScript} | ${mysql}/bin/mysql -u root -N
                      ''}

                    rm ${cfg.dataDir}/mysql_init
                fi

                ${cfg.package}/bin/mysql -u root -N < ${statementsScript}
              '';
            in
              # various scripts currently require being run as root when the user has secured their mysql install
              "+${setupScript}";
          # User and group
          User = cfg.user;
          Group = "mysql";
          # Runtime directory and mode
          RuntimeDirectory = "mysqld";
          RuntimeDirectoryMode = "0755";
          # Access write directories
          ReadWritePaths = [ cfg.dataDir ];
          # Capabilities
          CapabilityBoundingSet = "";
          # Security
          NoNewPrivileges = true;
          # Sandboxing
          ProtectSystem = "strict";
          ProtectHome = true;
          PrivateTmp = true;
          PrivateDevices = true;
          ProtectHostname = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectControlGroups = true;
          RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
          PrivateMounts = true;
          # System Call Filtering
          SystemCallArchitectures = "native";
        };
      };

  };

}
