{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.node;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    concatMapStringsSep
    any
    optionals
    ;
  collectorIsEnabled = final: any (collector: (final == collector)) cfg.enabledCollectors;
  collectorIsDisabled = final: any (collector: (final == collector)) cfg.disabledCollectors;
in
{
  port = 9100;
  extraOpts = {
    enabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "systemd" ];
      description = ''
        Collectors to enable. The collectors listed here are enabled in addition to the default ones.
      '';
    };
    disabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "timex" ];
      description = ''
        Collectors to disable which are enabled by default.
      '';
    };
    textfileDir = mkOption {
      type = types.path;
      default = "/var/lib/prometheus-node-exporter/textfile";
      description = lib.mdDoc ''
        Path that the textfile collector will read from, if it is not disabled.
        This directory will _not_ automatically be created.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      RuntimeDirectory = "prometheus-node-exporter";
      ExecStart = lib.concatStringsSep " \\\n  " (
        [ "${pkgs.prometheus-node-exporter}/bin/node_exporter"
          "--web.listen-address ${cfg.listenAddress}:${toString cfg.port}" ]
        ++ (map (x: "--collector."    + x) cfg.enabledCollectors)
        ++ (map (x: "--no-collector." + x) cfg.disabledCollectors)
        ++ cfg.extraFlags
        # textfile is enabled by default, so we only check if it is explicitly disabled
        ++ (optional (!collectorIsDisabled "textfile")
              "--collector.textfile.directory ${cfg.textfileDir}")
      );
      RestrictAddressFamilies = optionals (collectorIsEnabled "logind" || collectorIsEnabled "systemd") [
        # needs access to dbus via unix sockets (logind/systemd)
        "AF_UNIX"
      ] ++ optionals (collectorIsEnabled "network_route" || collectorIsEnabled "wifi" || ! collectorIsDisabled "netdev") [
        # needs netlink sockets for wireless collector
        "AF_NETLINK"
      ];
      # The timex collector needs to access clock APIs
      ProtectClock = collectorIsDisabled "timex";
      # Allow space monitoring under /home
      ProtectHome = true;
    };
  };
}
