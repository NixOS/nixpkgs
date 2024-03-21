{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.borgmatic;
in
{
  port = 9996;
  extraOpts.configFile = mkOption {
      type = types.path;
      default = "/etc/borgmatic/config.yaml";
      description = lib.mdDoc ''
        The path to the borgmatic config file
      '';
  };

  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      ProtectSystem = false;
      ProtectHome = lib.mkForce false;
      ExecStart = ''
        ${pkgs.prometheus-borgmatic-exporter}/bin/borgmatic-exporter run \
          --port ${toString cfg.port} \
          --config ${toString cfg.configFile} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
