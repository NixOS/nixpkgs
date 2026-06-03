{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkIf
    mkOption
    mkEnableOption
    mkPackageOption
    getExe
    types
    ;
  cfg = config.services.openems.edge;
in
{
  options.services.openems.edge = {
    enable = mkEnableOption "OpenEMS Edge service for communicating with devices and services, collecting data and executing control algorithms";

    package = mkPackageOption pkgs "openems-edge" { };

    configDir = mkOption {
      type = types.path;
      default = "/var/lib/openems.d";
      example = "/etc/openems.d";
      description = ''
        Path to the OSGi configs.
        Must be provisioned manually because some configs contain secrets that should not live in the world-readable Nix store.
        Alternatively, configs can be edited via the Apache Felix web interface at
        http://admin:admin@localhost:<felix-port>/system/console/configMgr
      '';
    };

    ui = {
      enable = mkEnableOption "OpenEMS web UI";
      port = mkOption {
        type = types.port;
        default = 8085;
        description = "Websocket port to for openems-ui to connect to";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = "Set to true to open the TCP port for the OpenEMS Edge websocket";
      };
    };

    felix = {
      port = mkOption {
        type = types.port;
        default = 8080;
        description = "Port of the Apache Felix web console";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = "Set to true to open the TCP port for the Apache Felix web console";
      };
    };

    watchdog.timeout = mkOption {
      type = types.nullOr types.int;
      default = 60;
      description = "Service watchdog timeout in seconds (`null` to disable)";
    };

  };

  config = mkIf cfg.enable {
    systemd.services.openems-edge = {
      description = "OpenEMS Edge";

      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = 10;
        WatchdogSec = cfg.watchdog.timeout;
        ExecStart = getExe cfg.package;
      };

      environment.JAVA_OPTS = lib.concatStringsSep " " [
        "-Dfelix.cm.dir=${cfg.configDir}"
        "-Dorg.osgi.service.http.port=${toString cfg.felix.port}"
      ];

      preStart = ''
                mkdir -p ${cfg.configDir}/Controller/Api/Websocket
                cat > ${cfg.configDir}/Controller/Api/Websocket/13718db7-fae4-48ae-b023-dcf6b764c25b.config <<EOF
        alias=""
        apiTimeout=I"60"
        enabled=B"${if cfg.ui.enable then "true" else "false"}"
        id="ctrlApiWebsocket0"
        port=I"${toString cfg.ui.port}"
        service.factoryPid="Controller.Api.Websocket"
        service.pid="Controller.Api.Websocket.13718db7-fae4-48ae-b023-dcf6b764c25b"
        EOF
      '';
    };

    networking.firewall.allowedTCPPorts =
      (lib.optional (cfg.ui.enable && cfg.ui.openFirewall) cfg.ui.port)
      ++ (lib.optional cfg.felix.openFirewall cfg.felix.port);

  };
}
