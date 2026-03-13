{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.knot;
  inherit (lib)
    mkOption
    types
    literalExpression
    concatStringsSep
    ;
in
{
  port = 9433;
  extraOpts = {
    knotLibraryPath = mkOption {
      type = types.nullOr types.str;
      default = null;
      example = literalExpression ''"''${pkgs.knot-dns.out}/lib/libknot.so"'';
      description = ''
        Path to the library of `knot-dns`.
      '';
    };

    knotSocketPath = mkOption {
      type = types.str;
      default = "/run/knot/knot.sock";
      description = ''
        Socket path of {manpage}`knotd(8)`.
      '';
    };

    knotSocketTimeout = mkOption {
      type = types.ints.positive;
      default = 2000;
      description = ''
        Timeout in seconds.
      '';
    };
  };
  serviceOpts = {
    path = with pkgs; [
      procps
    ];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-knot-exporter}/bin/knot-exporter \
          --web-listen-addr ${cfg.listenAddress} \
          --web-listen-port ${toString cfg.port} \
          --knot-socket-path ${cfg.knotSocketPath} \
          --knot-socket-timeout ${toString cfg.knotSocketTimeout} \
          ${lib.optionalString (cfg.knotLibraryPath != null) "--knot-library-path ${cfg.knotLibraryPath}"} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      SupplementaryGroups = [
        "knot"
      ];
      RestrictAddressFamilies = [
        # Need AF_UNIX to collect data
        "AF_UNIX"
      ];
    };
  };
}
