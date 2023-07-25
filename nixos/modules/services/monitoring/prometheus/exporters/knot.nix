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
      description = lib.mdDoc ''
        Path to the library of `knot-dns`.
      '';
    };

    knotSocketPath = mkOption {
      type = types.str;
      default = "/run/knot/knot.sock";
      description = lib.mdDoc ''
        Socket path of {manpage}`knotd(8)`.
      '';
    };

    knotSocketTimeout = mkOption {
      type = types.int;
      default = 2000;
      description = lib.mdDoc ''
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
