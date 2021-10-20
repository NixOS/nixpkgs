{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.knot;
in {
  port = 9433;
  extraOpts = {
    knotLibraryPath = mkOption {
      type = types.str;
      default = "${pkgs.knot-dns.out}/lib/libknot.so";
      defaultText = literalExpression ''"''${pkgs.knot-dns.out}/lib/libknot.so"'';
      description = ''
        Path to the library of <package>knot-dns</package>.
      '';
    };

    knotSocketPath = mkOption {
      type = types.str;
      default = "/run/knot/knot.sock";
      description = ''
        Socket path of <citerefentry><refentrytitle>knotd</refentrytitle>
        <manvolnum>8</manvolnum></citerefentry>.
      '';
    };

    knotSocketTimeout = mkOption {
      type = types.int;
      default = 2000;
      description = ''
        Timeout in seconds.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-knot-exporter}/bin/knot_exporter \
          --web-listen-addr ${cfg.listenAddress} \
          --web-listen-port ${toString cfg.port} \
          --knot-library-path ${cfg.knotLibraryPath} \
          --knot-socket-path ${cfg.knotSocketPath} \
          --knot-socket-timeout ${toString cfg.knotSocketTimeout} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      SupplementaryGroups = [ "knot" ];
      RestrictAddressFamilies = [
        # Need AF_UNIX to collect data
        "AF_UNIX"
      ];
    };
  };
}
