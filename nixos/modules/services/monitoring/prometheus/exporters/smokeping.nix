{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.smokeping;
  goDuration = lib.types.mkOptionType {
    name = "goDuration";
    description = "Go duration (https://golang.org/pkg/time/#ParseDuration)";
    check =
      x: lib.types.str.check x && builtins.match "(-?[0-9]+(\.[0-9]+)?(ns|us|µs|ms|s|m|h))+" x != null;
    inherit (lib.types.str) merge;
  };
in
{
  port = 9374;
  extraOpts = {
    telemetryPath = lib.mkOption {
      type = lib.types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
    pingInterval = lib.mkOption {
      type = goDuration;
      default = "1s";
      description = ''
        Interval between pings.
      '';
    };
    buckets = lib.mkOption {
      type = lib.types.commas;
      default = "5e-05,0.0001,0.0002,0.0004,0.0008,0.0016,0.0032,0.0064,0.0128,0.0256,0.0512,0.1024,0.2048,0.4096,0.8192,1.6384,3.2768,6.5536,13.1072,26.2144";
      description = ''
        List of buckets to use for the response duration histogram.
      '';
    };
    hosts = lib.mkOption {
      type = with lib.types; listOf str;
      description = ''
        List of endpoints to probe.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      AmbientCapabilities = [ "CAP_NET_RAW" ];
      CapabilityBoundingSet = [ "CAP_NET_RAW" ];
      ExecStart = ''
        ${pkgs.prometheus-smokeping-prober}/bin/smokeping_prober \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --web.telemetry-path ${cfg.telemetryPath} \
          --buckets ${cfg.buckets} \
          --ping.interval ${cfg.pingInterval} \
          --privileged \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags} \
          ${lib.concatStringsSep " " cfg.hosts}
      '';
    };
  };
}
