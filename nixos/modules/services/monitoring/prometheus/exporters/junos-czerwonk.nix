{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.junos-czerwonk;

  configFile =
    if cfg.configuration != null then configurationFile else (lib.escapeShellArg cfg.configurationFile);

  configurationFile = pkgs.writeText "prometheus-junos-czerwonk-exporter.conf" (
    builtins.toJSON (cfg.configuration)
  );
in
{
  port = 9326;
  extraOpts = {
    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        File containing env-vars to be substituted into the exporter's config.
      '';
    };
    configurationFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Specify the JunOS exporter configuration file to use.
      '';
    };
    configuration = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      description = ''
        JunOS exporter configuration as nix attribute set. Mutually exclusive with the `configurationFile` option.
      '';
      example = {
        devices = [
          {
            host = "router1";
            key_file = "/path/to/key";
          }
        ];
      };
    };
    telemetryPath = lib.mkOption {
      type = lib.types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      EnvironmentFile = lib.mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
      RuntimeDirectory = "prometheus-junos-czerwonk-exporter";
      ExecStartPre = [
        "${pkgs.writeShellScript "subst-secrets-junos-czerwonk-exporter" ''
          umask 0077
          ${pkgs.envsubst}/bin/envsubst -i ${configFile} -o ''${RUNTIME_DIRECTORY}/junos-exporter.json
        ''}"
      ];
      ExecStart = ''
        ${pkgs.prometheus-junos-czerwonk-exporter}/bin/junos_exporter \
          -web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          -web.telemetry-path ${cfg.telemetryPath} \
          -config.file ''${RUNTIME_DIRECTORY}/junos-exporter.json \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
