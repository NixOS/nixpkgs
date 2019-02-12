{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.jira;

  pkg = pkgs.atlassian-jira.override (optionalAttrs cfg.sso.enable {
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
    services.jira = {
      enable = mkEnableOption "Atlassian JIRA service";

      user = mkOption {
        type = types.str;
        default = "jira";
        description = "User which runs JIRA.";
      };

      group = mkOption {
        type = types.str;
        default = "jira";
        description = "Group which runs JIRA.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/lib/jira";
        description = "Home directory of the JIRA instance.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address to listen on.";
      };

      listenPort = mkOption {
        type = types.int;
        default = 8091;
        description = "Port to listen on.";
      };

      catalinaOptions = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "-Xms1024m" "-Xmx2048m" ];
        description = "Java options to pass to catalina/tomcat.";
      };

      proxy = {
        enable = mkEnableOption "reverse proxy support";

        name = mkOption {
          type = types.str;
          example = "jira.example.com";
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

        secure = mkOption {
          type = types.bool;
          default = true;
          description = "Whether the connections to the proxy should be considered secure.";
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
          description = "Exact name of this JIRA instance in Crowd";
        };

        applicationPassword = mkOption {
          type = types.str;
          description = "Application password of this JIRA instance in Crowd";
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

    systemd.services.atlassian-jira = {
      description = "Atlassian JIRA";

      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];

      path = [ cfg.jrePackage pkgs.bash ];

      environment = {
        JIRA_USER = cfg.user;
        JIRA_HOME = cfg.home;
        JAVA_HOME = "${cfg.jrePackage}";
        CATALINA_OPTS = concatStringsSep " " cfg.catalinaOptions;
      };

      preStart = ''
        mkdir -p ${cfg.home}/{logs,work,temp,deploy}

        mkdir -p /run/atlassian-jira
        ln -sf ${cfg.home}/{logs,work,temp,server.xml} /run/atlassian-jira
        ln -sf ${cfg.home} /run/atlassian-jira/home

        chown ${cfg.user} ${cfg.home}

        sed -e 's,port="8080",port="${toString cfg.listenPort}" address="${cfg.listenAddress}",' \
        '' + (lib.optionalString cfg.proxy.enable ''
          -e 's,protocol="HTTP/1.1",protocol="HTTP/1.1" proxyName="${cfg.proxy.name}" proxyPort="${toString cfg.proxy.port}" scheme="${cfg.proxy.scheme}" secure="${toString cfg.proxy.secure}",' \
        '') + ''
          ${pkg}/conf/server.xml.dist > ${cfg.home}/server.xml
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
        PermissionsStartOnly = true;
        ExecStart = "${pkg}/bin/start-jira.sh -fg";
        ExecStop = "${pkg}/bin/stop-jira.sh";
      };
    };
  };
}
