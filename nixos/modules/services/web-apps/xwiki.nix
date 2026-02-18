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

  tomcatContextXml = pkgs.writeText "${webappDir}.xml" ''
    <Context>
      <Resources cacheMaxSize="262144" cacheObjectMaxSize="1024" />
    </Context>
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

        <property name="connection.url">jdbc:hsqldb:file:${cfg.stateDir}/database/${db.name}_db;shutdown=true</property>
        <property name="connection.username">sa</property>
        <property name="connection.password"></property>
        <property name="connection.driver_class">org.hsqldb.jdbcDriver</property>

        <property name="hibernate.connection.charSet">UTF-8</property>
        <property name="hibernate.connection.useUnicode">true</property>
        <property name="hibernate.connection.characterEncoding">utf8</property>

        <mapping resource="xwiki.hbm.xml"/>
        <mapping resource="feeds.hbm.xml"/>
        <mapping resource="instance.hbm.xml"/>
        <mapping resource="notification-filter-preferences.hbm.xml"/>
        <mapping resource="mailsender.hbm.xml"/>
      </session-factory>
    </hibernate-configuration>
  '';

  configuredWebapps =
    pkgs.runCommand "xwiki-webapps-${cfg.package.version}" { nativeBuildInputs = [ pkgs.unzip ]; }
      ''
        mkdir -p "$out"/webapps/${webappDir} "$out"/conf/Catalina/localhost
        cd "$out"/webapps/${webappDir}
        unzip -q ${cfg.package}/webapps/xwiki-${cfg.package.version}.war
        cp ${hibernateCfg} WEB-INF/hibernate.cfg.xml
        sed -i -E 's|^#? *environment\.permanentDirectory *=.*|environment.permanentDirectory=${cfg.stateDir}|' WEB-INF/xwiki.properties
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

    database = {
      type = lib.mkOption {
        type = lib.types.enum [ "hsqldb" ];
        default = "hsqldb";
        description = "Database engine to use.";
      };

      name = lib.mkOption {
        type = lib.types.str;
        default = "xwiki";
        description = "Embedded HSQLDB database name.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.tomcat = lib.mkIf cfg.enableWebserver (
      lib.mkMerge [
        {
          enable = true;
          package = lib.mkDefault pkgs.tomcat10;
          purifyOnStart = lib.mkDefault true;
          webapps = lib.mkDefault (
            (if cfg.rootWebapp then [ ] else [ config.services.tomcat.package.webapps ])
            ++ [ configuredWebapps ]
          );
          javaOpts = lib.mkDefault [ "-Dxwiki.data.dir=${cfg.stateDir}" ];
        }
        {
          commonLibs = lib.mkAfter [ "${pkgs.hsqldb}/lib/hsqldb.jar" ];
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
  };
}
