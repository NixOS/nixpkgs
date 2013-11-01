{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.mysql55;

  mysql = cfg.package;

  pidFile = "${cfg.pidDir}/mysqld.pid";

  mysqldOptions =
    "--user=${cfg.user} --datadir=${cfg.dataDir} " +
    "--pid-file=${pidFile}";

  myCnf = pkgs.writeText "my.cnf"
  ''
    [mysqld]
    ${optionalString (cfg.replication.role == "master" || cfg.replication.role == "slave") "log-bin=mysql-bin"}
    ${optionalString (cfg.replication.role == "master" || cfg.replication.role == "slave") "server-id = ${toString cfg.replication.serverId}"}
    ${cfg.extraOptions}
  '';

in

{

  ###### interface

  options = {

    services.mysql55 = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the MySQL server.
        ";
      };

      package = mkOption {
        default = pkgs.mysql55;
        description = "
          Which MySQL derivation to use.
        ";
      };

      port = mkOption {
        default = "3306";
        description = "Port of MySQL";
      };

      user = mkOption {
        default = "mysql";
        description = "User account under which MySQL runs";
      };

      dataDir = mkOption {
        default = "/var/mysql"; # !!! should be /var/db/mysql
        description = "Location where MySQL stores its table files";
      };

      pidDir = mkOption {
        default = "/var/run/mysql";
        description = "Location of the file which stores the PID of the MySQL server";
      };

      extraOptions = mkOption {
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
        description = "List of database names and their initial schemas that should be used to create databases on the first startup of MySQL";
        example = [
          { name = "foodatabase"; schema = literalExample "./foodatabase.sql"; }
          { name = "bardatabase"; schema = literalExample "./bardatabase.sql"; }
        ];
      };

      initialScript = mkOption {
        default = null;
        description = "A file containing SQL statements to be executed on the first startup. Can be used for granting certain permissions on the database";
      };

      # FIXME: remove this option; it's a really bad idea.
      rootPassword = mkOption {
        default = null;
        description = "Path to a file containing the root password, modified on the first startup. Not specifying a root password will leave the root password empty.";
      };

      replication = {
        role = mkOption {
          default = "none";
          description = "Role of the MySQL server instance. Can be either: master, slave or none";
        };

        serverId = mkOption {
          default = 1;
          description = "Id of the MySQL server instance. This number must be unique for each instance";
        };

        masterHost = mkOption {
          description = "Hostname of the MySQL master server";
        };

        masterUser = mkOption {
          description = "Username of the MySQL replication user";
        };

        masterPassword = mkOption {
          description = "Password of the MySQL replication user";
        };

        masterPort = mkOption {
          default = 3306;
          description = "Port number on which the MySQL master server runs";
        };
      };
    };

  };


  ###### implementation

  config = mkIf config.services.mysql55.enable {

    users.extraUsers.mysql = {
      description = "MySQL server user";
      group = "mysql";
      uid = config.ids.uids.mysql;
    };

    users.extraGroups.mysql.gid = config.ids.gids.mysql;

    environment.systemPackages = [mysql];

    systemd.services.mysql =
      { description = "MySQL Server";

        wantedBy = [ "multi-user.target" ];

        unitConfig.RequiresMountsFor = "${cfg.dataDir}";

        preStart =
          ''
            if ! test -e ${cfg.dataDir}/mysql; then
                mkdir -m 0700 -p ${cfg.dataDir}
                chown -R ${cfg.user} ${cfg.dataDir}
                ${mysql}/bin/mysql_install_db ${mysqldOptions}
                touch /tmp/mysql_init
            fi

            mkdir -m 0700 -p ${cfg.pidDir}
            chown -R ${cfg.user} ${cfg.pidDir}
          '';

        serviceConfig.ExecStart = "${mysql}/bin/mysqld --defaults-extra-file=${myCnf} ${mysqldOptions}";

        postStart =
          ''
            # Wait until the MySQL server is available for use
            count=0
            while [ ! -e /tmp/mysql.sock ]
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

            if [ -f /tmp/mysql_init ]
            then
                ${concatMapStrings (database:
                  ''
                    # Create initial databases
                    if ! test -e "${cfg.dataDir}/${database.name}"; then
                        echo "Creating initial database: ${database.name}"
                        ( echo "create database ${database.name};"
                          echo "use ${database.name};"

                          if [ -f "${database.schema}" ]
                          then
                              cat ${database.schema}
                          elif [ -d "${database.schema}" ]
                          then
                              cat ${database.schema}/mysql-databases/*.sql
                          fi
                        ) | ${mysql}/bin/mysql -u root -N
                    fi
                  '') cfg.initialDatabases}
                
                ${optionalString (cfg.replication.role == "slave")
                  ''
                    # Set up the replication master
                    
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
          ''; # */

        serviceConfig.ExecStop =
          "${mysql}/bin/mysqladmin ${optionalString (cfg.rootPassword != null) "--user=root --password=\"$(cat ${cfg.rootPassword})\""} shutdown";
      };

  };

}
