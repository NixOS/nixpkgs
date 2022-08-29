{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.wireguard;
in {
  port = 9586;
  imports = [
    (mkRenamedOptionModule [ "addr" ] [ "listenAddress" ])
    ({ options.warnings = options.warnings; options.assertions = options.assertions; })
  ];
  extraOpts = {
    verbose = mkEnableOption "Verbose logging mode for prometheus-wireguard-exporter";

    wireguardConfig = mkOption {
      type = with types; nullOr (either path str);
      default = null;

      description = lib.mdDoc ''
        Path to the Wireguard Config to
        [add the peer's name to the stats of a peer](https://github.com/MindFlavor/prometheus_wireguard_exporter/tree/2.0.0#usage).

        Please note that `networking.wg-quick` is required for this feature
        as `networking.wireguard` uses
        {manpage}`wg(8)`
        to set the peers up.
      '';
    };

    singleSubnetPerField = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        By default, all allowed IPs and subnets are comma-separated in the
        `allowed_ips` field. With this option enabled,
        a single IP and subnet will be listed in fields like `allowed_ip_0`,
        `allowed_ip_1` and so on.
      '';
    };

    withRemoteIp = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Whether or not the remote IP of a WireGuard peer should be exposed via prometheus.
      '';
    };
  };
  serviceOpts = {
    path = [ pkgs.wireguard-tools ];

    serviceConfig = {
      AmbientCapabilities = [ "CAP_NET_ADMIN" ];
      CapabilityBoundingSet = [ "CAP_NET_ADMIN" ];
      ExecStart = ''
        ${pkgs.prometheus-wireguard-exporter}/bin/prometheus_wireguard_exporter \
          -p ${toString cfg.port} \
          -l ${cfg.listenAddress} \
          ${optionalString cfg.verbose "-v true"} \
          ${optionalString cfg.singleSubnetPerField "-s true"} \
          ${optionalString cfg.withRemoteIp "-r true"} \
          ${optionalString (cfg.wireguardConfig != null) "-n ${escapeShellArg cfg.wireguardConfig}"}
      '';
      RestrictAddressFamilies = [
        # Need AF_NETLINK to collect data
        "AF_NETLINK"
      ];
    };
  };
}
