{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.unifi;
in
{
  port = 9130;
  extraOpts = {
    unifiAddress = mkOption {
      type = types.str;
      example = "https://10.0.0.1:8443";
      description = lib.mdDoc ''
        URL of the UniFi Controller API.
      '';
    };

    unifiInsecure = mkOption {
      type = types.bool;
      default = false;
      description = lib.mdDoc ''
        If enabled skip the verification of the TLS certificate of the UniFi Controller API.
        Use with caution.
      '';
    };

    unifiUsername = mkOption {
      type = types.str;
      example = "ReadOnlyUser";
      description = lib.mdDoc ''
        username for authentication against UniFi Controller API.
      '';
    };

    unifiPassword = mkOption {
      type = types.str;
      description = lib.mdDoc ''
        Password for authentication against UniFi Controller API.
      '';
    };

    unifiTimeout = mkOption {
      type = types.str;
      default = "5s";
      example = "2m";
      description = lib.mdDoc ''
        Timeout including unit for UniFi Controller API requests.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-unifi-exporter}/bin/unifi_exporter \
          -telemetry.addr ${cfg.listenAddress}:${toString cfg.port} \
          -unifi.addr ${cfg.unifiAddress} \
          -unifi.username ${escapeShellArg cfg.unifiUsername} \
          -unifi.password ${escapeShellArg cfg.unifiPassword} \
          -unifi.timeout ${cfg.unifiTimeout} \
          ${optionalString cfg.unifiInsecure "-unifi.insecure" } \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
