{ config, lib, pkgs }:

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
      description = ''
        Path to a snmp exporter configuration file. Mutually exclusive with 'configuration' option.
      '';
      example = "./snmp.yml";
    };

    configuration = mkOption {
      type = types.nullOr types.attrs;
      default = {};
      description = ''
        Snmp exporter configuration as nix attribute set. Mutually exclusive with 'configurationPath' option.
      '';
      example = ''
        {
          "default" = {
            "version" = 2;
            "auth" = {
              "community" = "public";
            };
          };
        };
      '';
    };

    logFormat = mkOption {
      type = types.str;
      default = "logger:stderr";
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
    configFile = if cfg.configurationPath != null
                 then cfg.configurationPath
                 else "${pkgs.writeText "snmp-eporter-conf.yml" (builtins.toJSON cfg.configuration)}";
    in {
    serviceConfig = {
      DynamicUser = true;
      ExecStart = ''
        ${pkgs.prometheus-snmp-exporter.bin}/bin/snmp_exporter \
          -config.file ${configFile} \
          -log.format ${cfg.logFormat} \
          -log.level ${cfg.logLevel} \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
