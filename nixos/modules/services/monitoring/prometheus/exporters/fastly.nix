{ config, lib, pkgs, options }:

with lib;

let cfg = config.services.prometheus.exporters.fastly;
in
{
  port = 9118;
  extraOpts = {
    debug = mkEnableOption "Debug logging mode for fastly-exporter";

    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Path to a fastly-exporter configuration file.
        Example one can be generated with <literal>fastly-exporter --config-file-example</literal>.
      '';
      example = "./fastly-exporter-config.txt";
    };

    tokenPath = mkOption {
      type = types.nullOr types.path;
      apply = final: if final == null then null else toString final;
      description = ''
        A run-time path to the token file, which is supposed to be provisioned
        outside of Nix store.
      '';
    };
  };
  serviceOpts = {
    script = ''
      ${optionalString (cfg.tokenPath != null)
      "export FASTLY_API_TOKEN=$(cat ${toString cfg.tokenPath})"}
      ${pkgs.fastly-exporter}/bin/fastly-exporter \
        -endpoint http://${cfg.listenAddress}:${cfg.port}/metrics
        ${optionalString cfg.debug "-debug true"} \
        ${optionalString cfg.configFile "-config-file ${cfg.configFile}"}
    '';
  };
}
