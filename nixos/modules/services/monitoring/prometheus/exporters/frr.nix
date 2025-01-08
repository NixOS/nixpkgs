{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.frr;
  inherit (lib)
    lib.mkOption
    types
    concatStringsSep
    concatMapStringsSep
    ;
in
{
  port = 9342;
  extraOpts = {
    enabledCollectors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "vrrp" ];
      description = ''
        Collectors to enable. The collectors listed here are enabled in addition to the default ones.
      '';
    };
    disabledCollectors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
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
        ${lib.getExe pkgs.prometheus-frr-exporter} \
          ${concatMapStringsSep " " (x: "--collector." + x) cfg.enabledCollectors} \
          ${concatMapStringsSep " " (x: "--no-collector." + x) cfg.disabledCollectors} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} ${lib.concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
