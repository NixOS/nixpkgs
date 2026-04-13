{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.podman;
  boolFlag = name: value: lib.optional (value == true) name;
  inherit (lib)
    mkOption
    types
    ;

  args = lib.flatten [
    (lib.optional (cfg.collector.cacheDuration != null) [
      "--collector.cache_duration"
      (toString cfg.collector.cacheDuration)
    ])
    (lib.optional (cfg.web.maxRequests != null) [
      "--web.max-requests"
      (toString cfg.web.maxRequests)
    ])
    (lib.optional (cfg.web.telemetryPath != null) [
      "--web.telemetry-path"
      cfg.web.telemetryPath
    ])
    [
      "--web.listen-address"
      "${cfg.listenAddress}:${toString cfg.port}"
    ]
    (boolFlag "--collector.enable-all" cfg.collector.enableAll)
    (boolFlag "--collector.enhance-metrics" cfg.collector.enhanceMetrics)
    (boolFlag "--collector.image" cfg.collector.image)
    (boolFlag "--collector.network" cfg.collector.network)
    (boolFlag "--collector.pod" cfg.collector.pod)
    (boolFlag "--collector.store_labels" cfg.collector.storeLabels)
    (boolFlag "--collector.system" cfg.collector.system)
    (boolFlag "--collector.volume" cfg.collector.volume)
    (boolFlag "--debug" cfg.debug)
    (boolFlag "--web.disable-exporter-metrics" cfg.web.disableExporterMetrics)
    (lib.optional (cfg.collector.whitelistedLabels != null) [
      "--collector.whitelisted_labels"
      cfg.collector.whitelistedLabels
    ])
    (lib.optional (cfg.web.configFile != null) [
      "--web.config.file"
      (toString cfg.web.configFile)
    ])
  ];
in
{
  port = 9156;
  extraOpts = {
    package = lib.mkPackageOption pkgs "prometheus-podman-exporter" { };

    podmanSocket = mkOption {
      type = types.str;
      default = "unix:///var/run/podman/podman.sock";
      description = "path to podman UNIX or network socket for connection";
    };

    collector = {
      cacheDuration = mkOption {
        type = types.nullOr types.ints.positive;
        default = null;
        description = "Duration (seconds) to retrieve container, size and refresh the cache";
      };
      enableAll = mkOption {
        type = types.nullOr types.bool;
        default = false;
        description = "Enable all collectors by default";
      };
      enhanceMetrics = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enhance all metrics with the same field as their podman_<...>_info metrics";
      };
      image = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable image collector";
      };
      network = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable network collector";
      };
      pod = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable pod collector";
      };
      storeLabels = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Convert pod/container/image labels to labels on prometheus metrics";
      };
      system = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable system collector";
      };
      volume = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Enable volume collector";
      };
      whitelistedLabels = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Comma separated list of pod/container/image labels to be converted";
      };
    };

    debug = lib.mkOption {
      type = types.nullOr types.bool;
      default = null;
      description = "Set log level to debug";
    };

    web = {
      configFile = lib.mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to configuration file that can enable TLS or authentication";
      };
      disableExporterMetrics = lib.mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Exclude metrics about the exporter itself (promhttp_*, process_*, go_*)";
      };
      maxRequests = lib.mkOption {
        type = types.nullOr types.ints.unsigned;
        default = null;
        description = "Maximum number of parallel scrape requests. Use 0 to disable";
      };
      telemetryPath = lib.mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Path under which to expose metrics";
      };
    };
  };
  serviceOpts = {
    # NOTE: this is based on contrib/systemd/system/prometheus-podman-exporter.service
    # It was overwritten to pass the custom shellArgs and env variables
    serviceConfig = {
      DynamicUser = false;
      ExecStart = lib.escapeShellArgs ([ (lib.getExe cfg.package) ] ++ args);
      TimeoutStopSec = "20s";
      SendSIGKILL = false;
      Restart = "on-failure";
    };

    environment.CONTAINER_HOST = cfg.podmanSocket;

    path = [ config.virtualisation.podman.package.helpersBin ];

    after = lib.optional config.virtualisation.podman.enable "podman.service";
    wantedBy = [ "multi-user.target" ];
  };
}
