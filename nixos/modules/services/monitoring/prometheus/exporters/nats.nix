{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.nats;
  inherit (lib) mkOption types concatStringsSep;
in
{
  port = 7777;

  extraOpts = {
    url = mkOption {
      type = types.str;
      default = "http://127.0.0.1:8222";
      description = ''
        NATS monitor endpoint to query.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-nats-exporter}/bin/prometheus-nats-exporter \
          -addr ${cfg.listenAddress} \
          -port ${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags} \
          ${cfg.url}
      '';
    };
  };
}
