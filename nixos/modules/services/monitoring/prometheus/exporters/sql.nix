{ config, lib, pkgs, options, ... }:
with lib;
let
  cfg = config.services.prometheus.exporters.sql;
  cfgOptions = {
    options = with types; {
      jobs = mkOption {
        type = attrsOf (submodule jobOptions);
        default = { };
        description = lib.mdDoc "An attrset of metrics scraping jobs to run.";
      };
    };
  };
  jobOptions = {
    options = with types; {
      interval = mkOption {
        type = str;
        description = lib.mdDoc ''
          How often to run this job, specified in
          [Go duration](https://golang.org/pkg/time/#ParseDuration) format.
        '';
      };
      connections = mkOption {
        type = listOf str;
        description = lib.mdDoc "A list of connection strings of the SQL servers to scrape metrics from";
      };
      startupSql = mkOption {
        type = listOf str;
        default = [];
        description = lib.mdDoc "A list of SQL statements to execute once after making a connection.";
      };
      queries = mkOption {
        type = attrsOf (submodule queryOptions);
        description = lib.mdDoc "SQL queries to run.";
      };
    };
  };
  queryOptions = {
    options = with types; {
      help = mkOption {
        type = nullOr str;
        default = null;
        description = lib.mdDoc "A human-readable description of this metric.";
      };
      labels = mkOption {
        type = listOf str;
        default = [ ];
        description = lib.mdDoc "A set of columns that will be used as Prometheus labels.";
      };
      query = mkOption {
        type = str;
        description = lib.mdDoc "The SQL query to run.";
      };
      values = mkOption {
        type = listOf str;
        description = lib.mdDoc "A set of columns that will be used as values of this metric.";
      };
    };
  };

  configFile =
    if cfg.configFile != null
    then cfg.configFile
    else
      let
        nameInline = mapAttrsToList (k: v: v // { name = k; });
        renameStartupSql = j: removeAttrs (j // { startup_sql = j.startupSql; }) [ "startupSql" ];
        configuration = {
          jobs = map renameStartupSql
            (nameInline (mapAttrs (k: v: (v // { queries = nameInline v.queries; })) cfg.configuration.jobs));
        };
      in
      builtins.toFile "config.yaml" (builtins.toJSON configuration);
in
{
  extraOpts = {
    configFile = mkOption {
      type = with types; nullOr path;
      default = null;
      description = lib.mdDoc ''
        Path to configuration file.
      '';
    };
    configuration = mkOption {
      type = with types; nullOr (submodule cfgOptions);
      default = null;
      description = lib.mdDoc ''
        Exporter configuration as nix attribute set. Mutually exclusive with 'configFile' option.
      '';
    };
  };

  port = 9237;
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-sql-exporter}/bin/sql_exporter \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          -config.file ${configFile} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      RestrictAddressFamilies = [
        # Need AF_UNIX to collect data
        "AF_UNIX"
      ];
    };
  };
}
