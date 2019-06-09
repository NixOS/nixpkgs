{ config, lib, pkgs }:

with lib;

let
  cfg = config.services.prometheus.exporters.wireguard;
in {
  port = 9586;
  extraOpts = {
    verbose = mkEnableOption "Verbose logging mode for prometheus-wireguard-exporter";

    wireguardConfig = mkOption {
      type = with types; nullOr (either path str);
      default = null;

      description = ''
        Path to the Wireguard Config to
        <link xlink:href="https://github.com/MindFlavor/prometheus_wireguard_exporter/tree/2.0.0#usage">add the peer's name to the stats of a peer</link>.

        Please note that <literal>networking.wg-quick</literal> is required for this feature
        as <literal>networking.wireguard</literal> uses
        <citerefentry><refentrytitle>wg</refentrytitle><manvolnum>8</manvolnum></citerefentry>
        to set the peers up.
      '';
    };
  };
  serviceOpts = {
    script = ''
      ${pkgs.prometheus-wireguard-exporter}/bin/prometheus_wireguard_exporter \
        -p ${toString cfg.port} \
        ${optionalString cfg.verbose "-v"} \
        ${optionalString (cfg.wireguardConfig != null) "-n ${cfg.wireguardConfig}"}
    '';

    path = [ pkgs.wireguard-tools ];

    serviceConfig = {
      DynamicUser = true;
      AmbientCapabilities = [ "CAP_NET_ADMIN" ];
    };
  };
}
