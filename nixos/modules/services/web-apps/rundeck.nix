{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.rundeck;
  formatConfig = lib.mapAttrsToList (name: value: "${name}=${toString value}");
in
{
  options = {
    services.rundeck = {
      enable = lib.mkEnableOption "Rundeck service";

      package = lib.mkPackageOption pkgs "rundeck" { };

      adminUser = lib.mkOption {
        type = lib.types.str;
        default = "admin";
        description = "Username for the Rundeck admin user";
        example = "rundeck-admin";
      };

      adminPassword = lib.mkOption {
        type = lib.types.str;
        default = "admin";
        description = "Password for the Rundeck admin user";
        example = "securePassword123";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "rundeck";
        description = "User account under which Rundeck runs";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "rundeck";
        description = "Group account under which Rundeck runs";
      };

      serverAddress = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = "Address on which Rundeck will listen";
      };

      serverHostname = lib.mkOption {
        type = lib.types.str;
        default = "localhost";
        description = "Hostname for the Rundeck server";
      };

      serverPort = lib.mkOption {
        type = lib.types.port;
        default = 4440;
        description = "Port on which Rundeck will listen";
      };

      serverUUID = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "UUID for the Rundeck server (automatically generated if not specified)";
      };

      dataDir = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/rundeck";
        description = "Directory for Rundeck runtime data (RDECK_BASE)";
      };

      configDir = lib.mkOption {
        type = lib.types.path;
        default = "/etc/rundeck";
        description = "Directory for Rundeck configuration files";
      };

      tempDir = lib.mkOption {
        type = lib.types.path;
        default = "/tmp/rundeck";
        description = "Temporary directory for Rundeck";
      };

      sshTimeout = lib.mkOption {
        type = lib.types.int;
        default = 60;
        description = "SSH connection timeout in seconds";
      };

      javaOpts = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "-Xmx1024m"
          "-Xms256m"
          "-XX:MaxMetaspaceSize=256m"
          "-server"
        ];
        description = "Additional Java options for Rundeck";
      };

      extraConfig = lib.mkOption {
        type = lib.types.attrs;
        default = { };
        description = "Additional configuration options for rundeck-config.properties";
        example = lib.literalExpression ''
          {
            "rundeck.gui.title" = "My Rundeck Server";
            "rundeck.feature.repository.enabled" = "true";
            "rundeck.projectsStorageType" = "db";
          }
        '';
      };

      database = {
        type = lib.mkOption {
          type = lib.types.enum [
            "h2"
            "postgresql"
            "mysql"
          ];
          default = "h2";
          description = "Database type to use (h2, postgresql, or mysql)";
        };

        host = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
          description = "Database host";
        };

        port = lib.mkOption {
          type = lib.types.port;
          default = 5432;
          description = "Database port";
        };

        name = lib.mkOption {
          type = lib.types.str;
          default = "rundeck";
          description = "Database name";
        };

        username = lib.mkOption {
          type = lib.types.str;
          default = "rundeck";
          description = "Database username";
        };

        password = lib.mkOption {
          type = lib.types.str;
          default = "rundeck";
          description = "Database password";
        };
      };

      settings = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.oneOf [
            lib.types.bool
            lib.types.int
            lib.types.str
          ]
        );
        default = { };
        description = ''
          Rundeck configuration options.
          See https://docs.rundeck.com/docs/administration/configuration/config-file-reference.html
          for all available options.
        '';
        example = lib.literalExpression ''
          {
            "server.address" = "0.0.0.0";
            "server.port" = "4440";
            "grails.serverURL" = "http://rundeck.example.com:4440";
            "rundeck.projectsStorageType" = "db";
          }
        '';
      };

      ssl = {
        enable = lib.mkEnableOption "SSL support";

        keyStore = lib.mkOption {
          type = lib.types.path;
          example = "/etc/rundeck/ssl/keystore";
          description = "Path to the keystore containing the SSL certificate";
        };

        keyStorePassword = lib.mkOption {
          type = lib.types.str;
          description = "Password for the SSL keystore";
        };

        keyPassword = lib.mkOption {
          type = lib.types.str;
          description = "Password for the SSL key";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.database.type == "h2" -> true;
        message = "When using H2 database, no additional configuration is needed";
      }
      {
        assertion = cfg.database.type != "h2" -> cfg.database.password != "";
        message = "Database password must be set when not using H2 database";
      }
    ];

    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.dataDir;
      createHome = true;
    };

    users.groups.${cfg.group} = { };

    systemd.tmpfiles.settings."10-rundeck" = {
      "${cfg.dataDir}" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.dataDir}/etc" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.dataDir}/data" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.dataDir}/projects" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.dataDir}/libext" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.dataDir}/var" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.dataDir}/var/logs" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.dataDir}/var/tmp" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.dataDir}/.ssh" = {
        d = {
          mode = "0700";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.configDir}" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.configDir}/ssl" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };

      "${cfg.tempDir}" = {
        d = {
          mode = "0750";
          user = cfg.user;
          group = cfg.group;
        };
      };
    };

    systemd.services.rundeck = {
      description = "Rundeck Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      wants = lib.optional (cfg.database.type == "mysql") "mysql.service";

      environment = {
        RDECK_BASE = cfg.dataDir;
        RUNDECK_CONFIG_DIR = cfg.configDir;
        JAVA_OPTS = lib.concatStringsSep " " cfg.javaOpts;
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = toString (
          pkgs.writeShellScript "start-rundeck" ''
            # Generate UUID
            UUID_FILE="${cfg.dataDir}/.uuid"
            if [ -z "${cfg.serverUUID}" ] && [ ! -f "$UUID_FILE" ]; then
              ${pkgs.libuuid}/bin/uuidgen > "$UUID_FILE"
              chmod 640 "$UUID_FILE"
              chown ${cfg.user}:${cfg.group} "$UUID_FILE"
            fi

            # Generate SSH
            if [ ! -f ${cfg.dataDir}/.ssh/id_rsa ]; then
              ${pkgs.openssh}/bin/ssh-keygen -t rsa -b 4096 -N "" -f ${cfg.dataDir}/.ssh/id_rsa
              chmod 600 ${cfg.dataDir}/.ssh/id_rsa
              chmod 644 ${cfg.dataDir}/.ssh/id_rsa.pub
            fi

            ${lib.getExe cfg.package} \
              --skipinstall \
              -b ${cfg.dataDir} \
              -c ${cfg.configDir} \
              -p ${cfg.dataDir}/projects
          ''
        );
        WorkingDirectory = cfg.dataDir;
        RuntimeDirectory = "rundeck";
        RuntimeDirectoryMode = "0750";
        UMask = "0027";

        LimitNOFILE = 65536;
        ReadWritePaths = [
          cfg.dataDir
          cfg.configDir
          cfg.tempDir
        ];
        RestartSec = "10s";
        Restart = "always";
        TimeoutStartSec = "5min";
      };

      preStart = ''
        cat > ${cfg.configDir}/rundeck-config.properties <<EOF
        ${lib.concatStringsSep "\n" (
          formatConfig (
            cfg.settings
            // {
              "server.address" = toString cfg.serverAddress;
              "server.port" = toString cfg.serverPort;
              "grails.serverURL" =
                "http${lib.optionalString cfg.ssl.enable "s"}://${cfg.serverHostname}:${toString cfg.serverPort}";
              "logging.config" = "${cfg.configDir}/log4j2.properties";
              "dataSource.url" =
                if cfg.database.type == "h2" then
                  "jdbc:h2:file:${cfg.dataDir}/data/rundeckdb;DB_CLOSE_ON_EXIT=FALSE;LOCK_TIMEOUT=10000;MODE=MYSQL"
                else if cfg.database.type == "postgresql" then
                  "jdbc:postgresql://${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}"
                else
                  "jdbc:mysql://${cfg.database.host}:${toString cfg.database.port}/${cfg.database.name}?autoReconnect=true&useSSL=false";
              "dataSource.driverClassName" =
                if cfg.database.type == "h2" then
                  "org.h2.Driver"
                else if cfg.database.type == "postgresql" then
                  "org.postgresql.Driver"
                else
                  "org.mariadb.jdbc.Driver";
              "dataSource.username" = cfg.database.username;
              "dataSource.password" = cfg.database.password;
            }
            // cfg.extraConfig
            // lib.optionalAttrs (cfg.database.type == "h2") {
              "dataSource.dialect" = "org.hibernate.dialect.H2Dialect";
            }
            // lib.optionalAttrs (cfg.database.type == "mysql") {
              "dataSource.dialect" = "org.hibernate.dialect.MariaDB103Dialect";
            }
            // lib.optionalAttrs cfg.ssl.enable {
              "server.https.port" = "4443";
              "server.ssl.keyStore" = toString cfg.ssl.keyStore;
              "server.ssl.keyStorePassword" = cfg.ssl.keyStorePassword;
              "server.ssl.keyPassword" = cfg.ssl.keyPassword;
            }
          )
        )}
        EOF

        cat > ${cfg.configDir}/framework.properties <<EOF
        framework.server.name = ${cfg.serverHostname}
        framework.server.hostname = ${cfg.serverHostname}
        framework.server.port = ${toString cfg.serverPort}
        framework.server.url = http${lib.optionalString cfg.ssl.enable "s"}://${cfg.serverHostname}:${toString cfg.serverPort}
        rdeck.base = ${cfg.dataDir}
        framework.projects.dir = ${cfg.dataDir}/projects
        framework.etc.dir = ${cfg.configDir}
        framework.var.dir = ${cfg.dataDir}/var
        framework.tmp.dir = ${cfg.dataDir}/var/tmp
        framework.logs.dir = ${cfg.dataDir}/var/logs
        framework.libext.dir = ${cfg.dataDir}/libext
        framework.ssh.keypath = ${cfg.dataDir}/.ssh/id_rsa
        framework.ssh.user = ${cfg.user}
        framework.ssh.timeout = ${toString cfg.sshTimeout}
        rundeck.server.uuid = ${
          if toString cfg.serverUUID == "" then "$(cat ${cfg.dataDir}/.uuid)" else toString cfg.serverUUID
        }
        EOF

        if [ -f ${cfg.dataDir}/etc/framework.properties ]; then
          cp -a "${cfg.configDir}/framework.properties" "${cfg.dataDir}/etc/framework.properties"
        fi

        cat > ${cfg.configDir}/realm.properties <<EOF
        ${cfg.adminUser}:${cfg.adminPassword},user,admin
        EOF

        cat > ${cfg.configDir}/jaas-loginmodule.conf <<EOF
        RDpropertyfilelogin {
          org.eclipse.jetty.jaas.spi.PropertyFileLoginModule required
          debug="true"
          file="/etc/rundeck/realm.properties";
        };
        EOF

        cat > ${cfg.configDir}/log4j2.properties <<EOF
        status = info
        name = RundeckPro

        appender.console.type = Console
        appender.console.name = STDOUT
        appender.console.layout.type = PatternLayout
        appender.console.layout.pattern = %d{DEFAULT} %-5p %c{1} - %m%n

        appender.file.type = RollingFile
        appender.file.name = FILE
        appender.file.fileName = ${cfg.dataDir}/var/logs/rundeck.log
        appender.file.filePattern = ${cfg.dataDir}/var/logs/rundeck.%d{yyyy-MM-dd}.log
        appender.file.layout.type = PatternLayout
        appender.file.layout.pattern = %d{DEFAULT} [%t] %-5p %c{1} - %m%n
        appender.file.policies.type = Policies
        appender.file.policies.time.type = TimeBasedTriggeringPolicy
        appender.file.policies.time.interval = 1
        appender.file.policies.time.modulate = true

        rootLogger.level = info
        rootLogger.appenderRef.stdout.ref = STDOUT
        rootLogger.appenderRef.file.ref = FILE

        logger.hibernate.name = org.hibernate
        logger.hibernate.level = ERROR
        EOF
      '';
    };

    networking.firewall.allowedTCPPorts = [ cfg.serverPort ];
  };
}
