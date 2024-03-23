{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.collectd;
in
{
  port = 9103;
  extraOpts = {
    collectdBinary = {
      enable = mkEnableOption (lib.mdDoc "collectd binary protocol receiver");

      authFile = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = lib.mdDoc "File mapping user names to pre-shared keys (passwords).";
      };

      port = mkOption {
        type = types.port;
        default = 25826;
        description = lib.mdDoc "Network address on which to accept collectd binary network packets.";
      };

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = lib.mdDoc ''
          Address to listen on for binary network packets.
          '';
      };

      securityLevel = mkOption {
        type = types.enum ["None" "Sign" "Encrypt"];
        default = "None";
        description = lib.mdDoc ''
          Minimum required security level for accepted packets.
        '';
      };
    };

    logFormat = mkOption {
      type = types.enum [ "logfmt" "json" ];
      default = "logfmt";
      example = "json";
      description = lib.mdDoc ''
        Set the log format.
      '';
    };

    logLevel = mkOption {
      type = types.enum ["debug" "info" "warn" "error" "fatal"];
      default = "info";
      description = lib.mdDoc ''
        Only log messages with the given severity or above.
      '';
    };
  };
  serviceOpts = let
    collectSettingsArgs = optionalString (cfg.collectdBinary.enable) ''
      --collectd.listen-address ${cfg.collectdBinary.listenAddress}:${toString cfg.collectdBinary.port} \
      --collectd.security-level ${cfg.collectdBinary.securityLevel} \
    '';
  in {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-collectd-exporter}/bin/collectd_exporter \
          --log.format ${escapeShellArg cfg.logFormat} \
          --log.level ${cfg.logLevel} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${collectSettingsArgs} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
