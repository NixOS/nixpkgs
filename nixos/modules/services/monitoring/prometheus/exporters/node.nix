{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.node;
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
      description = lib.mdDoc ''
        Collectors to enable. The collectors listed here are enabled in addition to the default ones.
      '';
    };
    disabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "timex" ];
      description = lib.mdDoc ''
        Collectors to disable which are enabled by default.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      RuntimeDirectory = "prometheus-node-exporter";
      ExecStart = ''
        ${pkgs.prometheus-node-exporter}/bin/node_exporter \
          ${concatMapStringsSep " " (x: "--collector." + x) cfg.enabledCollectors} \
          ${concatMapStringsSep " " (x: "--no-collector." + x) cfg.disabledCollectors} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} ${concatStringsSep " " cfg.extraFlags}
      '';
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
