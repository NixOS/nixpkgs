{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.jira;

  pkg = cfg.package.override (optionalAttrs cfg.sso.enable {
    enableSSO = cfg.sso.enable;
  });

  crowdProperties = pkgs.writeText "crowd.properties" ''
    application.name                        ${cfg.sso.applicationName}
    application.password                    @NIXOS_JIRA_CROWD_SSO_PWD@
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
    services.jira = {
      enable = mkEnableOption (lib.mdDoc "Atlassian JIRA service");

      user = mkOption {
        type = types.str;
        default = "jira";
        description = lib.mdDoc "User which runs JIRA.";
      };

      group = mkOption {
        type = types.str;
        default = "jira";
        description = lib.mdDoc "Group which runs JIRA.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/lib/jira";
        description = lib.mdDoc "Home directory of the JIRA instance.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc "Address to listen on.";
      };

      listenPort = mkOption {
        type = types.port;
        default = 8091;
        description = lib.mdDoc "Port to listen on.";
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
          example = "jira.example.com";
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

        secure = mkOption {
          type = types.bool;
          default = true;
          description = lib.mdDoc "Whether the connections to the proxy should be considered secure.";
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
          description = lib.mdDoc "Exact name of this JIRA instance in Crowd";
        };

        applicationPasswordFile = mkOption {
          type = types.str;
          description = lib.mdDoc "Path to the file containing the application password of this JIRA instance in Crowd";
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

      package = mkPackageOption pkgs "atlassian-jira" { };

      jrePackage = mkPackageOption pkgs "oraclejre8" {
        extraDescription = ''
        ::: {.note }
        Atlassian only supports the Oracle JRE (JRASERVER-46152).
        :::
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.home;
    };

    users.groups.${cfg.group} = {};

    systemd.tmpfiles.rules = [
      "d '${cfg.home}' - ${cfg.user} - - -"
      "d /run/atlassian-jira - - - - -"

      "L+ /run/atlassian-jira/home - - - - ${cfg.home}"
      "L+ /run/atlassian-jira/logs - - - - ${cfg.home}/logs"
      "L+ /run/atlassian-jira/work - - - - ${cfg.home}/work"
      "L+ /run/atlassian-jira/temp - - - - ${cfg.home}/temp"
      "L+ /run/atlassian-jira/server.xml - - - - ${cfg.home}/server.xml"
    ];

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
        JAVA_OPTS = mkIf cfg.sso.enable "-Dcrowd.properties=${cfg.home}/crowd.properties";
      };

      preStart = ''
        mkdir -p ${cfg.home}/{logs,work,temp,deploy}

        sed -e 's,port="8080",port="${toString cfg.listenPort}" address="${cfg.listenAddress}",' \
        '' + (lib.optionalString cfg.proxy.enable ''
          -e 's,protocol="HTTP/1.1",protocol="HTTP/1.1" proxyName="${cfg.proxy.name}" proxyPort="${toString cfg.proxy.port}" scheme="${cfg.proxy.scheme}" secure="${toString cfg.proxy.secure}",' \
        '') + ''
          ${pkg}/conf/server.xml.dist > ${cfg.home}/server.xml

        ${optionalString cfg.sso.enable ''
          install -m660 ${crowdProperties} ${cfg.home}/crowd.properties
          ${pkgs.replace-secret}/bin/replace-secret \
            '@NIXOS_JIRA_CROWD_SSO_PWD@' \
            ${cfg.sso.applicationPasswordFile} \
            ${cfg.home}/crowd.properties
        ''}
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
        Restart = "on-failure";
        RestartSec = "10";
        ExecStart = "${pkg}/bin/start-jira.sh -fg";
        ExecStop = "${pkg}/bin/stop-jira.sh";
      };
    };
  };

  imports = [
    (mkRemovedOptionModule [ "services" "jira" "sso" "applicationPassword" ] ''
      Use `applicationPasswordFile` instead!
    '')
  ];
}
