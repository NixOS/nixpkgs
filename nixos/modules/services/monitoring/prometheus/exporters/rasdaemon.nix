{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    getExe
    mkOption
    types
    ;

  inherit (utils) escapeSystemdExecArgs;

  cfg = config.services.prometheus.exporters.rasdaemon;
in
{
  port = 10029;
  extraOpts = with types; {
    databasePath = mkOption {
      type = path;
      default = "/var/lib/rasdaemon/ras-mc_event.db";
      description = ''
        Path to the RAS daemon machine check event database.
      '';
    };

    enabledCollectors = mkOption {
      type = listOf (enum [
        "aer"
        "mce"
        "mc"
        "extlog"
        "devlink"
        "disk"
      ]);
      default = [
        "aer"
        "mce"
        "mc"
      ];
      description = ''
        List of error types to collect from the event database.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = escapeSystemdExecArgs (
        [
          (getExe pkgs.prometheus-rasdaemon-exporter)
          "--address"
          cfg.listenAddress
          "--port"
          (toString cfg.port)
          "--db"
          cfg.databasePath
        ]
        ++ map (collector: "--collector-${collector}") cfg.enabledCollectors
        ++ cfg.extraFlags
      );
    };
  };
}
