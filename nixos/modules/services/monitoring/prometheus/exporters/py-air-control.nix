{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.py-air-control;
  inherit (lib) mkOption types;

  workingDir = "/var/lib/${cfg.stateDir}";

in
{
  port = 9896;
  extraOpts = {
    deviceHostname = mkOption {
      type = types.str;
      example = "192.168.1.123";
      description = ''
        The hostname of the air purification device from which to scrape the metrics.
      '';
    };
    protocol = mkOption {
      type = types.str;
      default = "http";
      description = ''
        The protocol to use when communicating with the air purification device.
        Available: [http, coap, plain_coap]
      '';
    };
    stateDir = mkOption {
      type = types.str;
      default = "prometheus-py-air-control-exporter";
      description = ''
        Directory below `/var/lib` to store runtime data.
        This directory will be created automatically using systemd's StateDirectory mechanism.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      StateDirectory = cfg.stateDir;
      WorkingDirectory = workingDir;
      ExecStart = ''
        ${pkgs.python3Packages.py-air-control-exporter}/bin/py-air-control-exporter \
          --host ${cfg.deviceHostname} \
          --protocol ${cfg.protocol} \
          --listen-port ${toString cfg.port} \
          --listen-address ${cfg.listenAddress}
      '';
      Environment = [ "HOME=${workingDir}" ];
    };
  };
}
