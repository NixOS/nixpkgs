{ config, lib, pkgs, ... }:

let
  cfg = config.services.trickster;
in
{
  imports = [
    (lib.mkRenamedOptionModule [ "services" "trickster" "origin" ] [ "services" "trickster" "origin-url" ])
  ];

  options = {
    services.trickster = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Enable Trickster.
        '';
      };

      package = lib.mkPackageOption pkgs "trickster" { };

      configFile = lib.mkOption {
        type = lib.types.nullOr lib.types.path;
        default = null;
        description = ''
          Path to configuration file.
        '';
      };

      instance-id = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = ''
          Instance ID for when running multiple processes (default null).
        '';
      };

      log-level = lib.mkOption {
        type = lib.types.str;
        default = "info";
        description = ''
          Level of Logging to use (debug, info, warn, error) (default "info").
        '';
      };

      metrics-port = lib.mkOption {
        type = lib.types.port;
        default = 8082;
        description = ''
          Port that the /metrics endpoint will listen on.
        '';
      };

      origin-type = lib.mkOption {
        type = lib.types.enum [ "prometheus" "influxdb" ];
        default = "prometheus";
        description = ''
          Type of origin (prometheus, influxdb)
        '';
      };

      origin-url = lib.mkOption {
        type = lib.types.str;
        default = "http://prometheus:9090";
        description = ''
          URL to the Origin. Enter it like you would in grafana, e.g., http://prometheus:9090 (default http://prometheus:9090).
        '';
      };

      profiler-port = lib.mkOption {
        type = lib.types.nullOr lib.types.port;
        default = null;
        description = ''
          Port that the /debug/pprof endpoint will listen on.
        '';
      };

      proxy-port = lib.mkOption {
        type = lib.types.port;
        default = 9090;
        description = ''
          Port that the Proxy server will listen on.
        '';
      };

    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.trickster = {
      description = "Reverse proxy cache and time series dashboard accelerator";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        DynamicUser = true;
        ExecStart = ''
          ${cfg.package}/bin/trickster \
          -log-level ${cfg.log-level} \
          -metrics-port ${toString cfg.metrics-port} \
          -origin-type ${cfg.origin-type} \
          -origin-url ${cfg.origin-url} \
          -proxy-port ${toString cfg.proxy-port} \
          ${lib.optionalString (cfg.configFile != null) "-config ${cfg.configFile}"} \
          ${lib.optionalString (cfg.profiler-port != null) "-profiler-port ${cfg.profiler-port}"} \
          ${lib.optionalString (cfg.instance-id != null) "-instance-id ${cfg.instance-id}"}
        '';
        ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
        Restart = "always";
      };
    };
  };

  meta.maintainers = with lib.maintainers; [ _1000101 ];

}
