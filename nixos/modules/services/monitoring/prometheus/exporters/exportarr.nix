{ config, lib, pkgs, options, type, ... }:

let
  cfg = config.services.prometheus.exporters."exportarr-${type}";
  exportarrEnvironment = (
    lib.mapAttrs (_: toString) cfg.environment
  ) // {
    PORT = toString cfg.port;
    URL = cfg.url;
    API_KEY_FILE = lib.mkIf (cfg.apiKeyFile != null) "%d/api-key";
  };
in
{
  port = 9708;
  extraOpts = {
    url = lib.mkOption {
      type = lib.types.str;
      default = "http://127.0.0.1";
      description = lib.mdDoc ''
        The full URL to Sonarr, Radarr, or Lidarr.
      '';
    };

    apiKeyFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = lib.mdDoc ''
        File containing the api-key.
      '';
    };

    package = lib.mkPackageOption pkgs "exportarr" { };

    environment = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = lib.mdDoc ''
        See [the configuration guide](https://github.com/onedr0p/exportarr#configuration) for available options.
      '';
      example = {
        PROWLARR__BACKFILL = true;
      };
    };
  };
  serviceOpts = {
    serviceConfig = {
      LoadCredential = lib.optionalString (cfg.apiKeyFile != null) "api-key:${cfg.apiKeyFile}";
      ExecStart = ''${cfg.package}/bin/exportarr ${type} "$@"'';
      ProcSubset = "pid";
      ProtectProc = "invisible";
      SystemCallFilter = ["@system-service" "~@privileged"];
    };
    environment = exportarrEnvironment;
  };
}
