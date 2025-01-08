{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.mongodb;
in
{
  port = 9216;
  extraOpts = {
    uri = lib.mkOption {
      type = lib.types.str;
      default = "mongodb://localhost:27017/test";
      example = "mongodb://localhost:27017/test";
      description = "MongoDB URI to connect to.";
    };
    collStats = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "db1.coll1"
        "db2"
      ];
      description = ''
        List of comma separared databases.collections to get $collStats
      '';
    };
    indexStats = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "db1.coll1"
        "db2"
      ];
      description = ''
        List of comma separared databases.collections to get $indexStats
      '';
    };
    collector = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [
        "diagnosticdata"
        "replicasetstatus"
        "dbstats"
        "topmetrics"
        "currentopmetrics"
        "indexstats"
        "dbstats"
        "profile"
      ];
      description = "Enabled collectors";
    };
    collectAll = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Enable all collectors. Same as specifying all --collector.<name>
      '';
    };
    telemetryPath = lib.mkOption {
      type = lib.types.str;
      default = "/metrics";
      example = "/metrics";
      description = "Metrics expose path";
    };
  };
  serviceOpts = {
    serviceConfig = {
      RuntimeDirectory = "prometheus-mongodb-exporter";
      ExecStart = ''
        ${lib.getExe pkgs.prometheus-mongodb-exporter} \
          --mongodb.uri="${cfg.uri}" \
          ${
            if cfg.collectAll then
              "--collect-all"
            else
              lib.concatMapStringsSep " " (x: "--collect.${x}") cfg.collector
          } \
          ${
            lib.optionalString (
              lib.length cfg.collStats > 0
            ) "--mongodb.collstats-colls=${lib.concatStringsSep "," cfg.collStats}"
          } \
          ${
            lib.optionalString (
              lib.length cfg.indexStats > 0
            ) "--mongodb.indexstats-colls=${lib.concatStringsSep "," cfg.indexStats}"
          } \
          --web.listen-address="${cfg.listenAddress}:${toString cfg.port}" \
          --web.telemetry-path="${cfg.telemetryPath}" \
          ${lib.escapeShellArgs cfg.extraFlags}
      '';
    };
  };
}
