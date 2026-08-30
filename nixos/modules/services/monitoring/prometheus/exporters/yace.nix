{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.yace;
  inherit (lib)
    mkIf
    mkOption
    types
    escapeShellArg
    concatStringsSep
    getExe
    ;
in
{
  port = 5000;
  extraOpts = {
    configFile = mkOption {
      type = types.path;
      description = ''
        Path to the YACE configuration file, defining which CloudWatch
        metrics to scrape. See
        <https://github.com/prometheus-community/yet-another-cloudwatch-exporter#configuration>
        for the format. AWS credentials are supplied separately via the
        environment (see {option}`environmentFile`, an IMDS instance role,
        or the usual `AWS_*` variables).
      '';
    };
    environmentFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      example = "/run/secrets/yace.env";
      description = ''
        Path to an environment file, as defined in {manpage}`systemd.exec(5)`,
        used to pass AWS credentials (e.g. `AWS_ACCESS_KEY_ID`,
        `AWS_SECRET_ACCESS_KEY`, `AWS_REGION`) to the exporter without exposing
        them in the world-readable Nix store. Not needed on EC2 with an IMDS
        instance role.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
      ExecStart = concatStringsSep " " (
        [
          (getExe pkgs.yet-another-cloudwatch-exporter)
          "--config.file ${escapeShellArg cfg.configFile}"
          "--listen-address ${cfg.listenAddress}:${toString cfg.port}"
        ]
        ++ cfg.extraFlags
      );
    };
  };
}
