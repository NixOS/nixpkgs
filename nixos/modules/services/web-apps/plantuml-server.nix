{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.plantuml-server;

in

{
  options = {
    services.plantuml-server = {
      enable = mkEnableOption "PlantUML server";

      package = mkOption {
        type = types.package;
        default = pkgs.plantuml-server;
        defaultText = literalExpression "pkgs.plantuml-server";
        description = lib.mdDoc "PlantUML server package to use";
      };

      packages = {
        jdk = mkOption {
          type = types.package;
          default = pkgs.jdk;
          defaultText = literalExpression "pkgs.jdk";
          description = lib.mdDoc "JDK package to use for the server";
        };
        jetty = mkOption {
          type = types.package;
          default = pkgs.jetty;
          defaultText = literalExpression "pkgs.jetty";
          description = lib.mdDoc "Jetty package to use for the server";
        };
      };

      user = mkOption {
        type = types.str;
        default = "plantuml";
        description = lib.mdDoc "User which runs PlantUML server.";
      };

      group = mkOption {
        type = types.str;
        default = "plantuml";
        description = lib.mdDoc "Group which runs PlantUML server.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/lib/plantuml";
        description = lib.mdDoc "Home directory of the PlantUML server instance.";
      };

      listenHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = lib.mdDoc "Host to listen on.";
      };

      listenPort = mkOption {
        type = types.int;
        default = 8080;
        description = lib.mdDoc "Port to listen on.";
      };

      plantumlLimitSize = mkOption {
        type = types.int;
        default = 4096;
        description = lib.mdDoc "Limits image width and height.";
      };

      graphvizPackage = mkOption {
        type = types.package;
        default = pkgs.graphviz;
        defaultText = literalExpression "pkgs.graphviz";
        description = lib.mdDoc "Package containing the dot executable.";
      };

      plantumlStats = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Set it to on to enable statistics report (https://plantuml.com/statistics-report).";
      };

      httpAuthorization = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = lib.mdDoc "When calling the proxy endpoint, the value of HTTP_AUTHORIZATION will be used to set the HTTP Authorization header.";
      };

      allowPlantumlInclude = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc "Enables !include processing which can read files from the server into diagrams. Files are read relative to the current working directory.";
      };
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      home = cfg.home;
      createHome = true;
    };

    users.groups.${cfg.group} = {};

    systemd.services.plantuml-server = {
      description = "PlantUML server";
      wantedBy = [ "multi-user.target" ];
      path = [ cfg.home ];
      environment = {
        PLANTUML_LIMIT_SIZE = builtins.toString cfg.plantumlLimitSize;
        GRAPHVIZ_DOT = "${cfg.graphvizPackage}/bin/dot";
        PLANTUML_STATS = if cfg.plantumlStats then "on" else "off";
        HTTP_AUTHORIZATION = cfg.httpAuthorization;
        ALLOW_PLANTUML_INCLUDE = if cfg.allowPlantumlInclude then "true" else "false";
      };
      script = ''
      ${cfg.packages.jdk}/bin/java \
        -jar ${cfg.packages.jetty}/start.jar \
          --module=deploy,http,jsp \
          jetty.home=${cfg.packages.jetty} \
          jetty.base=${cfg.package} \
          jetty.http.host=${cfg.listenHost} \
          jetty.http.port=${builtins.toString cfg.listenPort}
      '';
      serviceConfig = {
        User = cfg.user;
        Group = cfg.group;
        PrivateTmp = true;
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ truh ];
}
