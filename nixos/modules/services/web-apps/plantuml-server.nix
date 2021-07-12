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
        description = "PlantUML server package to use";
      };

      user = mkOption {
        type = types.str;
        default = "plantuml";
        description = "User which runs PlantUML server.";
      };

      group = mkOption {
        type = types.str;
        default = "plantuml";
        description = "Group which runs PlantUML server.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/lib/plantuml";
        description = "Home directory of the PlantUML server instance.";
      };

      listenHost = mkOption {
        type = types.str;
        default = "127.0.0.1";
        description = "Host to listen on.";
      };

      listenPort = mkOption {
        type = types.int;
        default = 8080;
        description = "Port to listen on.";
      };

      plantumlLimitSize = mkOption {
        type = types.int;
        default = 4096;
        description = "Limits image width and height.";
      };

      graphvizPackage = mkOption {
        type = types.package;
        default = pkgs.graphviz_2_32;
        description = "Package containing the dot executable.";
      };

      plantumlStats = mkOption {
        type = types.bool;
        default = false;
        description = "Set it to on to enable statistics report (https://plantuml.com/statistics-report).";
      };

      httpAuthorization = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "When calling the proxy endpoint, the value of HTTP_AUTHORIZATION will be used to set the HTTP Authorization header.";
      };

      allowPlantumlInclude = mkOption {
        type = types.bool;
        default = false;
        description = "Enables !include processing which can read files from the server into diagrams. Files are read relative to the current working directory.";
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
      ${pkgs.jre}/bin/java \
        -jar ${pkgs.jetty}/start.jar \
          --module=deploy,http,jsp \
          jetty.home=${pkgs.jetty} \
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
