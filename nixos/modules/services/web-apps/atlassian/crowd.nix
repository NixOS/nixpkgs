{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.crowd;

  pkg = pkgs.atlassian-crowd.override {
    home = cfg.home;
    port = cfg.listenPort;
    openidPassword = cfg.openidPassword;
  } // (optionalAttrs cfg.proxy.enable {
    proxyUrl = "${cfg.proxy.scheme}://${cfg.proxy.name}:${toString cfg.proxy.port}";
  });

in

{
  options = {
    services.crowd = {
      enable = mkEnableOption "Atlassian Crowd service";

      user = mkOption {
        type = types.str;
        default = "crowd";
        description = "User which runs Crowd.";
      };

      group = mkOption {
        type = types.str;
        default = "crowd";
        description = "Group which runs Crowd.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/lib/crowd";
        description = "Home directory of the Crowd instance.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Address to listen on.";
      };

      listenPort = mkOption {
        type = types.int;
        default = 8092;
        description = "Port to listen on.";
      };

      openidPassword = mkOption {
        type = types.str;
        description = "Application password for OpenID server.";
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
          example = "crowd.example.com";
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

      jrePackage = mkOption {
        type = types.package;
        default = pkgs.oraclejre8;
        defaultText = "pkgs.oraclejre8";
        description = "Note that Atlassian only support the Oracle JRE (JRASERVER-46152).";
      };
    };
  };

  config = mkIf cfg.enable {
    users.extraUsers."${cfg.user}" = {
      isSystemUser = true;
      group = cfg.group;
    };

    users.extraGroups."${cfg.group}" = {};

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
      };

      preStart = ''
        mkdir -p ${cfg.home}/{logs,work,database}

        mkdir -p /run/atlassian-crowd
        ln -sf ${cfg.home}/{database,work,server.xml} /run/atlassian-crowd

        chown -R ${cfg.user} ${cfg.home}

        sed -e 's,port="8095",port="${toString cfg.listenPort}" address="${cfg.listenAddress}",' \
        '' + (lib.optionalString cfg.proxy.enable ''
          -e 's,compression="on",compression="off" protocol="HTTP/1.1" proxyName="${cfg.proxy.name}" proxyPort="${toString cfg.proxy.port}" scheme="${cfg.proxy.scheme}" secure="${boolToString cfg.proxy.secure}",' \
        '') + ''
          ${pkg}/apache-tomcat/conf/server.xml.dist > ${cfg.home}/server.xml
      '';

      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
        PermissionsStartOnly = true;
        ExecStart = "${pkg}/start_crowd.sh -fg";
      };
    };
  };
}
