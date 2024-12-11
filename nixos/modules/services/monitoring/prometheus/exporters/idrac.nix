{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.idrac;
  inherit (lib) mkOption types;

  configFile =
    if cfg.configurationPath != null then
      cfg.configurationPath
    else
      pkgs.writeText "idrac.yml" (builtins.toJSON cfg.configuration);
in
{
  port = 9348;
  extraOpts = {
    configurationPath = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/etc/prometheus-idrac-exporter/idrac.yml";
      description = ''
        Path to the service's config file. This path can either be a computed path in /nix/store or a path in the local filesystem.

        The config file should NOT be stored in /nix/store as it will contain passwords and/or keys in plain text.

        Mutually exclusive with `configuration` option.

        Configuration reference: https://github.com/mrlhansen/idrac_exporter/#configuration
      '';
    };
    configuration = mkOption {
      type = types.nullOr types.attrs;
      description = ''
        Configuration for iDRAC exporter, as a nix attribute set.

        Configuration reference: https://github.com/mrlhansen/idrac_exporter/#configuration

        Mutually exclusive with `configurationPath` option.
      '';
      default = null;
      example = {
        timeout = 10;
        retries = 1;
        hosts = {
          default = {
            username = "username";
            password = "password";
          };
        };
        metrics = {
          system = true;
          sensors = true;
          power = true;
          sel = true;
          storage = true;
          memory = true;
        };
      };
    };
  };

  serviceOpts = {
    serviceConfig = {
      LoadCredential = "configFile:${configFile}";
      ExecStart = "${pkgs.prometheus-idrac-exporter}/bin/idrac_exporter -config %d/configFile";
      Environment = [
        "IDRAC_EXPORTER_LISTEN_ADDRESS=${cfg.listenAddress}"
        "IDRAC_EXPORTER_LISTEN_PORT=${toString cfg.port}"
      ];
    };
  };
}
