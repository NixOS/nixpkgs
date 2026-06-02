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
    mkPackageOption
    types
    ;

  inherit (utils) escapeSystemdExecArgs;

  cfg = config.services.prometheus.exporters.tailscale;
in
{
  port = 9250;
  extraOpts = with types; {
    package = mkPackageOption pkgs "prometheus-tailscale-exporter" { };
    environmentFile = mkOption {
      type = path;
      description = ''
        Environment file containg at least the TAILSCALE_TAILNET,
        TAILSCALE_OAUTH_CLIENT_ID, and TAILSCALE_OAUTH_CLIENT_SECRET
        environment variables.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      EnvironmentFile = cfg.environmentFile;
      ExecStart = escapeSystemdExecArgs (
        [
          (getExe cfg.package)
          "--listen-address"
          "${cfg.listenAddress}:${toString cfg.port}"
        ]
        ++ cfg.extraFlags
      );
    };
  };
}
