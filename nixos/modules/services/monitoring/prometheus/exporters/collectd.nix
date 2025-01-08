{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.collectd;
  inherit (lib)
    lib.mkOption
    mkEnableOption
    types
    lib.optionalString
    concatStringsSep
    escapeShellArg
    ;
in
{
  port = 9103;
  extraOpts = {
    collectdBinary = {
      enable = lib.mkEnableOption "collectd binary protocol receiver";

      authFile = lib.mkOption {
        default = null;
        type = lib.types.nullOr lib.types.path;
        description = "File mapping user names to pre-shared keys (passwords).";
      };

      port = lib.mkOption {
        type = lib.types.port;
        default = 25826;
        description = "Network address on which to accept collectd binary network packets.";
      };

      listenAddress = lib.mkOption {
        type = lib.types.str;
        default = "0.0.0.0";
        description = ''
          Address to listen on for binary network packets.
        '';
      };

      securityLevel = lib.mkOption {
        type = lib.types.enum [
          "None"
          "Sign"
          "Encrypt"
        ];
        default = "None";
        description = ''
          Minimum required security level for accepted packets.
        '';
      };
    };

    logFormat = lib.mkOption {
      type = lib.types.enum [
        "logfmt"
        "json"
      ];
      default = "logfmt";
      example = "json";
      description = ''
        Set the log format.
      '';
    };

    logLevel = lib.mkOption {
      type = lib.types.enum [
        "debug"
        "info"
        "warn"
        "error"
        "fatal"
      ];
      default = "info";
      description = ''
        Only log messages with the given severity or above.
      '';
    };
  };
  serviceOpts =
    let
      collectSettingsArgs = lib.optionalString (cfg.collectdBinary.enable) ''
        --collectd.listen-address ${cfg.collectdBinary.listenAddress}:${toString cfg.collectdBinary.port} \
        --collectd.security-level ${cfg.collectdBinary.securityLevel} \
      '';
    in
    {
      serviceConfig = {
        ExecStart = ''
          ${pkgs.prometheus-collectd-exporter}/bin/collectd_exporter \
            --log.format ${lib.escapeShellArg cfg.logFormat} \
            --log.level ${cfg.logLevel} \
            --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
            ${collectSettingsArgs} \
            ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
        '';
      };
    };
}
