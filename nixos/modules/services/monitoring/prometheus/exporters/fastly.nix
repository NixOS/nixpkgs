{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  inherit (lib)
    escapeShellArgs
    mkOption
    optionals
    types
    ;

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
    };
    script =
      let
        call = escapeShellArgs (
          [
            "${pkgs.prometheus-fastly-exporter}/bin/fastly-exporter"
            "-listen"
            "${cfg.listenAddress}:${toString cfg.port}"
          ]
          ++ optionals (cfg.configFile != null) [
            "--config-file"
            cfg.configFile
          ]
          ++ cfg.extraFlags
        );
      in
      ''
        export FASTLY_API_TOKEN="$(cat $CREDENTIALS_DIRECTORY/fastly-api-token)"
        ${call}
      '';
  };
}
