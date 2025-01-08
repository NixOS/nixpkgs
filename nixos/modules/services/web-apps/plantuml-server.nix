{ config, lib, pkgs, ... }:

let
  inherit (lib)
    literalExpression
    mkEnableOption
    mkIf
    lib.mkOption
    mkPackageOption
    mkRemovedOptionModule
    types
    ;

  cfg = config.services.plantuml-server;

in

{
  imports = [
    (lib.mkRemovedOptionModule [ "services" "plantuml-server" "allowPlantumlInclude" ] "This option has been removed from PlantUML.")
  ];

  options = {
    services.plantuml-server = {
      enable = lib.mkEnableOption "PlantUML server";

      package = lib.mkPackageOption pkgs "plantuml-server" { };

      packages = {
        jdk = mkPackageOption pkgs "jdk" { };
        jetty = mkPackageOption pkgs "jetty" {
          default = [ "jetty_11" ];
          extraDescription = ''
            At the time of writing (v1.2023.12), PlantUML Server does not support
            Jetty versions higher than 12.x.

            Jetty 12.x has introduced major breaking changes, see
            <https://github.com/jetty/jetty.project/releases/tag/jetty-12.0.0> and
            <https://eclipse.dev/jetty/documentation/jetty-12/programming-guide/index.html#pg-migration-11-to-12>
          '';
        };
      };

      user = lib.mkOption {
        type = lib.types.str;
        default = "plantuml";
        description = "User which runs PlantUML server.";
      };

      group = lib.mkOption {
        type = lib.types.str;
        default = "plantuml";
        description = "Group which runs PlantUML server.";
      };

      home = lib.mkOption {
        type = lib.types.path;
        default = "/var/lib/plantuml";
        description = "Home directory of the PlantUML server instance.";
      };

      listenHost = lib.mkOption {
        type = lib.types.str;
        default = "127.0.0.1";
        description = "Host to listen on.";
      };

      listenPort = lib.mkOption {
        type = lib.types.int;
        default = 8080;
        description = "Port to listen on.";
      };

      plantumlLimitSize = lib.mkOption {
        type = lib.types.int;
        default = 4096;
        description = "Limits image width and height.";
      };

      graphvizPackage = mkPackageOption pkgs "graphviz" { };

      plantumlStats = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Set it to on to enable statistics report (https://plantuml.com/statistics-report).";
      };

      httpAuthorization = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = "When calling the proxy endpoint, the value of HTTP_AUTHORIZATION will be used to set the HTTP Authorization header.";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.plantuml-server = {
      description = "PlantUML server";
      wantedBy = [ "multi-user.target" ];

      environment = {
        PLANTUML_LIMIT_SIZE = builtins.toString cfg.plantumlLimitSize;
        GRAPHVIZ_DOT = "${cfg.graphvizPackage}/bin/dot";
        PLANTUML_STATS = if cfg.plantumlStats then "on" else "off";
        HTTP_AUTHORIZATION = cfg.httpAuthorization;
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
        StateDirectory = lib.mkIf (cfg.home == "/var/lib/plantuml") "plantuml";
        StateDirectoryMode = lib.mkIf (cfg.home == "/var/lib/plantuml") "0750";

        # Hardening
        AmbientCapabilities = [ "" ];
        CapabilityBoundingSet = [ "" ];
        DynamicUser = true;
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateNetwork = false;
        PrivateTmp = true;
        PrivateUsers = true;
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectSystem = "strict";
        RestrictAddressFamilies = [ "AF_UNIX" "AF_INET" "AF_INET6" ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" ];
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ truh anthonyroussel ];
}
