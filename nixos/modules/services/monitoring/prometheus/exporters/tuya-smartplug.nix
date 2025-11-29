{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.tuya-smartplug;
in
{
  port = 9999;
  extraOpts = {
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to the tuya-smartplug configuration file.
      '';
      example = lib.literalExpression "./config.yml";
    };
    logLevel = lib.mkOption {
      type = lib.types.enum [
        "debug"
        "info"
        "warn"
        "error"
      ];
      default = "info";
      description = ''
        Detail level to log.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${lib.getExe pkgs.prometheus-tuya-smartplug-exporter} \
          --log.level=${cfg.logLevel} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --config.file="${lib.escapeShellArg cfg.configFile}"
      '';
    };
  };
}
