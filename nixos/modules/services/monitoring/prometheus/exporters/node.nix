{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.node;
  inherit (lib)
    literalExpression
    mkOption
    types
    concatStringsSep
    concatMapStringsSep
    elem
    optionals
    ;
  collectorIsEnabled = final: elem final cfg.enabledCollectors;
  collectorIsDisabled = final: elem final cfg.disabledCollectors;
in
{
  port = 9100;
  extraOpts = {
    listenStream = mkOption {
      type = types.str;
      default = "${cfg.listenAddress}:${toString cfg.port}";
      defaultText = literalExpression ''"''${config.services.prometheus.exporters.node.listenAddress}:''${toString config.services.prometheus.exporters.node.port}"'';
      example = "/run/prometheus-node-exporter.sock";
      description = ''
        The value of `ListenStream=` in the exporter's socket unit.
        Accepts any value supported by systemd, e.g. an IPv4/IPv6 address
        with port, a Unix domain socket path (absolute), or an abstract
        namespace socket prefixed with `@`.
      '';
    };
    enabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "systemd" ];
      description = ''
        Collectors to enable. The collectors listed here are enabled in addition to the default ones.
      '';
    };
    disabledCollectors = mkOption {
      type = types.listOf types.str;
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
          ${concatMapStringsSep " " (x: "--collector." + x) cfg.enabledCollectors} \
          ${concatMapStringsSep " " (x: "--no-collector." + x) cfg.disabledCollectors} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} ${concatStringsSep " " cfg.extraFlags}
      '';
      RestrictAddressFamilies =
        optionals (collectorIsEnabled "logind" || collectorIsEnabled "systemd") [
          # needs access to dbus via unix sockets (logind/systemd)
          "AF_UNIX"
        ]
        ++
          optionals
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
