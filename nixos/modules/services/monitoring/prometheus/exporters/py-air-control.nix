{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.py-air-control;

  py-air-control-exporter-env = pkgs.python3.withPackages (pyPkgs: [
      pyPkgs.py-air-control-exporter
  ]);

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
        Directory below <literal>/var/lib</literal> to store runtime data.
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
        ${py-air-control-exporter-env}/bin/python -c \
          "from py_air_control_exporter import app; app.create_app().run( \
              debug=False, \
              port=${toString cfg.port}, \
              host='${cfg.listenAddress}', \
          )"
      '';
      Environment = [
        "PY_AIR_CONTROL_HOST=${cfg.deviceHostname}"
        "PY_AIR_CONTROL_PROTOCOL=${cfg.protocol}"
        "HOME=${workingDir}"
      ];
    };
  };
}
