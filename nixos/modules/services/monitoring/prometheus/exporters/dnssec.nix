{ config, lib, pkgs, options }:
with lib;
let
  cfg = config.services.prometheus.exporters.dnssec;
  settingsFormat = pkgs.formats.toml { };
  configFile = settingsFormat.generate "dnssec-checks.toml" cfg.configuration;
in
{
  port = 9204;
  extraOpts = {
    configuration = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = lib.mdDoc ''
        dnssec exporter configuration as nix attribute set.

        See <https://github.com/chrj/prometheus-dnssec-exporter/blob/master/README.md>
        for the description of the configuration file format.
      '';
      example = literalExpression ''
        {
          records = [
            {
              zone = "ietf.org";
              record = "@";
              type = "SOA";
            }
            {
              zone = "verisigninc.com";
              record = "@";
              type = "SOA";
            }
          ];
        }
      '';
    };

    listenAddress = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        Listen address as host IP and port definition.
      '';
      example = ":${cfg.port}";
    };

    resolvers = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = lib.mdDoc ''
        DNSSEC capable resolver to be used for the check.
      '';
      example = [ "0.0.0.0:53" ];
    };

    timeout = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = lib.mdDoc ''
        DNS request timeout duration.
      '';
      example = "10s";
    };

    extraFlags = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = lib.mdDoc ''
        Extra commandline options when launching Prometheus.
      '';
    };
  };

  serviceOpts = {
    serviceConfig =
      let
        startScript = pkgs.writeShellScriptBin "prometheus-dnssec-exporter-start" "${concatStringsSep " " ([
      "${pkgs.prometheus-dnssec-exporter}/bin/prometheus-dnssec-exporter"
    ]
      ++ optionals (cfg.configuration != null) [
      "-config ${configFile}"
    ]
      ++ optionals (cfg.listenAddress != null) [
      "-listen-address ${escapeShellArg cfg.listenAddress}"
    ]
      ++ optionals (cfg.resolvers != null) [
      "-resolvers ${escapeShellArg (concatStringsSep "," cfg.resolvers)}"
    ]
      ++ optionals (cfg.timeout != null) [
      "-timeout ${escapeShellArg cfg.timeout}"
    ]
      ++ cfg.extraFlags)}";
      in
      {
        ExecStart = "${startScript}/bin/prometheus-dnssec-exporter-start";
      };
  };
}
