{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.crowd;

  pkg = cfg.package.override {
    home = cfg.home;
    port = cfg.listenPort;
    openidPassword = cfg.openidPassword;
  } // (optionalAttrs cfg.proxy.enable {
    proxyUrl = "${cfg.proxy.scheme}://${cfg.proxy.name}:${toString cfg.proxy.port}";
  });

  crowdPropertiesFile = pkgs.writeText "crowd.properties" ''
    application.name                        crowd-openid-server
    application.password @NIXOS_CROWD_OPENID_PW@
    application.base.url                    http://localhost:${toString cfg.listenPort}/openidserver
    application.login.url                   http://localhost:${toString cfg.listenPort}/openidserver
    application.login.url.template          http://localhost:${toString cfg.listenPort}/openidserver?returnToUrl=''${RETURN_TO_URL}

    crowd.server.url                        http://localhost:${toString cfg.listenPort}/crowd/services/

    session.isauthenticated                 session.isauthenticated
    session.tokenkey                        session.tokenkey
    session.validationinterval              0
    session.lastvalidation                  session.lastvalidation
  '';

in

{
  options = {
    services.crowd = {
      enable = mkEnableOption (lib.mdDoc "Atlassian Crowd service");

      user = mkOption {
        type = types.str;
        default = "crowd";
        description = lib.mdDoc "User which runs Crowd.";
      };

      group = mkOption {
        type = types.str;
        default = "crowd";
        description = lib.mdDoc "Group which runs Crowd.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/lib/crowd";
        description = lib.mdDoc "Home directory of the Crowd instance.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc "Address to listen on.";
      };

      listenPort = mkOption {
        type = types.int;
        default = 8092;
        description = lib.mdDoc "Port to listen on.";
      };

      openidPassword = mkOption {
        type = types.str;
        default = "WILL_NEVER_BE_SET";
        description = lib.mdDoc "Application password for OpenID server.";
      };

      openidPasswordFile = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc "Path to the file containing the application password for OpenID server.";
      };

      catalinaOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "-Xms1024m" "-Xmx2048m" ];
        description = lib.mdDoc "Java options to pass to catalina/tomcat.";
      };

      proxy = {
        enable = mkEnableOption (lib.mdDoc "reverse proxy support");

        name = mkOption {
          type = types.str;
          example = "crowd.example.com";
          description = lib.mdDoc "Virtual hostname at the proxy";
        };

        port = mkOption {
          type = types.int;
          default = 443;
          example = 80;
          description = lib.mdDoc "Port used at the proxy";
        };

        scheme = mkOption {
          type = types.str;
          default = "https";
          example = "http";
          description = lib.mdDoc "Protocol used at the proxy.";
        };

        secure = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Whether the connections to the proxy should be considered secure.";
        };
      };

      package = mkOption {
        type = types.package;
        default = pkgs.atlassian-crowd;
        defaultText = literalExpression "pkgs.atlassian-crowd";
        description = lib.mdDoc "Atlassian Crowd package to use.";
      };

      jrePackage = mkOption {
        type = types.package;
        default = pkgs.oraclejre8;
        defaultText = literalExpression "pkgs.oraclejre8";
        description = lib.mdDoc "Note that Atlassian only support the Oracle JRE (JRASERVER-46152).";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups.${cfg.group} = {};

    systemd.tmpfiles.rules = [
      "d '${cfg.home}' - ${cfg.user} ${cfg.group} - -"
      "d /run/atlassian-crowd - - - - -"

      "L+ /run/atlassian-crowd/database - - - - ${cfg.home}/database"
      "L+ /run/atlassian-crowd/logs - - - - ${cfg.home}/logs"
      "L+ /run/atlassian-crowd/work - - - - ${cfg.home}/work"
      "L+ /run/atlassian-crowd/server.xml - - - - ${cfg.home}/server.xml"
    ];

    systemd.services.atlassian-crowd = {
      description = "Atlassian Crowd";

      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];

      path = [ cfg.jrePackage ];

      environment = {
        JAVA_HOME = "${cfg.jrePackage}";
        CATALINA_OPTS = concatStringsSep " " cfg.catalinaOptions;
        CATALINA_TMPDIR = "/tmp";
        JAVA_OPTS = mkIf (cfg.openidPasswordFile != null) "-Dcrowd.properties=${cfg.home}/crowd.properties";
      };

      preStart = ''
        rm -rf ${cfg.home}/work
        mkdir -p ${cfg.home}/{logs,database,work}

        sed -e 's,port="8095",port="${toString cfg.listenPort}" address="${cfg.listenAddress}",' \
        '' + (lib.optionalString cfg.proxy.enable ''
          -e 's,compression="on",compression="off" protocol="HTTP/1.1" proxyName="${cfg.proxy.name}" proxyPort="${toString cfg.proxy.port}" scheme="${cfg.proxy.scheme}" secure="${boolToString cfg.proxy.secure}",' \
        '') + ''
          ${pkg}/apache-tomcat/conf/server.xml.dist > ${cfg.home}/server.xml

        ${optionalString (cfg.openidPasswordFile != null) ''
          install -m660 ${crowdPropertiesFile} ${cfg.home}/crowd.properties
          ${pkgs.replace-secret}/bin/replace-secret \
            '@NIXOS_CROWD_OPENID_PW@' \
            ${cfg.openidPasswordFile} \
            ${cfg.home}/crowd.properties
        ''}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
        Restart = "on-failure";
        RestartSec = "10";
        ExecStart = "${pkg}/start_crowd.sh -fg";
      };
    };
  };
}
