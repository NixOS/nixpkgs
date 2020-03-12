{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mysql;

  mysql = cfg.package;

  isMariaDB = lib.getName mysql == lib.getName pkgs.mariadb;

  isMysqlAtLeast57 =
    (lib.getName mysql == lib.getName pkgs.mysql57)
     && (builtins.compareVersions mysql.version "5.7" >= 0);

  mysqldOptions =
    "--user=${cfg.user} --datadir=${cfg.dataDir} --basedir=${mysql}";
  # For MySQL 5.7+, --insecure creates the root user without password
  # (earlier versions and MariaDB do this by default).
  installOptions =
    "${mysqldOptions} ${lib.optionalString isMysqlAtLeast57 "--insecure"}";

  settingsFile = pkgs.writeText "my.cnf" (
    generators.toINI { listsAsDuplicateKeys = true; } cfg.settings +
    optionalString (cfg.extraOptions != null) "[mysqld]\n${cfg.extraOptions}"
  );

in

{
  imports = [
    (mkRemovedOptionModule [ "services" "mysql" "pidDir" ] "Don't wait for pidfiles, describe dependencies through systemd")
    (mkRemovedOptionModule [ "services" "mysql" "rootPassword" ] "Use socket authentication or set the password outside of the nix store.")
  ];

  ###### interface

  options = {

    services.mysql = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "
          Whether to enable the MySQL server.
        ";
      };

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
            plugin-load-add = auth_socket.so

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

      initialDatabases = mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = ''
                The name of the database to create.
              '';
            };
            schema = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = ''
                The initial schema of the database; if null (the default),
                an empty database is created.
              '';
            };
          };
        });
        default = [];
        description = ''
          List of database names and their initial schemas that should be used to create databases on the first startup
          of MySQL. The schema attribute is optional: If not specified, an empty database is created.
        '';
        example = [
          { name = "foodatabase"; schema = literalExample "./foodatabase.sql"; }
          { name = "bardatabase"; }
        ];
      };

      initialScript = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "A file containing SQL statements to be executed on the first startup. Can be used for granting certain permissions on the database";
      };

      ensureDatabases = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          Ensures that the specified databases exist.
          This option will never delete existing databases, especially not when the value of this
          option is changed. This means that databases created once through this option or
          otherwise have to be removed manually.
        '';
        example = [
          "nextcloud"
          "matomo"
        ];
      };

      ensureUsers = mkOption {
        type = types.listOf (types.submodule {
          options = {
            name = mkOption {
              type = types.str;
              description = ''
                Name of the user to ensure.
              '';
            };
            ensurePermissions = mkOption {
              type = types.attrsOf types.str;
              default = {};
              description = ''
                Permissions to ensure for the user, specified as attribute set.
                The attribute names specify the database and tables to grant the permissions for,
                separated by a dot. You may use wildcards here.
                The attribute values specfiy the permissions to grant.
                You may specify one or multiple comma-separated SQL privileges here.

                For more information on how to specify the target
                and on which privileges exist, see the
                <link xlink:href="https://mariadb.com/kb/en/library/grant/">GRANT syntax</link>.
                The attributes are used as <code>GRANT ''${attrName} ON ''${attrValue}</code>.
              '';
              example = literalExample ''
                {
                  "database.*" = "ALL PRIVILEGES";
                  "*.*" = "SELECT, LOCK TABLES";
                }
              '';
            };
          };
        });
        default = [];
        description = ''
          Ensures that the specified users exist and have at least the ensured permissions.
          The MySQL users will be identified using Unix socket authentication. This authenticates the Unix user with the
          same name only, and that without the need for a password.
          This option will never delete existing users or remove permissions, especially not when the value of this
          option is changed. This means that users created and permissions assigned once through this option or
          otherwise have to be removed manually.
        '';
        example = literalExample ''
          [
            {
              name = "nextcloud";
              ensurePermissions = {
                "nextcloud.*" = "ALL PRIVILEGES";
              };
            }
            {
              name = "backup";
              ensurePermissions = {
                "*.*" = "SELECT, LOCK TABLES";
              };
            }
          ]
        '';
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
        plugin-load-add = optional (cfg.ensureUsers != []) "auth_socket.so";
      }
      (mkIf (cfg.replication.role == "master" || cfg.replication.role == "slave") {
        log-bin = "mysql-bin-${toString cfg.replication.serverId}";
        log-bin-index = "mysql-bin-${toString cfg.replication.serverId}.index";
        relay-log = "mysql-relay-bin";
        server-id = cfg.replication.serverId;
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
      "d '${cfg.dataDir}' 0700 ${cfg.user} mysql -"
    ];

    systemd.services.mysql = let
      hasNotify = (cfg.package == pkgs.mariadb);
    in {
        description = "MySQL Server";

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        restartTriggers = [ cfg.configFile ];

        unitConfig.RequiresMountsFor = "${cfg.dataDir}";

        path = [
          # Needed for the mysql_install_db command in the preStart script
          # which calls the hostname command.
          pkgs.nettools
        ];

        preStart = ''
          if ! test -e ${cfg.dataDir}/mysql; then
            ${mysql}/bin/mysql_install_db --defaults-file=/etc/my.cnf ${installOptions}
            touch /tmp/mysql_init
          fi
        '';

        serviceConfig = {
          User = cfg.user;
          Group = "mysql";
          Type = if hasNotify then "notify" else "simple";
          RuntimeDirectory = "mysqld";
          RuntimeDirectoryMode = "0755";
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

                if [ -f /tmp/mysql_init ]
                then
                    ${concatMapStrings (database: ''
                      # Create initial databases
                      if ! test -e "${cfg.dataDir}/${database.name}"; then
                          echo "Creating initial database: ${database.name}"
                          ( echo 'create database `${database.name}`;'

                            ${optionalString (database.schema != null) ''
                            echo 'use `${database.name}`;'

                            # TODO: this silently falls through if database.schema does not exist,
                            # we should catch this somehow and exit, but can't do it here because we're in a subshell.
                            if [ -f "${database.schema}" ]
                            then
                                cat ${database.schema}
                            elif [ -d "${database.schema}" ]
                            then
                                cat ${database.schema}/mysql-databases/*.sql
                            fi
                            ''}
                          ) | ${mysql}/bin/mysql -u root -N
                      fi
                    '') cfg.initialDatabases}

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
                          echo "set global slave_exec_mode='IDEMPOTENT';"
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

                    rm /tmp/mysql_init
                fi

                ${optionalString (cfg.ensureDatabases != []) ''
                  (
                  ${concatMapStrings (database: ''
                    echo "CREATE DATABASE IF NOT EXISTS \`${database}\`;"
                  '') cfg.ensureDatabases}
                  ) | ${mysql}/bin/mysql -u root -N
                ''}

                ${concatMapStrings (user:
                  ''
                    ( echo "CREATE USER IF NOT EXISTS '${user.name}'@'localhost' IDENTIFIED WITH ${if isMariaDB then "unix_socket" else "auth_socket"};"
                      ${concatStringsSep "\n" (mapAttrsToList (database: permission: ''
                        echo "GRANT ${permission} ON ${database} TO '${user.name}'@'localhost';"
                      '') user.ensurePermissions)}
                    ) | ${mysql}/bin/mysql -u root -N
                  '') cfg.ensureUsers}
              '';
            in
              # ensureDatbases & ensureUsers depends on this script being run as root
              # when the user has secured their mysql install
              "+${setupScript}";
        };
      };

  };

}
