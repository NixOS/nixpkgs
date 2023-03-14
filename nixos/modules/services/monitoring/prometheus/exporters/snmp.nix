{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.snmp;
in
{
  port = 9116;
  extraOpts = {
    configurationPath = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Path to a snmp exporter configuration file. Mutually exclusive with 'configuration' option.
      '';
      example = literalExpression "./snmp.yml";
    };

    configuration = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = lib.mdDoc ''
        Snmp exporter configuration as nix attribute set. Mutually exclusive with 'configurationPath' option.
      '';
      example = {
        "default" = {
          "version" = 2;
          "auth" = {
            "community" = "public";
          };
        };
      };
    };

    logFormat = mkOption {
      type = types.enum ["logfmt" "json"];
      default = "logfmt";
      description = lib.mdDoc ''
        Output format of log messages.
      '';
    };

    logLevel = mkOption {
      type = types.enum ["debug" "info" "warn" "error"];
      default = "info";
      description = lib.mdDoc ''
        Only log messages with the given severity or above.
      '';
    };
  };
  serviceOpts = let
    configFile = if cfg.configurationPath != null
                 then cfg.configurationPath
                 else "${pkgs.writeText "snmp-exporter-conf.yml" (builtins.toJSON cfg.configuration)}";
    in {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-snmp-exporter}/bin/snmp_exporter \
          --config.file=${escapeShellArg configFile} \
          --log.format=${escapeShellArg cfg.logFormat} \
          --log.level=${cfg.logLevel} \
          --web.listen-address=${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
