{ config, lib, pkgs, ... }:

with lib;

let

  root_config = config;

  cfg = config.services.mysql;

  enabled =
    # services.mysql:
    (lib.optional cfg.enable { name = "mysql"; m_config = cfg; })
    # services.mysql.instances
    ++ (mapAttrsToList (name: m_config: { inherit name m_config; }) (filterAttrs (n: m: m.enable) cfg.instances));

  configs = map (m_config) enabled;

  m_config = {name, m_config}:
    let

      mysql = m_config.package;

      is55 = m_config.package.mysqlVersion == "5.6";

      mysqldDir = if mysql ? mysqld_path then "${mysql}/${mysql.mysqld_path}" else "${mysql}/bin";

      pidFile = "${m_config.pidDir}/mysqld.pid";

      mysql_initOptions =
        "--user=${m_config.user} --datadir=${m_config.dataDir} --basedir=${mysql} ";

      mysqldOptions =
        mysql_initOptions
        + "--pid-file=${pidFile} --socket=${m_config.socketFile}";

      myCnf = pkgs.writeText "my.cnf"
      ''
        [mysqld]
        port = ${toString m_config.port}
        ${optionalString (m_config.replication.role == "master" || m_config.replication.role == "slave") "log-bin=${name}-bin"}
        ${optionalString (m_config.replication.role == "master" || m_config.replication.role == "slave") "server-id = ${toString m_config.replication.serverId}"}
        ${optionalString (m_config.replication.role == "slave" && !is55)
        ''
          master-host = ${m_config.replication.masterHost}
          master-user = ${m_config.replication.masterUser}
          master-password = ${m_config.replication.masterPassword}
          master-port = ${toString m_config.replication.masterPort}
        ''}
        ${m_config.extraOptions}
      '';

      tmp_init_file = "/tmp/${name}_init";

    in {

      users_extraUsers.${m_config.user} = {
        description = "MySQL server user";
        group = m_config.group;
        uid = m_config.uid;
      };

      users_extraGroups.${m_config.group}.gid = m_config.gid;

      systemd_services."mysql-${name}" =

        { description = "MySQL Server ${name}";

          wantedBy = [ "multi-user.target" ];

          unitConfig.RequiresMountsFor = "${m_config.dataDir}";

          preStart =
            ''
              if ! test -e ${m_config.dataDir}/${name}; then
                  mkdir -m 0700 -p ${m_config.dataDir}
                  chown -R ${m_config.user} ${m_config.dataDir}
                  ${ mysql.mysql_initialize_datadir_cmd (m_config // { inherit mysql; }) }
                  touch /tmp/mysql_init
              fi
              socketDir=$(dirname "${m_config.socketFile}")
              mkdir -m 0755 -p  $socketDir
              mkdir -m 0700 -p ${m_config.pidDir}
              chown -R ${m_config.user} ${m_config.pidDir} $socketDir
            '';

          serviceConfig.Restart = "always";

          serviceConfig.ExecStart = "${mysqldDir}/mysqld --defaults-extra-file=${myCnf} ${mysqldOptions}";

          postStart =
            ''
              # Wait until the MySQL server is available for use
              count=0
              while [ ! -e ${m_config.socketFile} ]
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

              if [ -f ${tmp_init_file} ]
              then
                  ${concatMapStrings (database:
                    ''
                      # Create initial databases
                      if ! test -e "${m_config.dataDir}/${database.name}"; then
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
                          ) | ${mysql}/bin/mysql -u root -N -S ${m_config.socketFile}
                      fi
                    '') m_config.initialDatabases}

                  ${optionalString (m_config.replication.role == "slave" && is55)
                    ''
                      # Set up the replication master

                      ( echo "stop slave;"
                        echo "change master to master_host='${m_config.replication.masterHost}', master_user='${m_config.replication.masterUser}', master_password='${m_config.replication.masterPassword}';"
                        echo "start slave;"
                      ) | ${mysql}/bin/mysql -u root -N -S ${m_config.socketFile}
                    ''}

                  ${optionalString (m_config.initialScript != null)
                    ''
                      # Execute initial script
                      cat ${m_config.initialScript} | ${mysql}/bin/mysql -u root -N -S ${m_config.socketFile}
                    ''}

                  ${optionalString (m_config.rootPassword != null)
                    ''
                      # Change root password

                      ( echo "use mysql;"
                        echo "update user set Password=password('$(cat ${m_config.rootPassword})') where User='root';"
                        echo "flush privileges;"
                      ) | ${mysql}/bin/mysql -u root -N -S ${m_config.socketFile} || true
                    ''}

                rm ${tmp_init_file}
              fi
            ''; # */
        };

      };

  mysqlOpts = { name, /*config,*/ ... }: {
    options = {

      enable = mkOption {
        default = false;
        description = "
          Whether to enable the MySQL server.
        ";
      };

      package = mkOption {
        type = types.package;
        example = literalExample "pkgs.mysql";
        description = "
          Which MySQL derivation to use.
        ";
      };

      port = mkOption {
        default = "3306";
        description = "Port of MySQL";
      };

      user = mkOption {
        default = name;
        description = "User account under which MySQL runs";
      };

      uid = mkOption {
        description = "uid for this mysql instance";
        default =
          if (!hasAttr name root_config.ids.uids) then
            config.ids.uids.mysql
          else root_config.ids.uids.${name};
      };

      group = mkOption {
        description = "group";
        default = name;
      };

      gid = mkOption {
        description = "gid";
        default =
          if (!hasAttr name root_config.ids.gids) then
            config.ids.gids.mysql
          else root_config.ids.gids.${name};
      };

      dataDir = mkOption {
        default = "/var/db/mysqls/${name}";
        description = "Location where MySQL stores its table files";
      };

      pidDir = mkOption {
        default = "/var/run/mysqls/${name}";
        description = "Location of the file which stores the PID of the MySQL server";
      };

      socketFile = mkOption {
        description = "socket file location for this mysql instance";
        default = "/tmp/${name}.sock";
      };

      extraOptions = mkOption {
        default = "";
        example = ''
          key_buffer_size = 6G
          table_cache = 1600
          log-error = /var/log/mysqls/${name}_err.log
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

  prepareResources = mysql_attr_name:
      map ({name, m_config}: {
          "${builtins.toString m_config.${mysql_attr_name}}".required_by = "mysql instance ${name}"; 
      }) enabled;

in

{

  ###### interface

  options = {

    services.mysql =
      # be backward compatible, provide services.mysql
      (mysqlOpts { name = "mysql"; }).options

      // {
        systemPackage = mkOption {
          default =
            if enabled == [] then null
            else (builtins.head enabled).m_config.package;
          type = types.nullOr types.package;
          description = ''
            The mysql package to be added to <option>environment.systemPackages</option>
          '';
        };

        instances = mkOption {
          default = {};
          type = types.attrsOf types.optionSet;
          example = {
            mysql.enable = true;
          };
          description = ''
            If you want more than one mysql instance set <option>services.mysql.instances.name.enable = true</option>
          '';
          options = [ mysqlOpts ];
        };
      };
  };


  ###### implementation

  config = {
    systemd.services = mkMerge (catAttrs "systemd_services" configs);
    environment.systemPackages = lib.optional (cfg.systemPackage != null) cfg.systemPackage;
    users.extraGroups = mkMerge (catAttrs "users_extraGroups" configs);
    users.extraUsers = mkMerge (catAttrs "users_extraUsers" configs);

    resources."tcp-ports" = mkMerge (prepareResources "port");
    resources.paths = mkMerge (
      (prepareResources "socketFile")
      ++ (prepareResources "dataDir")
      ++ (prepareResources "pidDir")
    );
  };

}
