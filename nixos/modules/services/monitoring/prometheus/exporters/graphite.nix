{ config, lib, pkgs, options }:

let
  cfg = config.services.prometheus.exporters.graphite;
  format = pkgs.formats.yaml { };
in
{
  port = 9108;
  extraOpts = {
    graphitePort = lib.mkOption {
      type = lib.types.port;
      default = 9109;
      description = lib.mdDoc ''
        Port to use for the graphite server.
      '';
    };
    mappingSettings = lib.mkOption {
      type = lib.types.submodule {
        freeformType = format.type;
        options = { };
      };
      default = { };
      description = lib.mdDoc ''
        Mapping configuration for the exporter, see
        <https://github.com/prometheus/graphite_exporter#yaml-config> for
        available options.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-graphite-exporter}/bin/graphite_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --graphite.listen-address ${cfg.listenAddress}:${toString cfg.graphitePort} \
          --graphite.mapping-config ${format.generate "mapping.yml" cfg.mappingSettings} \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
