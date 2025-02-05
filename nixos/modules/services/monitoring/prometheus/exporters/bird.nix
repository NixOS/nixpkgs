{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.bird;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    singleton
    ;
in
{
  port = 9324;
  extraOpts = {
    birdVersion = mkOption {
      type = types.enum [
        1
        2
      ];
      default = 2;
      description = ''
        Specifies whether BIRD1 or BIRD2 is in use.
      '';
    };
    birdSocket = mkOption {
      type = types.path;
      default = "/run/bird/bird.ctl";
      description = ''
        Path to BIRD2 (or BIRD1 v4) socket.
      '';
    };
    newMetricFormat = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Enable the new more-generic metric format.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      SupplementaryGroups = singleton (if cfg.birdVersion == 1 then "bird" else "bird2");
      ExecStart = ''
        ${pkgs.prometheus-bird-exporter}/bin/bird_exporter \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          -bird.socket ${cfg.birdSocket} \
          -bird.v2=${if cfg.birdVersion == 2 then "true" else "false"} \
          -format.new=${if cfg.newMetricFormat then "true" else "false"} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      RestrictAddressFamilies = [
        # Need AF_UNIX to collect data
        "AF_UNIX"
      ];
    };
  };
}
