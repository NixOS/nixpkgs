{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.modemmanager;
in
{
  port = 9539;
  extraOpts = {
    refreshRate = mkOption {
      type = types.str;
      default = "5s";
      description = lib.mdDoc ''
        How frequently ModemManager will refresh the extended signal quality
        information for each modem. The duration should be specified in seconds
        ("5s"), minutes ("1m"), or hours ("1h").
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      # Required in order to authenticate with ModemManager via D-Bus.
      SupplementaryGroups = "networkmanager";
      ExecStart = ''
        ${pkgs.prometheus-modemmanager-exporter}/bin/modemmanager_exporter \
          -addr ${cfg.listenAddress}:${toString cfg.port} \
          -rate ${cfg.refreshRate} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
      RestrictAddressFamilies = [
        # Need AF_UNIX to collect data
        "AF_UNIX"
      ];
    };
  };
}
