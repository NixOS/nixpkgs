{ config, lib, pkgs, options, ... }:

let
  cfg = config.services.prometheus.exporters.junos-czerwonk;
  inherit (lib)
    mkOption
    types
    escapeShellArg
    mkIf
    concatStringsSep
    ;

  configFile = if cfg.configuration != null then configurationFile else (escapeShellArg cfg.configurationFile);

  configurationFile = pkgs.writeText "prometheus-junos-czerwonk-exporter.conf" (builtins.toJSON (cfg.configuration));
in
{
  port = 9326;
  extraOpts = {
    environmentFile = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        File containing env-vars to be substituted into the exporter's config.
      '';
    };
    configurationFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = ''
        Specify the JunOS exporter configuration file to use.
      '';
    };
    configuration = mkOption {
      type = types.nullOr types.attrs;
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
    telemetryPath = mkOption {
      type = types.str;
      default = "/metrics";
      description = ''
        Path under which to expose metrics.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      EnvironmentFile = mkIf (cfg.environmentFile != null) [ cfg.environmentFile ];
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
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
