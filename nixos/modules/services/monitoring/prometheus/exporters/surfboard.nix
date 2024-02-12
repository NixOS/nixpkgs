{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.surfboard;
in
{
  port = 9239;
  extraOpts = {
    modemAddress = mkOption {
      type = types.str;
      default = "192.168.100.1";
      description = lib.mdDoc ''
        The hostname or IP of the cable modem.
      '';
    };
  };
  serviceOpts = {
    description = "Prometheus exporter for surfboard cable modem";
    unitConfig.Documentation = "https://github.com/ipstatic/surfboard_exporter";
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-surfboard-exporter}/bin/surfboard_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --modem-address ${cfg.modemAddress} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
