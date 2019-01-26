{ config, lib, pkgs }:

with lib;

let
  cfg = config.services.prometheus.exporters.blackbox;
in
{
  port = 9115;
  extraOpts = {
    configFile = mkOption {
      type = types.path;
      description = ''
        Path to configuration file.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      AmbientCapabilities = [ "CAP_NET_RAW" ]; # for ping probes
      DynamicUser = true;
      ExecStart = ''
        ${pkgs.prometheus-blackbox-exporter}/bin/blackbox_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --config.file ${cfg.configFile} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      ExecReload = "${pkgs.coreutils}/bin/kill -HUP $MAINPID";
    };
  };
}
