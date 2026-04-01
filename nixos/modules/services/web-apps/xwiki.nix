{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.xwiki;
  db = cfg.database;
  webappDir = if cfg.rootWebapp then "ROOT" else "xwiki";
  webappPath = if cfg.rootWebapp then "/" else "/xwiki";
  createMariaDB = db.createDatabase && db.type == "mariadb";
  createPostgreSQL = db.createDatabase && db.type == "postgresql";
  xmlEscape =
    value:
    lib.replaceStrings [ "&" "<" ">" "\"" "'" ] [ "&amp;" "&lt;" "&gt;" "&quot;" "&apos;" ] value;
  dbPassword = if db.passwordFile != null then "__XWIKI_DB_PASSWORD__" else db.password;
  jdbcUrl =
    if db.type == "hsqldb" then
      "jdbc:hsqldb:file:${cfg.stateDir}/database/${db.name}_db;shutdown=true"
    else if db.type == "mariadb" then
      if db.socket != null then
        "jdbc:mariadb://localhost/${db.name}?localSocket=${toString db.socket}"
      else
        "jdbc:mariadb://${db.host}:${toString db.port}/${db.name}"
    else if db.socket != null then
      "jdbc:postgresql://localhost/${db.name}?socketFactory=org.newsclub.net.unix.AFUNIXSocketFactory$FactoryArg&socketFactoryArg=${db.socket}/.s.PGSQL.${toString db.port}&sslmode=disable"
    else
      "jdbc:postgresql://${db.host}:${toString db.port}/${db.name}";
  driverClass =
    if db.type == "hsqldb" then
      "org.hsqldb.jdbcDriver"
    else if db.type == "mariadb" then
      "org.mariadb.jdbc.Driver"
    else
      "org.postgresql.Driver";
  tomcatContextXml = pkgs.writeText "${webappDir}.xml" ''
    <Context>
      <Resources cacheMaxSize="262144" cacheObjectMaxSize="1024" />
    </Context>
  '';

  plainWebapps = pkgs.runCommand "xwiki-webapps-${cfg.package.version}" { } ''
    mkdir -p "$out"/webapps "$out"/conf/Catalina/localhost
    ln -s ${cfg.package}/webapps/xwiki-${cfg.package.version}.war "$out"/webapps/${webappDir}.war
    ln -s ${tomcatContextXml} "$out"/conf/Catalina/localhost/${webappDir}.xml
  '';

  hibernateCfg = pkgs.writeText "xwiki-hibernate.cfg.xml" ''
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE hibernate-configuration PUBLIC
      "-//Hibernate/Hibernate Configuration DTD//EN"
      "http://www.hibernate.org/dtd/hibernate-configuration-3.0.dtd">
    <hibernate-configuration>
      <session-factory>
        <property name="show_sql">false</property>
        <property name="use_outer_join">true</property>
        <property name="jdbc.use_scrollable_resultset">false</property>
        <property name="dbcp.defaultAutoCommit">false</property>
        <property name="dbcp.maxTotal">50</property>
        <property name="dbcp.maxIdle">5</property>
        <property name="dbcp.maxWaitMillis">30000</property>
        <property name="connection.provider_class">com.xpn.xwiki.store.DBCPConnectionProvider</property>

        <property name="connection.url">${xmlEscape jdbcUrl}</property>
        <property name="connection.username">${db.user}</property>
        <property name="connection.password">${xmlEscape dbPassword}</property>
        <property name="connection.driver_class">${driverClass}</property>
        ${lib.optionalString (db.type != "hsqldb") ''
          <property name="dbcp.poolPreparedStatements">true</property>
          <property name="dbcp.maxOpenPreparedStatements">20</property>
        ''}
        <property name="hibernate.connection.charSet">UTF-8</property>
        <property name="hibernate.connection.useUnicode">true</property>
        <property name="hibernate.connection.characterEncoding">utf8</property>
        ${lib.optionalString (db.type == "postgresql") ''
          <property name="jdbc.use_streams_for_binary">false</property>
          <property name="xwiki.virtual_mode">schema</property>
        ''}

        <mapping resource="${
          if db.type == "postgresql" then "xwiki.postgresql.hbm.xml" else "xwiki.hbm.xml"
        }"/>
        <mapping resource="feeds.hbm.xml"/>
        <mapping resource="instance.hbm.xml"/>
        <mapping resource="notification-filter-preferences.hbm.xml"/>
        <mapping resource="mailsender.hbm.xml"/>
      </session-factory>
    </hibernate-configuration>
  '';

  databaseConfiguredWebapps =
    pkgs.runCommand "xwiki-database-webapps-${cfg.package.version}"
      { nativeBuildInputs = [ pkgs.unzip ]; }
      ''
        mkdir -p "$out"/webapps/${webappDir} "$out"/conf/Catalina/localhost
        cd "$out"/webapps/${webappDir}
        unzip -q ${cfg.package}/webapps/xwiki-${cfg.package.version}.war
        cp ${hibernateCfg} WEB-INF/hibernate.cfg.xml
        sed -i -E 's|^#? *environment\.permanentDirectory *=.*|environment.permanentDirectory=${cfg.stateDir}|' WEB-INF/xwiki.properties
        ${lib.optionalString (db.type != "hsqldb") ''
          sed -i -E 's|^#? *xwiki\.db *=.*|xwiki.db=${db.name}|' WEB-INF/xwiki.cfg
        ''}
        sed -i -E 's|^#? *xwiki\.webapppath *=.*|xwiki.webapppath=${webappPath}|' WEB-INF/xwiki.cfg
        ln -s ${tomcatContextXml} "$out"/conf/Catalina/localhost/${webappDir}.xml
      '';
