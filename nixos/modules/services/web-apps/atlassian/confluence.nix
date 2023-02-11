{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.confluence;

  pkg = cfg.package.override (optionalAttrs cfg.sso.enable {
    enableSSO = cfg.sso.enable;
  });

  crowdProperties = pkgs.writeText "crowd.properties" ''
    application.name                        ${cfg.sso.applicationName}
    application.password                    ${if cfg.sso.applicationPassword != null then cfg.sso.applicationPassword else "@NIXOS_CONFLUENCE_CROWD_SSO_PWD@"}
    application.login.url                   ${cfg.sso.crowd}/console/

    crowd.server.url                        ${cfg.sso.crowd}/services/
    crowd.base.url                          ${cfg.sso.crowd}/

    session.isauthenticated                 session.isauthenticated
    session.tokenkey                        session.tokenkey
    session.validationinterval              ${toString cfg.sso.validationInterval}
    session.lastvalidation                  session.lastvalidation
  '';

in

{
  options = {
    services.confluence = {
      enable = mkEnableOption (lib.mdDoc "Atlassian Confluence service");

      user = mkOption {
        type = types.str;
        default = "confluence";
        description = lib.mdDoc "User which runs confluence.";
      };

      group = mkOption {
        type = types.str;
        default = "confluence";
        description = lib.mdDoc "Group which runs confluence.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/lib/confluence";
        description = lib.mdDoc "Home directory of the confluence instance.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc "Address to listen on.";
      };

      listenPort = mkOption {
        type = types.port;
        default = 8090;
        description = lib.mdDoc "Port to listen on.";
      };

      catalinaOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "-Xms1024m" "-Xmx2048m" "-Dconfluence.disable.peopledirectory.all=true" ];
        description = lib.mdDoc "Java options to pass to catalina/tomcat.";
      };

      proxy = {
        enable = mkEnableOption (lib.mdDoc "proxy support");

        name = mkOption {
          type = types.str;
          example = "confluence.example.com";
          description = lib.mdDoc "Virtual hostname at the proxy";
        };

        port = mkOption {
          type = types.port;
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
      };

      sso = {
        enable = mkEnableOption (lib.mdDoc "SSO with Atlassian Crowd");

        crowd = mkOption {
          type = types.str;
          example = "http://localhost:8095/crowd";
          description = lib.mdDoc "Crowd Base URL without trailing slash";
        };

        applicationName = mkOption {
          type = types.str;
          example = "jira";
          description = lib.mdDoc "Exact name of this Confluence instance in Crowd";
        };

        applicationPassword = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc "Application password of this Confluence instance in Crowd";
        };

        applicationPasswordFile = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = lib.mdDoc "Path to the application password for Crowd of Confluence.";
        };

        validationInterval = mkOption {
          type = types.int;
          default = 2;
          example = 0;
          description = lib.mdDoc ''
            Set to 0, if you want authentication checks to occur on each
            request. Otherwise set to the number of minutes between request
            to validate if the user is logged in or out of the Crowd SSO
            server. Setting this value to 1 or higher will increase the
            performance of Crowd's integration.
          '';
        };
      };

      package = mkOption {
        type = types.package;
        default = pkgs.atlassian-confluence;
        defaultText = literalExpression "pkgs.atlassian-confluence";
        description = lib.mdDoc "Atlassian Confluence package to use.";
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

    assertions = [
      { assertion = cfg.sso.enable -> ((cfg.sso.applicationPassword == null) != (cfg.sso.applicationPasswordFile));
        message = "Please set either applicationPassword or applicationPasswordFile";
      }
    ];

    warnings = mkIf (cfg.sso.enable && cfg.sso.applicationPassword != null) [
      "Using `services.confluence.sso.applicationPassword` is deprecated! Use `applicationPasswordFile` instead!"
    ];

    users.groups.${cfg.group} = {};

    systemd.tmpfiles.rules = [
      "d '${cfg.home}' - ${cfg.user} - - -"
      "d /run/confluence - - - - -"

      "L+ /run/confluence/home - - - - ${cfg.home}"
      "L+ /run/confluence/logs - - - - ${cfg.home}/logs"
      "L+ /run/confluence/temp - - - - ${cfg.home}/temp"
      "L+ /run/confluence/work - - - - ${cfg.home}/work"
      "L+ /run/confluence/server.xml - - - - ${cfg.home}/server.xml"
    ];

    systemd.services.confluence = {
      description = "Atlassian Confluence";

      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];

      path = [ cfg.jrePackage pkgs.bash ];

      environment = {
        CONF_USER = cfg.user;
        JAVA_HOME = "${cfg.jrePackage}";
        CATALINA_OPTS = concatStringsSep " " cfg.catalinaOptions;
        JAVA_OPTS = mkIf cfg.sso.enable "-Dcrowd.properties=${cfg.home}/crowd.properties";
      };

      preStart = ''
        mkdir -p ${cfg.home}/{logs,work,temp,deploy}

        sed -e 's,port="8090",port="${toString cfg.listenPort}" address="${cfg.listenAddress}",' \
        '' + (lib.optionalString cfg.proxy.enable ''
          -e 's,protocol="org.apache.coyote.http11.Http11NioProtocol",protocol="org.apache.coyote.http11.Http11NioProtocol" proxyName="${cfg.proxy.name}" proxyPort="${toString cfg.proxy.port}" scheme="${cfg.proxy.scheme}",' \
        '') + ''
          ${pkg}/conf/server.xml.dist > ${cfg.home}/server.xml

        ${optionalString cfg.sso.enable ''
          install -m660 ${crowdProperties} ${cfg.home}/crowd.properties
          ${optionalString (cfg.sso.applicationPasswordFile != null) ''
            ${pkgs.replace-secret}/bin/replace-secret \
              '@NIXOS_CONFLUENCE_CROWD_SSO_PWD@' \
              ${cfg.sso.applicationPasswordFile} \
              ${cfg.home}/crowd.properties
          ''}
        ''}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
        Restart = "on-failure";
        RestartSec = "10";
        ExecStart = "${pkg}/bin/start-confluence.sh -fg";
        ExecStop = "${pkg}/bin/stop-confluence.sh";
      };
    };
  };
}
