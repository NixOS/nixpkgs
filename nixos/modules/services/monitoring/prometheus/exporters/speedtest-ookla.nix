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
    makeBinPath
    mkOption
    optionalString
    types
    ;

  cfg = config.services.prometheus.exporters.speedtest-ookla;
in
{
  port = 9876;

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
        Refresh interval for the speedtest. It will cache the results for the given duration.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      StateDirectoryMode = "0750";
      StateDirectory = "prometheus-speedtest-ookla-exporter";
      WorkingDirectory = "/var/lib/prometheus-speedtest-ookla-exporter";

      Environment = [
        "PATH=${makeBinPath [ pkgs.ookla-speedtest ]}:$PATH"
        "HOME=/var/lib/prometheus-speedtest-ookla-exporter"
      ];

      ExecStart = concatStringsSep " " (
        [
          "${pkgs.prometheus-speedtest-ookla-exporter}/bin/speedtest-exporter"
          "--bind ${cfg.listenAddress}:${toString cfg.port}"
          "--refresh.interval ${cfg.refreshInterval}"
          (optionalString cfg.debug "--debug")
        ]
        ++ cfg.extraFlags
      );
    };
  };
}
