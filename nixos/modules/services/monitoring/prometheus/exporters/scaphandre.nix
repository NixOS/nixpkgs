{ config
, lib
, pkgs
, options
}:

let
  logPrefix = "services.prometheus.exporter.scaphandre";
  cfg = config.services.prometheus.exporters.scaphandre;
in {
  port = 8080;
  extraOpts = {
    telemetryPath = lib.mkOption {
      type = lib.types.str;
      default = "/metrics";
      description = lib.mdDoc ''
        Path under which to expose metrics.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.scaphandre}/bin/scaphandre prometheus \
          --address ${cfg.listenAddress} \
          --port ${toString cfg.port} \
          --suffix ${cfg.telemetryPath} \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
