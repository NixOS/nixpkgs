{
  config,
  lib,
  pkgs,
  utils,
  ...
}:

let
  inherit (lib)
    getExe
    mkOption
    optionals
    types
    ;

  inherit (utils) escapeSystemdExecArgs;

  cfg = config.services.prometheus.exporters.fastly;
in
{
  port = 9118;
  extraOpts = with types; {
    configFile = mkOption {
      type = nullOr path;
      default = null;
      example = "./fastly-exporter-config.txt";
      description = ''
        Path to a fastly-exporter configuration file.
        Example one can be generated with `fastly-exporter --config-file-example`.
      '';
    };

    environmentFile = mkOption {
      type = path;
      description = ''
        An environment file containg at least the FASTLY_API_TOKEN= environment
        variable.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      EnvironmentFile = cfg.environmentFile;
      ExecStart = escapeSystemdExecArgs (
        [
          (getExe pkgs.prometheus-fastly-exporter)
          "-listen"
          "${cfg.listenAddress}:${toString cfg.port}"
        ]
        ++ optionals (cfg.configFile != null) [
          "--config-file"
          cfg.configFile
        ]
        ++ cfg.extraFlags
      );
    };
  };
}
