{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.mysql;

  mysql = cfg.package;

  isMariaDB =
    let
      pName = _p: (builtins.parseDrvName (_p.name)).name;
    in pName mysql == pName pkgs.mariadb;
  isMysqlAtLeast57 =
    let
      pName = _p: (builtins.parseDrvName (_p.name)).name;
    in (pName mysql == pName pkgs.mysql57)
       && ((builtins.compareVersions mysql.version "5.7") >= 0);

  pidFile = "${cfg.pidDir}/mysqld.pid";

  mysqldAndInstallOptions =
    "--user=${cfg.user} --datadir=${cfg.dataDir} --basedir=${mysql}";
  mysqldOptions =
    "${mysqldAndInstallOptions} --pid-file=${pidFile}";
  # For MySQL 5.7+, --insecure creates the root user without password
  # (earlier versions and MariaDB do this by default).
  installOptions =
    "${mysqldAndInstallOptions} ${lib.optionalString isMysqlAtLeast57 "--insecure"}";

in

{

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

      pidDir = mkOption {
        default = "/run/mysqld";
        description = "Location of the file which stores the PID of the MySQL server";
      };

      extraOptions = mkOption {
        type = types.lines;
        default = "";
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
        default = null;
        description = "A file containing SQL statements to be executed on the first startup. Can be used for granting certain permissions on the database";
      };

      ensureDatabases = mkOption {
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
        default = [];
        description = ''
          Ensures that the specified users exist and have at least the ensured permissions.
          The MySQL users will be identified using Unix socket authentication. This authenticates the Unix user with the
          same name only, and that without the need for a password.
          This option will never delete existing users or remove permissions, especially not when the value of this
          option is changed. This means that users created and permissions assigned once through this option or
          otherwise have to be removed manually.
        '';
        example = literalExample ''[
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
        ]'';
      };

      # FIXME: remove this option; it's a really bad idea.
      rootPassword = mkOption {
        default = null;
        description = "Path to a file containing the root password, modified on the first startup. Not specifying a root password will leave the root password empty.";
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

    services.mysql.dataDir =
      mkDefault (if versionAtLeast config.system.stateVersion "17.09" then "/var/lib/mysql"
                 else "/var/mysql");

    users.users.mysql = {
      description = "MySQL server user";
      group = "mysql";
      uid = config.ids.uids.mysql;
    };

    users.groups.mysql.gid = config.ids.gids.mysql;

    environment.systemPackages = [mysql];

    environment.etc."my.cnf".text =
    ''
      [mysqld]
      port = ${toString cfg.port}
      datadir = ${cfg.dataDir}
      ${optionalString (cfg.bind != null) "bind-address = ${cfg.bind}" }
      ${optionalString (cfg.replication.role == "master" || cfg.replication.role == "slave") "log-bin=mysql-bin"}
      ${optionalString (cfg.replication.role == "master" || cfg.replication.role == "slave") "server-id = ${toString cfg.replication.serverId}"}
      ${optionalString (cfg.ensureUsers != [])
      ''
        plugin-load-add = auth_socket.so
      ''}
      ${cfg.extraOptions}
    '';

    systemd.services.mysql = let
      hasNotify = (cfg.package == pkgs.mariadb);
    in {
        description = "MySQL Server";

        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];

        unitConfig.RequiresMountsFor = "${cfg.dataDir}";

        path = [
          # Needed for the mysql_install_db command in the preStart script
          # which calls the hostname command.
          pkgs.nettools
        ];

        preStart =
          ''
            if ! test -e ${cfg.dataDir}/mysql; then
                mkdir -m 0700 -p ${cfg.dataDir}
                chown -R ${cfg.user} ${cfg.dataDir}
                ${mysql}/bin/mysql_install_db --defaults-file=/etc/my.cnf ${installOptions}
                touch /tmp/mysql_init
            fi

            mkdir -m 0755 -p ${cfg.pidDir}
            chown -R ${cfg.user} ${cfg.pidDir}
          '';

        serviceConfig = {
          Type = if hasNotify then "notify" else "simple";
          RuntimeDirectory = "mysqld";
          ExecStart = "${mysql}/bin/mysqld --defaults-file=/etc/my.cnf ${mysqldOptions}";
        };

        postStart = ''
          ${lib.optionalString (!hasNotify) ''
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
                ${concatMapStrings (database:
                  ''
                    # Create initial databases
                    if ! test -e "${cfg.dataDir}/${database.name}"; then
                        echo "Creating initial database: ${database.name}"
                        ( echo 'create database `${database.name}`;'

                          ${optionalString (database ? "schema") ''
                          echo 'use `${database.name}`;'

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
                      echo "start slave;"
                    ) | ${mysql}/bin/mysql -u root -N
                  ''}

                ${optionalString (cfg.initialScript != null)
                  ''
                    # Execute initial script
                    cat ${cfg.initialScript} | ${mysql}/bin/mysql -u root -N
                  ''}

                ${optionalString (cfg.rootPassword != null)
                  ''
                    # Change root password

                    ( echo "use mysql;"
                      echo "update user set Password=password('$(cat ${cfg.rootPassword})') where User='root';"
                      echo "flush privileges;"
                    ) | ${mysql}/bin/mysql -u root -N
                  ''}

              rm /tmp/mysql_init
            fi

            ${optionalString (cfg.ensureDatabases != []) ''
              (
              ${concatMapStrings (database: ''
                echo "CREATE DATABASE IF NOT EXISTS ${database};"
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

          ''; # */
      };

  };

}
