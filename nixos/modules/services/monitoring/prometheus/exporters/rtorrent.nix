{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.rtorrent;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    optionalString
    ;
in
{
  port = 9135;
  extraOpts = {
    rtorrentAddr = mkOption {
      type = types.str;
      example = "http://localhost:8080";
      description = ''
        HTTP(S) URL of the rTorrent XML-RPC endpoint.
        rTorrent exposes SCGI natively, so this should point to a
        reverse proxy (e.g. nginx) that translates HTTP to SCGI.
      '';
    };
    trackersEnabled = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable tracker information collection.
      '';
    };
    insecure = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to skip TLS certificate verification when connecting to rTorrent.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-rtorrent-exporter}/bin/rtorrent-exporter \
          --rtorrent.addr ${cfg.rtorrentAddr} \
          --telemetry.addr ${cfg.listenAddress}:${toString cfg.port} \
          ${optionalString cfg.trackersEnabled "--rtorrent.trackers.enabled"} \
          ${optionalString cfg.insecure "--rtorrent.insecure"} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
