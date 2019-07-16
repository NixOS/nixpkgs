{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.confluence;

  pkg = cfg.package.override (optionalAttrs cfg.sso.enable {
    enableSSO = cfg.sso.enable;
    crowdProperties = ''
      application.name                        ${cfg.sso.applicationName}
      application.password                    ${cfg.sso.applicationPassword}
      application.login.url                   ${cfg.sso.crowd}/console/

      crowd.server.url                        ${cfg.sso.crowd}/services/
      crowd.base.url                          ${cfg.sso.crowd}/

      session.isauthenticated                 session.isauthenticated
      session.tokenkey                        session.tokenkey
      session.validationinterval              ${toString cfg.sso.validationInterval}
      session.lastvalidation                  session.lastvalidation
    '';
  });

in

{
  options = {
    services.confluence = {
      enable = mkEnableOption "Atlassian Confluence service";

      user = mkOption {
        type = types.str;
        default = "confluence";
        description = "User which runs confluence.";
      };

      group = mkOption {
        type = types.str;
        default = "confluence";
        description = "Group which runs confluence.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/lib/confluence";
        description = "Home directory of the confluence instance.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address to listen on.";
      };

      listenPort = mkOption {
        type = types.int;
        default = 8090;
        description = "Port to listen on.";
      };

      catalinaOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "-Xms1024m" "-Xmx2048m" "-Dconfluence.disable.peopledirectory.all=true" ];
        description = "Java options to pass to catalina/tomcat.";
      };

      proxy = {
        enable = mkEnableOption "proxy support";

        name = mkOption {
          type = types.str;
          example = "confluence.example.com";
          description = "Virtual hostname at the proxy";
        };

        port = mkOption {
          type = types.int;
          default = 443;
          example = 80;
          description = "Port used at the proxy";
        };

        scheme = mkOption {
          type = types.str;
          default = "https";
          example = "http";
          description = "Protocol used at the proxy.";
        };
      };

      sso = {
        enable = mkEnableOption "SSO with Atlassian Crowd";

        crowd = mkOption {
          type = types.str;
          example = "http://localhost:8095/crowd";
          description = "Crowd Base URL without trailing slash";
        };

        applicationName = mkOption {
          type = types.str;
          example = "jira";
          description = "Exact name of this Confluence instance in Crowd";
        };

        applicationPassword = mkOption {
          type = types.str;
          description = "Application password of this Confluence instance in Crowd";
        };

        validationInterval = mkOption {
          type = types.int;
          default = 2;
          example = 0;
          description = ''
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
        defaultText = "pkgs.atlassian-confluence";
        description = "Atlassian Confluence package to use.";
      };

      jrePackage = mkOption {
        type = types.package;
        default = pkgs.oraclejre8;
        defaultText = "pkgs.oraclejre8";
        description = "Note that Atlassian only support the Oracle JRE (JRASERVER-46152).";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users."${cfg.user}" = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.groups."${cfg.group}" = {};

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
      };

      preStart = ''
        mkdir -p ${cfg.home}/{logs,work,temp,deploy}

        sed -e 's,port="8090",port="${toString cfg.listenPort}" address="${cfg.listenAddress}",' \
        '' + (lib.optionalString cfg.proxy.enable ''
          -e 's,protocol="org.apache.coyote.http11.Http11NioProtocol",protocol="org.apache.coyote.http11.Http11NioProtocol" proxyName="${cfg.proxy.name}" proxyPort="${toString cfg.proxy.port}" scheme="${cfg.proxy.scheme}",' \
        '') + ''
          ${pkg}/conf/server.xml.dist > ${cfg.home}/server.xml
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
        ExecStart = "${pkg}/bin/start-confluence.sh -fg";
        ExecStop = "${pkg}/bin/stop-confluence.sh";
      };
    };
  };
}
