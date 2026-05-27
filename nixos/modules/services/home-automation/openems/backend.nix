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
  cfg = config.services.openems.backend;
in
{
  options.services.openems.backend = {
    enable = mkEnableOption "OpenEMS platform connecting decentralized Edge systems and providing aggregation, monitoring and control";

    package = mkPackageOption pkgs "openems-backend" { };

    configDir = mkOption {
      type = types.path;
      default = "/var/lib/openems-backend/config.d";
      example = "/etc/openems-backend/config.d";
      description = ''
        Path to the OSGi configs.
        Must be provisioned manually because some configs contain secrets that should not live in the world-readable Nix store.
        Alternatively, configs can be edited via the Apache Felix web interface at
        http://admin:admin@localhost:<felix-port>/system/console/configMgr
      '';
    };

    ui = {
      port = mkOption {
        type = types.port;
        default = 8082;
        description = "Websocket port to for openems-ui to connect to";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = "Set to true to open the TCP port for the UI websocket port";
      };
    };

    edgeManager = {
      port = mkOption {
        type = types.port;
        default = 8081;
        description = "Websocket port for openems-edge nodes to connect to";
      };

      openFirewall = mkOption {
        type = types.bool;
        default = true;
        description = "Set to true to open the TCP port for the edge websocket port";
      };
    };

    felix = {
      port = mkOption {
        type = types.port;
        default = 8079;
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
      default = 180;
      description = "Service watchdog timeout in seconds (`null` to disable)";
    };

  };

  config = mkIf cfg.enable {
    systemd.services.openems-backend = {
      description = "OpenEMS Backend";

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
        "-Djava.util.concurrent.ForkJoinPool.common.parallelism=100"
        "-XX:+ExitOnOutOfMemoryError"
      ];

      preStart = ''
                mkdir -p ${cfg.configDir}/Edge
                cat > ${cfg.configDir}/Edge/Manager.config <<EOF
        :org.apache.felix.configadmin.revision:=L"1"
        poolSize=I"10"
        port=I"${toString cfg.edgeManager.port}"
        service.pid="Edge.Manager"
        EOF
                mkdir -p ${cfg.configDir}/Ui
                cat > ${cfg.configDir}/Ui/Websocket.config <<EOF
        :org.apache.felix.configadmin.revision:=L"1"
        poolSize=I"10"
        port=I"${toString cfg.ui.port}"
        requestLimit=I"20"
        service.pid="Ui.Websocket"
        EOF
      '';
    };

    networking.firewall.allowedTCPPorts =
      (lib.optional cfg.ui.openFirewall cfg.ui.port)
      ++ (lib.optional (cfg.edgeManager.openFirewall) cfg.edgeManager.port)
      ++ (lib.optional cfg.felix.openFirewall cfg.felix.port);
  };
}
