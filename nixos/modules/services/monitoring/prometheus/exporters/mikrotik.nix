{ config, lib, pkgs, options, ... }:

with lib;

let
  cfg = config.services.prometheus.exporters.mikrotik;
in
{
  port = 9436;
  extraOpts = {
    configFile = mkOption {
      type = types.nullOr types.path;
      default = null;
      description = lib.mdDoc ''
        Path to a mikrotik exporter configuration file. Mutually exclusive with
        {option}`configuration` option.
      '';
      example = literalExpression "./mikrotik.yml";
    };

    configuration = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = lib.mdDoc ''
        Mikrotik exporter configuration as nix attribute set. Mutually exclusive with
        {option}`configFile` option.

        See <https://github.com/nshttpd/mikrotik-exporter/blob/master/README.md>
        for the description of the configuration file format.
      '';
      example = literalExpression ''
        {
          devices = [
            {
              name = "my_router";
              address = "10.10.0.1";
              user = "prometheus";
              password = "changeme";
            }
          ];
          features = {
            bgp = true;
            dhcp = true;
            routes = true;
            optics = true;
          };
        }
      '';
    };
  };
  serviceOpts = let
    configFile = if cfg.configFile != null
                 then cfg.configFile
                 else "${pkgs.writeText "mikrotik-exporter.yml" (builtins.toJSON cfg.configuration)}";
    in {
    serviceConfig = {
      # -port is misleading name, it actually accepts address too
      ExecStart = ''
        ${pkgs.prometheus-mikrotik-exporter}/bin/mikrotik-exporter \
          -config-file=${escapeShellArg configFile} \
          -port=${cfg.listenAddress}:${toString cfg.port} \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
