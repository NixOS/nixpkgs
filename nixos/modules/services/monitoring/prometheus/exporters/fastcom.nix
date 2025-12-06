{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    concatStringsSep
    mkOption
    optionalString
    types
    ;

  cfg = config.services.prometheus.exporters.fastcom;
in
{
  port = 9877;

  extraOpts = with types; {
    debug = mkOption {
      type = bool;
      default = false;
      description = ''
        Print debug information.
      '';
    };

    refreshInterval = mkOption {
      type = str;
      default = "30m";
      example = "1h";
      description = ''
        Refresh interval for the Fast.com speedtest. It will cache the results for the given duration.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      ExecStart = concatStringsSep " " (
        [
          "${pkgs.prometheus-fastcom-exporter}/bin/fastcom-exporter"
          "--bind ${cfg.listenAddress}:${toString cfg.port}"
          "--refresh.interval ${cfg.refreshInterval}"
          (optionalString cfg.debug "--debug")
        ]
        ++ cfg.extraFlags
      );
    };
  };
}
