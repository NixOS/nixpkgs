{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.node;
  collectorIsEnabled = final: lib.any (collector: (final == collector)) cfg.enabledCollectors;
  collectorIsDisabled = final: lib.any (collector: (final == collector)) cfg.disabledCollectors;
in
{
  port = 9100;
  extraOpts = {
    enabledCollectors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "systemd" ];
      description = ''
        Collectors to enable. The collectors listed here are enabled in addition to the default ones.
      '';
    };
    disabledCollectors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "timex" ];
      description = ''
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
          ${lib.concatMapStringsSep " " (x: "--collector." + x) cfg.enabledCollectors} \
          ${lib.concatMapStringsSep " " (x: "--no-collector." + x) cfg.disabledCollectors} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} ${lib.concatStringsSep " " cfg.extraFlags}
      '';
      RestrictAddressFamilies =
        lib.optionals (collectorIsEnabled "logind" || collectorIsEnabled "systemd") [
          # needs access to dbus via unix sockets (logind/systemd)
          "AF_UNIX"
        ]
        ++ lib.optionals
          (collectorIsEnabled "network_route" || collectorIsEnabled "wifi" || !collectorIsDisabled "netdev")
          [
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
