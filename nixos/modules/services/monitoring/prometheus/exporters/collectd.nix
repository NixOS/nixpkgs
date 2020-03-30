{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.collectd;
in
{
  port = 9103;
  extraOpts = {
    collectdBinary = {
      enable = mkEnableOption "collectd binary protocol receiver";

      authFile = mkOption {
        default = null;
        type = types.nullOr types.path;
        description = "File mapping user names to pre-shared keys (passwords).";
      };

      port = mkOption {
        type = types.int;
        default = 25826;
        description = ''Network address on which to accept collectd binary network packets.'';
      };

      listenAddress = mkOption {
        type = types.str;
        default = "0.0.0.0";
        description = ''
          Address to listen on for binary network packets.
          '';
      };

      securityLevel = mkOption {
        type = types.enum ["None" "Sign" "Encrypt"];
        default = "None";
        description = ''
          Minimum required security level for accepted packets.
        '';
      };
    };

    logFormat = mkOption {
      type = types.str;
      default = "logger:stderr";
      example = "logger:syslog?appname=bob&local=7 or logger:stdout?json=true";
      description = ''
        Set the log target and format.
      '';
    };

    logLevel = mkOption {
      type = types.enum ["debug" "info" "warn" "error" "fatal"];
      default = "info";
      description = ''
        Only log messages with the given severity or above.
      '';
    };
  };
  serviceOpts = let
    collectSettingsArgs = if (cfg.collectdBinary.enable) then ''
      -collectd.listen-address ${cfg.collectdBinary.listenAddress}:${toString cfg.collectdBinary.port} \
      -collectd.security-level ${cfg.collectdBinary.securityLevel} \
    '' else "";
  in {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-collectd-exporter}/bin/collectd_exporter \
          -log.format ${escapeShellArg cfg.logFormat} \
          -log.level ${cfg.logLevel} \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${collectSettingsArgs} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