in
{
  options.services.xwiki = {
    enable = lib.mkEnableOption "XWiki Webapp (Tomcat)";

    package = lib.mkPackageOption pkgs "xwiki" { };

    enableWebserver = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Enable the XWiki web application in a Tomcat webserver.
      '';
    };

    rootWebapp = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Install XWiki as Tomcat root web application (`/`) instead of `/xwiki`.
      '';
    };

    stateDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/xwiki";
      description = ''
        Directory used for persistent XWiki data.
        This directory is passed as `-Dxwiki.data.dir` to Tomcat.
      '';
    };

    bootstrapXip = {
      enable = lib.mkEnableOption "offline XIP bootstrap package for the XWiki Distribution Wizard";

      package = lib.mkPackageOption pkgs "xwiki-flavor-xip" { };
    };

    database = {
      type = lib.mkOption {
        type = lib.types.enum [
          "hsqldb"
          "mariadb"
          "postgresql"
        ];
        default = "hsqldb";
        description = "Database engine to use.";
      };

      createDatabase = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to provision and configure a local database instance for XWiki.
        '';
      };

      host = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Database host address.";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 9001;
        defaultText = lib.literalExpression ''
          if config.services.xwiki.database.type == "hsqldb"
          then 9001
          else if config.services.xwiki.database.type == "postgresql"
          then 5432
          else 3306
        '';
        description = "Database host port.";
      };

      socket = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        defaultText = lib.literalExpression ''
          if config.services.xwiki.database.createDatabase && config.services.xwiki.database.type == "mariadb" then
            "/run/mysqld/mysqld.sock"
          else if config.services.xwiki.database.createDatabase && config.services.xwiki.database.type == "postgresql" then
            "/run/postgresql"
          else
            null
        '';
        description = "Path to the unix socket file to use for database connection.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "xwiki";
        description = "Database name.";
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "xwiki";
        description = ''
          Database user used by XWiki.
          With `createDatabase = true`, this should be `"xwiki"`.
        '';
      };

      password = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = ''
          The password corresponding to `database.user`.
          Warning: this is stored in cleartext in the Nix store!
          Use `database.passwordFile` instead.
        '';
      };

      passwordFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        example = "/run/keys/xwiki-dbpassword";
        description = ''
          A file containing the password corresponding to `database.user`.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    services.xwiki.database.port = lib.mkDefault (
      if db.type == "hsqldb" then
        9001
      else if db.type == "postgresql" then
        5432
      else
        3306
    );
    services.xwiki.database.socket = lib.mkDefault (
      if db.createDatabase && db.type == "mariadb" then
        "/run/mysqld/mysqld.sock"
      else if db.createDatabase && db.type == "postgresql" then
        "/run/postgresql"
      else
        null
    );

    assertions = [
      {
        assertion = !db.createDatabase || cfg.enableWebserver;
        message = "services.xwiki.database.createDatabase requires services.xwiki.enableWebserver to be true.";
      }
      {
        assertion = !db.createDatabase || db.type != "hsqldb";
        message = "services.xwiki.database.createDatabase is not supported for the embedded HSQLDB backend.";
      }
      {
        assertion = !db.createDatabase || db.user == "xwiki";
        message = "services.xwiki.database.user must be \"xwiki\" when services.xwiki.database.createDatabase is set.";
      }
      {
        assertion = db.password == "" || db.passwordFile == null;
        message = "services.xwiki.database.password and services.xwiki.database.passwordFile are mutually exclusive.";
      }
      {
        assertion = !createPostgreSQL || db.passwordFile != null || db.password != "";
        message = "services.xwiki.database.passwordFile or services.xwiki.database.password must be set when using local PostgreSQL provisioning.";
      }
    ];

    services.tomcat = lib.mkIf cfg.enableWebserver (
      lib.mkMerge [
        {
          enable = true;
          package = lib.mkDefault pkgs.tomcat10;
          purifyOnStart = lib.mkDefault true;
          webapps = lib.mkDefault (
            (if cfg.rootWebapp then [ ] else [ config.services.tomcat.package.webapps ])
            ++ [
              (if db.createDatabase then databaseConfiguredWebapps else plainWebapps)
            ]
          );
          javaOpts = lib.mkDefault [ "-Dxwiki.data.dir=${cfg.stateDir}" ];
        }
        {
          commonLibs = lib.mkAfter (
            if db.type == "mariadb" then
              [
                "${pkgs.mariadb-connector-java}/share/java/mariadb-java-client.jar"
                "${pkgs.jna}/share/java/jna.jar"
                "${pkgs.jna}/share/java/jna-platform.jar"
              ]
            else if db.type == "postgresql" then
              [ "${pkgs.postgresql_jdbc}/share/java/postgresql-jdbc.jar" ]
            else if db.type == "hsqldb" then
              [ "${pkgs.hsqldb}/lib/hsqldb.jar" ]
            else
              [ ]
          );
        }
      ]
    );

    systemd.tmpfiles.settings = lib.mkIf cfg.enableWebserver {
      "10-xwiki" = {
        "${cfg.stateDir}".d = {
          mode = "0750";
          user = config.services.tomcat.user;
          group = config.services.tomcat.group;
        };
      };
    };

    systemd.services.xwiki-install-bootstrap-xip =
      lib.mkIf (cfg.enableWebserver && cfg.bootstrapXip.enable)
        {
          description = "Install XWiki bootstrap XIP package";
          wantedBy = [ "multi-user.target" ];
          before = [ "tomcat.service" ];
          serviceConfig = {
            Type = "oneshot";
            User = config.services.tomcat.user;
            Group = config.services.tomcat.group;
          };
          script = ''
            set -euo pipefail
            repository_dir="${cfg.stateDir}/extension/repository"
            xip_file="$(find ${cfg.bootstrapXip.package} -maxdepth 1 -type f -name '*.xip' | head -n 1)"

            mkdir -p "$repository_dir"
            ${pkgs.unzip}/bin/unzip -oq "$xip_file" -d "$repository_dir"
          '';
        };

    services.mysql = lib.mkIf createMariaDB {
      enable = true;
      package = lib.mkDefault pkgs.mariadb;
      settings.mysqld = {
        "skip-networking" = lib.mkDefault true;
      };
      ensureDatabases = [ db.name ];
    };

    systemd.services.xwiki-mariadb-init = lib.mkIf createMariaDB {
      description = "Initialize local MariaDB credentials for XWiki";
      after = [ "mysql.service" ];
      before = [ "tomcat.service" ];
      requires = [ "mysql.service" ];
      wantedBy = [ "multi-user.target" ];
      path = [ config.services.mysql.package ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
      }
      // lib.optionalAttrs (db.passwordFile != null) {
        LoadCredential = [ "db_password:${db.passwordFile}" ];
      };
      script = ''
        set -euo pipefail
        db_password=${
          if db.passwordFile != null then
            ''$(<"$CREDENTIALS_DIRECTORY/db_password")''
          else
            lib.escapeShellArg db.password
        }
        db_password="''${db_password//\'/\'\'}"

        mysql -N -e "CREATE DATABASE IF NOT EXISTS \`${db.name}\`"
        mysql -N -e "CREATE USER IF NOT EXISTS '${db.user}'@'localhost' IDENTIFIED BY '$db_password'"
        mysql -N -e "ALTER USER '${db.user}'@'localhost' IDENTIFIED BY '$db_password'"
        mysql -N -e "GRANT ALL PRIVILEGES ON \`${db.name}\`.* TO '${db.user}'@'localhost'"
      '';
    };

    services.postgresql = lib.mkIf createPostgreSQL {
      enable = true;
      ensureDatabases = [ db.name ];
      ensureUsers = [
        {
          name = db.user;
          ensureDBOwnership = true;
        }
      ];
    };

    systemd.services.xwiki-postgresql-init = lib.mkIf createPostgreSQL {
      description = "Initialize local PostgreSQL credentials for XWiki";
      after = [ "postgresql.target" ];
      before = [ "tomcat.service" ];
      bindsTo = [ "postgresql.target" ];
      wantedBy = [ "multi-user.target" ];
      path = [ config.services.postgresql.package ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        User = "postgres";
        Group = "postgres";
      }
      // lib.optionalAttrs (db.passwordFile != null) {
        LoadCredential = [ "db_password:${db.passwordFile}" ];
      };
      script = ''
        set -euo pipefail
        db_password=${
          if db.passwordFile != null then
            ''$(<"$CREDENTIALS_DIRECTORY/db_password")''
          else
            lib.escapeShellArg db.password
        }
        db_password="''${db_password//\'/\'\'}"

        create_role="$(mktemp)"
        trap 'rm -f "$create_role"' EXIT
        echo "CREATE ROLE ${db.user} WITH LOGIN PASSWORD '$db_password' CREATEDB" > "$create_role"
        psql -tAc "SELECT 1 FROM pg_roles WHERE rolname='${db.user}'" | grep -q 1 || psql -tA --file="$create_role"
        psql -tAc "ALTER ROLE ${db.user} WITH PASSWORD '$db_password'"
        psql -tAc "SELECT 1 FROM pg_database WHERE datname='${db.name}'" | grep -q 1 || psql -tAc 'CREATE DATABASE "${db.name}" OWNER "${db.user}"'
      '';
    };

    systemd.services.xwiki-mariadb-indexes = lib.mkIf createMariaDB {
      description = "Ensure recommended XWiki MariaDB indexes";
      after = [
        "mysql.service"
        "tomcat.service"
      ];
      requires = [
        "mysql.service"
        "tomcat.service"
      ];
      wantedBy = [ "multi-user.target" ];

      path = [ config.services.mysql.package ];
      script = ''
        set -euo pipefail
        db=${lib.escapeShellArg db.name}

        q() {
          mysql --batch --skip-column-names -e "$1"
        }

        table_exists() {
          [ "$(q "SELECT COUNT(*) FROM information_schema.tables WHERE table_schema='$db' AND table_name='$1'")" -gt 0 ]
        }

        index_exists() {
          [ "$(q "SELECT COUNT(*) FROM information_schema.statistics WHERE table_schema='$db' AND table_name='$1' AND index_name='$2'")" -gt 0 ]
        }

        # XWiki creates tables lazily during first startup. If they are not present yet, retry next boot.
        table_exists xwikidoc || exit 0

        if ! index_exists xwikilargestrings xwl_value; then
          q "CREATE INDEX xwl_value ON $db.xwikilargestrings (xwl_value(50))"
        fi
        if ! index_exists xwikidoc xwd_parent; then
          q "CREATE INDEX xwd_parent ON $db.xwikidoc (xwd_parent(50))"
        fi
        if ! index_exists xwikidoc xwd_class_xml; then
          q "CREATE INDEX xwd_class_xml ON $db.xwikidoc (xwd_class_xml(20))"
        fi
        if table_exists xwikiattrecyclebin && ! index_exists xwikiattrecyclebin xda_docid1; then
          q "CREATE INDEX xda_docid1 ON $db.xwikiattrecyclebin (xda_docid)"
        fi
        if ! index_exists xwikidoc solr_iterate_all_documents; then
          q "CREATE INDEX solr_iterate_all_documents ON $db.xwikidoc (XWD_WEB(500), XWD_NAME(253), XWD_LANGUAGE(5), XWD_VERSION(10))"
        fi
      '';
      serviceConfig = {
        Type = "oneshot";
      };
    };

    systemd.services.tomcat = lib.mkMerge [
      (lib.mkIf (cfg.enableWebserver && createMariaDB) {
        after = [
          "mysql.service"
          "xwiki-mariadb-init.service"
        ];
        requires = [
          "mysql.service"
          "xwiki-mariadb-init.service"
        ];
      })
      (lib.mkIf (cfg.enableWebserver && createPostgreSQL) {
        after = [ "postgresql.target" ];
        requires = [ "postgresql.target" ];
      })
      (lib.mkIf (cfg.enableWebserver && createMariaDB && db.passwordFile != null) {
        preStart = lib.mkAfter ''
          if [ -f ${db.passwordFile} ] && [ -f ${config.services.tomcat.baseDir}/webapps/${webappDir}/WEB-INF/hibernate.cfg.xml ]; then
            dbpass="$(${pkgs.coreutils}/bin/cat ${db.passwordFile})"
            dbpass="$(${pkgs.gnused}/bin/sed \
              -e 's/&/\&amp;/g' \
              -e 's/</\&lt;/g' \
              -e 's/>/\&gt;/g' \
              -e 's/"/\&quot;/g' \
              -e "s/'/\&apos;/g" <<< "$dbpass")"
            ${pkgs.gnused}/bin/sed -i "s|__XWIKI_DB_PASSWORD__|$dbpass|g" ${config.services.tomcat.baseDir}/webapps/${webappDir}/WEB-INF/hibernate.cfg.xml
          fi
        '';
      })
      (lib.mkIf (cfg.enableWebserver && createPostgreSQL && db.passwordFile != null) {
        preStart = lib.mkAfter ''
          if [ -f ${db.passwordFile} ] && [ -f ${config.services.tomcat.baseDir}/webapps/${webappDir}/WEB-INF/hibernate.cfg.xml ]; then
            dbpass="$(${pkgs.coreutils}/bin/cat ${db.passwordFile})"
            dbpass="$(${pkgs.gnused}/bin/sed \
              -e 's/&/\&amp;/g' \
              -e 's/</\&lt;/g' \
              -e 's/>/\&gt;/g' \
              -e 's/"/\&quot;/g' \
              -e "s/'/\&apos;/g" <<< "$dbpass")"
            ${pkgs.gnused}/bin/sed -i "s|__XWIKI_DB_PASSWORD__|$dbpass|g" ${config.services.tomcat.baseDir}/webapps/${webappDir}/WEB-INF/hibernate.cfg.xml
          fi
        '';
      })
      (lib.mkIf (cfg.enableWebserver && cfg.bootstrapXip.enable) {
        after = [ "xwiki-install-bootstrap-xip.service" ];
        requires = [ "xwiki-install-bootstrap-xip.service" ];
      })
    ];

    warnings =
      lib.optional (db.password != "")
        "services.xwiki.database.password will be stored as plaintext in the Nix store. Use database.passwordFile instead.";
  };
}
