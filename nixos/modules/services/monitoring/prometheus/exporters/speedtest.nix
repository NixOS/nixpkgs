{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.speedtest;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    optionalString
    ;
in
{
  port = 9798;

  extraOpts = {
    serverID = mkOption {
      type = types.int;
      default = -1;
      description = ''
        Speedtest.net server ID to run tests against.
        -1 picks the closest server to your location.
      '';
    };

    serverFallback = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If the configured serverID is unavailable, fall back to the closest available server.
      '';
    };

    timeout = mkOption {
      type = types.ints.positive;
      default = 60;
      description = ''
        Request timeout in seconds for the execution of the speedtest.
      '';
    };
  };

  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-speedtest-exporter}/bin/speedtest_exporter \
          -listen-address ${cfg.listenAddress} \
          -port ${toString cfg.port} \
          -server_id ${toString cfg.serverID} \
          -timeout ${toString cfg.timeout} \
          ${optionalString cfg.serverFallback "-server_fallback"} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
