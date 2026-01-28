{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.rundeck;
  formatConfig = lib.mapAttrsToList (name: value: "${name}=${toString value}");

  rundeckStartScript = pkgs.writeShellScript "start-rundeck" ''
    ${lib.optionalString (cfg.serverUUID == "") ''
      # Generate UUID
      UUID_FILE="${cfg.dataDir}/.uuid"
      if [ ! -f "$UUID_FILE" ]; then
        umask 0137
        touch "$UUID_FILE"
        chown ${cfg.user}:${cfg.group} "$UUID_FILE"
        ${lib.getExe' pkgs.util-linux "uuidgen"} > "$UUID_FILE"
      fi
    ''}

    # Generate SSH
    if [ ! -f ${cfg.dataDir}/.ssh/id_${cfg.sshKeyType} ]; then
      umask 0077
      ${lib.getExe' pkgs.openssh "ssh-keygen"} -t ${cfg.sshKeyType} ${
        lib.optionalString (cfg.sshKeyType == "rsa") "-b 4096"
      } -N "" -f ${cfg.dataDir}/.ssh/id_${cfg.sshKeyType}
      chmod 644 ${cfg.dataDir}/.ssh/id_${cfg.sshKeyType}.pub
      chown ${cfg.user}:${cfg.group} ${cfg.dataDir}/.ssh/id_${cfg.sshKeyType} ${cfg.dataDir}/.ssh/id_${cfg.sshKeyType}.pub
    fi

    ${lib.getExe cfg.package} \
      --skipinstall \
      -b ${cfg.dataDir} \
      -c ${cfg.configDir} \
      -p ${cfg.dataDir}/projects
  '';
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

      adminPasswordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = "Path to a file containing the admin password (more secure than adminPassword)";
        example = "/run/secrets/rundeck-admin-password";
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

      serverURL = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Complete Grails server URL (if set, overrides automatic URL generation)";
        example = "https://myhost:4443/rundeck";
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

      aclPolicies = lib.mkOption {
        type = lib.types.attrsOf lib.types.str;
        default = { };
        description = "ACL policies for Rundeck, where the attribute name is the filename and the value is the policy content";
        example = lib.literalExpression ''
          {
            "admin.aclpolicy" = '''
              description: Admin access for administrators
              context:
                project: '.*'
              for:
                resource:
                  - allow: '*'
                job:
                  - allow: '*'
                node:
                  - allow: '*'
              by:
                group: admin
              ---
              description: Admin access in application scope
              context:
                application: 'rundeck'
              for:
                resource:
                  - allow: '*'
                project:
                  - allow: '*'
              by:
                group: admin
            ''';
          }
        '';
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

      sshKeyType = lib.mkOption {
        type = lib.types.enum [
          "rsa"
          "ed25519"
        ];
        default = "rsa";
        description = "Type of SSH key to generate (rsa for compatibility, ed25519 for better security)";
      };

      openFirewall = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to open the Rundeck port in the firewall";
      };

      startTimeout = lib.mkOption {
        type = lib.types.int;
        default = 180;
        description = "Timeout in seconds before systemd considers the service startup as failed";
        example = 120;
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
          default = 0;
          description = "Database port (defaults: PostgreSQL: 5432, MySQL: 3306)";
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
          description = "Database password (not recommended, use passwordFile instead)";
        };

        passwordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to a file containing the database password";
          example = "/run/secrets/rundeck-db-password";
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

          Note: Top-level options like serverAddress, serverPort, etc. will override
          any corresponding keys defined here.
        '';
        example = lib.literalExpression ''
          {
            # These are different from the top-level options:
            "rundeck.feature.repository.enabled" = "true";
            "rundeck.projectsStorageType" = "db";
            "rundeck.gui.title" = "My Rundeck Instance";
            "rdeck.security.useHMacRequestTokens" = "true";
            "rundeck.web.jetty.servlet.MaxFormKeys" = "2000";
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
          description = "Password for the SSL keystore (not recommended for production, use keyStorePasswordFile instead)";
        };

        keyStorePasswordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to a file containing the SSL keystore password";
          example = "/run/secrets/rundeck-keystore-password";
        };

        keyPassword = lib.mkOption {
          type = lib.types.str;
          description = "Password for the SSL key (not recommended for production, use keyPasswordFile instead)";
        };

        keyPasswordFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "Path to a file containing the SSL key password";
          example = "/run/secrets/rundeck-key-password";
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {

    services.rundeck.database.port = lib.mkDefault (
      if cfg.database.type == "postgresql" then
        5432
      else if cfg.database.type == "mysql" then
        3306
      else
        null
    );

    assertions = [
      {
        assertion =
          cfg.database.type == "h2"
          || (
            cfg.database.host != ""
            && cfg.database.username != ""
            && (cfg.database.password != "" || cfg.database.passwordFile != null)
          );
        message = "When using external database (PostgreSQL/MySQL), host, username, and password/passwordFile must be provided";
      }
      {
        assertion = cfg.database.type == "h2" || cfg.database.port > 0;
        message = "Database port must be set when using an external database";
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

      "/var/log/rundeck" = {
        L = {
          argument = "${cfg.dataDir}/var/logs";
        };
      };
    };

    environment.etc."rundeck/jaas-loginmodule.conf" = {
      mode = "0640";
      user = cfg.user;
      group = cfg.group;
      text = ''
        RDpropertyfilelogin {
          org.eclipse.jetty.jaas.spi.PropertyFileLoginModule required
          debug="true"
          file="/etc/rundeck/realm.properties";
        };
      '';
    };

    environment.etc."rundeck/log4j2.properties" = {
      mode = "0640";
      user = cfg.user;
      group = cfg.group;
      text = ''
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
      '';
    };

    systemd.services.rundeck = {
      description = "Rundeck Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      wants =
        lib.optional (cfg.database.type == "mysql") "mysql.service"
        ++ lib.optional (cfg.database.type == "postgresql") "postgresql.service";

      environment = {
        RDECK_BASE = cfg.dataDir;
        RUNDECK_CONFIG_DIR = cfg.configDir;
        JAVA_OPTS = lib.concatStringsSep " " cfg.javaOpts;
      };

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        ExecStart = rundeckStartScript;
        WorkingDirectory = cfg.dataDir;
        RuntimeDirectory = "rundeck";
        RuntimeDirectoryMode = "0750";
        UMask = "0027";

        LimitNOFILE = 65536;
        ReadWritePaths = [
          cfg.dataDir
          cfg.configDir
        ];
        RestartSec = "10s";
        Restart = "always";
        TimeoutStartSec = "${toString cfg.startTimeout}s";
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
                if cfg.serverURL != "" then
                  cfg.serverURL
                else
                  "http${lib.optionalString cfg.ssl.enable "s"}://${cfg.serverHostname}";
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
              "dataSource.password" =
                if cfg.database.passwordFile != null then
                  "$(cat ${cfg.database.passwordFile})"
                else
                  cfg.database.password;
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
              "server.ssl.keyStorePassword" =
                if cfg.ssl.keyStorePasswordFile != null then
                  "$(cat ${cfg.ssl.keyStorePasswordFile})"
                else
                  cfg.ssl.keyStorePassword;
              "server.ssl.keyPassword" =
                if cfg.ssl.keyPasswordFile != null then
                  "$(cat ${cfg.ssl.keyPasswordFile})"
                else
                  cfg.ssl.keyPassword;
            }
          )
        )}
        EOF

        cat > ${cfg.configDir}/framework.properties <<EOF
        framework.server.name = ${cfg.serverHostname}
        framework.server.hostname = ${cfg.serverHostname}
        framework.server.port = ${toString cfg.serverPort}
        framework.server.url = ${
          if cfg.serverURL != "" then
            cfg.serverURL
          else
            "http${lib.optionalString cfg.ssl.enable "s"}://${cfg.serverHostname}"
        }
        rdeck.base = ${cfg.dataDir}
        framework.projects.dir = ${cfg.dataDir}/projects
        framework.etc.dir = ${cfg.configDir}
        framework.var.dir = ${cfg.dataDir}/var
        framework.tmp.dir = ${cfg.dataDir}/var/tmp
        framework.logs.dir = ${cfg.dataDir}/var/logs
        framework.libext.dir = ${cfg.dataDir}/libext
        framework.ssh.keypath = ${cfg.dataDir}/.ssh/id_${cfg.sshKeyType}
        framework.ssh.user = ${cfg.user}
        framework.ssh.timeout = ${toString cfg.sshTimeout}
        rundeck.server.uuid = ${
          if toString cfg.serverUUID == "" then "$(cat ${cfg.dataDir}/.uuid)" else toString cfg.serverUUID
        }
        EOF

        if [ -f ${cfg.dataDir}/etc/framework.properties ]; then
          cp -a "${cfg.configDir}/framework.properties" "${cfg.dataDir}/etc/framework.properties"
        fi

        ${lib.optionalString (cfg.adminPasswordFile != null) ''
          cat > ${cfg.configDir}/realm.properties <<EOF
          ${cfg.adminUser}:$(cat ${cfg.adminPasswordFile}),user,admin
          EOF
        ''}

        ${lib.optionalString (cfg.adminPasswordFile == null) ''
          cat > ${cfg.configDir}/realm.properties <<EOF
          ${cfg.adminUser}:${cfg.adminPassword},user,admin
          EOF
        ''}

        ${lib.concatStringsSep "\n" (
          lib.mapAttrsToList (name: content: ''
            cat > ${cfg.dataDir}/etc/${name} <<EOF
            ${content}
            EOF
          '') cfg.aclPolicies
        )}
      '';
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.serverPort ];
  };
}
