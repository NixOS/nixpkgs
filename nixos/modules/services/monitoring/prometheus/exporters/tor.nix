{ config, lib, pkgs }:

with lib;

let
  cfg = config.services.prometheus.exporters.tor;
in
{
  port = 9130;
  extraOpts = {
    torControlAddress = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description = ''
        Tor control IP address or hostname.
      '';
    };

    torControlPort = mkOption {
      type = types.int;
      default = 9051;
      description = ''
        Tor control port.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = true;
      ExecStart = ''
        ${pkgs.prometheus-tor-exporter}/bin/prometheus-tor-exporter \
          -b ${cfg.listenAddress} \
          -p ${toString cfg.port} \
          -a ${cfg.torControlAddress} \
          -c ${toString cfg.torControlPort} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
