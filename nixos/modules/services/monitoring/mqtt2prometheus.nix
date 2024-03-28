{ config, lib, pkgs, ... }:
let
  cfg = config.services.mqtt2prometheus;
  settingsFormat = pkgs.formats.yaml { };
in {
  meta.maintainers = with lib.maintainers; [ lesuisse ];

  options.services.mqtt2prometheus = {
    enable = lib.mkEnableOption "MQTT to Prometheus gateway";

    package = lib.mkPackageOption pkgs "mqtt2prometheus" { };

    listenAddress = lib.mkOption {
      default = "localhost";
      example = "0.0.0.0";
      type = lib.types.str;
      description = lib.mdDoc ''
        Listen address for the MQTT2Prometheus HTTP server used to expose metrics
      '';
    };

    listenPort = lib.mkOption {
      default = 9641;
      type = lib.types.port;
      description = lib.mdDoc ''
        Port used by the MQTT2Prometheus HTTP server used to expose metrics
      '';
    };

    logFormat = lib.mkOption {
      default = "console";
      type = lib.types.enum [ "console" "json" ];
      description = lib.mdDoc ''
        Desired log output format
      '';
    };

    logLevel = lib.mkOption {
      default = "info";
      type = lib.types.enum [ "debug" "info" "warn" "error" ];
      description = lib.mdDoc ''
        Log level
      '';
    };

    settings = lib.mkOption {
      type = settingsFormat.type;
      default = { };
      example = lib.literalExpression ''
        {
          mqtt.server = "tcp://127.0.0.1:1883";
        }
      '';
      description = lib.mdDoc ''
        Your {file}`config.yaml` as a Nix attribute set.
        Check the [documentation](https://github.com/hikhvar/mqtt2prometheus#config-file)
        for possible options.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.mqtt2prometheus = {
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      description = "MQTT to Prometheus gateway";
      serviceConfig = let
        configFile = settingsFormat.generate "config.yaml" cfg.settings;
      in {
        ExecStart = ''
          ${cfg.package}/bin/mqtt2prometheus \
            -config ${configFile} \
            -listen-address ${lib.escapeShellArg cfg.listenAddress} \
            -listen-port ${toString cfg.listenPort} \
            -log-format ${cfg.logFormat} \
            -log-level ${cfg.logLevel}
        '';
        DynamicUser = "yes";
        PrivateUsers = "yes";
        PrivateDevices = "yes";
        ProtectClock = "yes";
        ProtectControlGroups = "yes";
        ProtectHome = "yes";
        ProtectKernelLogs = "yes";
        ProtectKernelModules = "yes";
        ProtectKernelTunables = "yes";
        ProtectHostname = "yes";
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        LockPersonality = "yes";
        RestrictAddressFamilies = [ "AF_INET" "AF_INET6" ];
        RestrictRealtime = "yes";
        RestrictNamespaces = "yes";
        MemoryDenyWriteExecute = "yes";
        CapabilityBoundingSet = "";
        SystemCallArchitectures = "native";
        SystemCallFilter = [ "@system-service" "~@privileged" ];
        UMask = "0027";
      };
    };
  };
}
