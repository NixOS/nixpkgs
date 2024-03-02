{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.mongodb;
in
{
  port = 9216;
  extraOpts = {
    uri = mkOption {
      type = types.str;
      default = "mongodb://localhost:27017/test";
      example = "mongodb://localhost:27017/test";
      description = lib.mdDoc "MongoDB URI to connect to.";
    };
    collStats = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "db1.coll1" "db2" ];
      description = lib.mdDoc ''
        List of comma separared databases.collections to get $collStats
      '';
    };
    indexStats = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "db1.coll1" "db2" ];
      description = lib.mdDoc ''
        List of comma separared databases.collections to get $indexStats
      '';
    };
    collector = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "diagnosticdata" "replicasetstatus" "dbstats" "topmetrics" "currentopmetrics" "indexstats" "dbstats" "profile" ];
      description = lib.mdDoc "Enabled collectors";
    };
    collectAll = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        Enable all collectors. Same as specifying all --collector.<name>
      '';
    };
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      example = "/metrics";
      description = lib.mdDoc "Metrics expose path";
    };
  };
  serviceOpts = {
    serviceConfig = {
      RuntimeDirectory = "prometheus-mongodb-exporter";
      ExecStart = ''
        ${getExe pkgs.prometheus-mongodb-exporter} \
          --mongodb.uri="${cfg.uri}" \
          ${if cfg.collectAll then "--collect-all" else concatMapStringsSep " " (x: "--collect.${x}") cfg.collector} \
          ${optionalString (length cfg.collStats > 0) "--mongodb.collstats-colls=${concatStringsSep "," cfg.collStats}"} \
          ${optionalString (length cfg.indexStats > 0) "--mongodb.indexstats-colls=${concatStringsSep "," cfg.indexStats}"} \
          --web.listen-address="${cfg.listenAddress}:${toString cfg.port}" \
          --web.telemetry-path="${cfg.telemetryPath}" \
          ${escapeShellArgs cfg.extraFlags}
      '';
    };
  };
}
