{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.frr;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    concatMapStringsSep
    any
    optionals
    ;
  collectorIsEnabled = final: any (collector: (final == collector)) cfg.enabledCollectors;
  collectorIsDisabled = final: any (collector: (final == collector)) cfg.disabledCollectors;
in
{
  port = 9342;
  extraOpts = {
    enabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "vrrp" ];
      description = ''
        Collectors to enable. The collectors listed here are enabled in addition to the default ones.
      '';
    };
    disabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "bfd" ];
      description = ''
        Collectors to disable which are enabled by default.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      RuntimeDirectory = "prometheus-frr-exporter";
      ExecStart = ''
        ${pkgs.prometheus-frr-exporter}/bin/frr_exporter \
          ${concatMapStringsSep " " (x: "--collector." + x) cfg.enabledCollectors} \
          ${concatMapStringsSep " " (x: "--no-collector." + x) cfg.disabledCollectors} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} ${concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
