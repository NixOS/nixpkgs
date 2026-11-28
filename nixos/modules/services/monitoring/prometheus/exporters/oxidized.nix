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
    types
    ;

  inherit (utils) escapeSystemdExecArgs;

  cfg = config.services.prometheus.exporters.oxidized;
in
{
  port = 10112;
  extraOpts = with types; {
    url = mkOption {
      type = str;
      default = "http://localhost:8888";
      example = "https://oxidized.example.com";
      description = ''
        URL to the Oxidized application.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = escapeSystemdExecArgs (
        [
          (getExe pkgs.oxidized-exporter)
          "--listen"
          "${cfg.listenAddress}:${toString cfg.port}"
          "--url"
          cfg.url
        ]
        ++ cfg.extraFlags
      );
    };
  };
}
