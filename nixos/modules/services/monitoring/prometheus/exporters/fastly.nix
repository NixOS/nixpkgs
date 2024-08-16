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

    tokenPath = mkOption {
      type = path;
      description = ''
        A run-time path to the token file, which is supposed to be provisioned
        outside of Nix store.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      LoadCredential = "fastly-api-token:${cfg.tokenPath}";
      Environment = [ "FASTLY_API_TOKEN=%d/fastly-api-token" ];
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
