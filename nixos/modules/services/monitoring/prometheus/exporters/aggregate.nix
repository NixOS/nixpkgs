{
  config,
  lib,
  pkgs,
  options,
}:
with lib; let
  cfg = config.services.prometheus.exporters.aggregate;

  enabledExporters = lib.filterAttrs (name: value: value.enable) (lib.filterAttrs (name: value: name != "aggregate" && name != "assertions" && name != "warnings") config.services.prometheus.exporters);
in {
  port = 9999;
  extraOpts = {
    enableLocalExporters = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Enables aggregation for all locally enabled exporters
      '';
    };
    exporters = mkOption {
      type = types.listOf types.str;
      default = [];
      example = ["http://localhost:8080/metrics"];
      description = lib.mdDoc ''
        Addresses of additional exporters to be aggregated.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = let
        aggregates = lib.concatStringsSep "," ((lib.attrValues (lib.mapAttrs (name: value: "${name}=http://localhost:${builtins.toString value.port}/metrics") enabledExporters)) ++ cfg.exporters);
      in ''
        ${pkgs.prometheus-aggregate-exporter}/bin/aggregate_exporter \
          -targets "${aggregates}" \
          -server.bind ${cfg.listenAddress}:${toString cfg.port} ${concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
