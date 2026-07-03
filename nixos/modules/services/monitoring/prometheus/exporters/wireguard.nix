{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.wireguard;
  inherit (lib)
    mkOption
    types
    mkRenamedOptionModule
    mkEnableOption
    optionalString
    escapeShellArg
    concatStringsSep
    concatMapStringsSep
    ;
in
{
  port = 9586;
  imports = [
    (mkRenamedOptionModule [ "addr" ] [ "listenAddress" ])
    {
      options.warnings = options.warnings;
      options.assertions = options.assertions;
    }
  ];
  extraOpts = {
    verbose = mkEnableOption "verbose logging mode for prometheus-wireguard-exporter";

    wireguardConfig = mkOption {
      type = with types; nullOr (either path str);
      default = null;

      description = ''
        Path to the Wireguard Config to
        [add the peer's name to the stats of a peer](https://github.com/MindFlavor/prometheus_wireguard_exporter/tree/2.0.0#usage).

        Please note that `networking.wg-quick` is required for this feature
        as `networking.wireguard` uses
        {manpage}`wg(8)`
        to set the peers up.
      '';
    };

    interfaces = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = ''
        Specifies the interface(s) passed to the wg show <interface> dump parameter.
        By default all interfaces are used.
      '';
    };

    singleSubnetPerField = mkOption {
      type = types.bool;
      default = false;
      description = ''
        By default, all allowed IPs and subnets are comma-separated in the
        `allowed_ips` field. With this option enabled,
        a single IP and subnet will be listed in fields like `allowed_ip_0`,
        `allowed_ip_1` and so on.
      '';
    };

    withRemoteIp = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether or not the remote IP of a WireGuard peer should be exposed via prometheus.
      '';
    };

    latestHandshakeDelay = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Adds the `wireguard_latest_handshake_delay_seconds` metric that automatically calculates the seconds passed since the last handshake.
      '';
    };

    prependSudo = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether or no to prepend sudo to wg commands.
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
          ${optionalString cfg.latestHandshakeDelay "-d true"} \
          ${optionalString cfg.prependSudo "-a true"} \
          ${optionalString (cfg.wireguardConfig != null) "-n ${escapeShellArg cfg.wireguardConfig}"} \
          ${concatMapStringsSep " " (i: "-i ${i}") cfg.interfaces} \
          ${concatStringsSep " " cfg.extraFlags}
      '';
      RestrictAddressFamilies = [
        # Need AF_NETLINK to collect data
        "AF_NETLINK"
      ];
    };
  };
}
