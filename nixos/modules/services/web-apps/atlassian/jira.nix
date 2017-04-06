{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.jira;

  pkg = pkgs.atlassian-jira;

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

      jrePackage = let
        jreSwitch = unfree: free: if config.nixpkgs.config.allowUnfree or false then unfree else free;
      in mkOption {
        type = types.package;
        default = jreSwitch pkgs.oraclejre8 pkgs.openjdk8.jre;
        defaultText = jreSwitch "pkgs.oraclejre8" "pkgs.openjdk8.jre";
        example = literalExample "pkgs.openjdk8.jre";
        description = "Java Runtime to use for JIRA. Note that Atlassian recommends the Oracle JRE.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers."${cfg.user}" = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.extraGroups."${cfg.group}" = {};

    systemd.services.atlassian-jira = {
      description = "Atlassian JIRA";

      wantedBy = [ "multi-user.target" ];
      requires = [ "postgresql.service" ];
      after = [ "postgresql.service" ];

      path = [ cfg.jrePackage ];

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

        chown -R ${cfg.user} ${cfg.home}

        sed -e 's,port="8080",port="${toString cfg.listenPort}" address="${cfg.listenAddress}",' \
        '' + (lib.optionalString cfg.proxy.enable ''
          -e 's,protocol="HTTP/1.1",protocol="HTTP/1.1" proxyName="${cfg.proxy.name}" proxyPort="${toString cfg.proxy.port}" scheme="${cfg.proxy.scheme}" secure="${toString cfg.proxy.secure}",' \
        '') + ''
          ${pkg}/conf/server.xml.dist > ${cfg.home}/server.xml
      '';

      script = "${pkg}/bin/start-jira.sh -fg";
      stopScript  = "${pkg}/bin/stop-jira.sh";

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
        PermissionsStartOnly = true;
      };
    };
  };
}
