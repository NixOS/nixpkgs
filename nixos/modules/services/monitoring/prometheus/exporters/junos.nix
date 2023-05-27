{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.junos;
  configFile = pkgs.writeText "junos-exporter.yaml" (builtins.toJSON {
    devices = cfg.devices;
    features = {} // (
      lib.genAttrs cfg.enabledFeatures (x: true) //
      lib.genAttrs cfg.disabledFeatures (x: false)
    );
  });
in
{
  port = 9326;
  extraOpts = {
    devices = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      example = literalExample ''
        [
          {
            host = "router1";
            username = "user";
            password = "password";
          }
        ]
      '';
      description = ''
        List of JunOS devices

        Check the official documentation for the corresponding YAML
        settings that can all be used here: <link xlink:href="https://github.com/czerwonk/junos_exporter#config-file" />
      '';
    };

    enabledFeatures = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "environment" "bgp" ];
      description = ''
        Features to enable. The features listed here are enabled in addition to the default ones.
      '';
    };

    disabledFeatures = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "environment" "bgp" ];
      description = ''
        Features to disable. The features listed here are disabled in addition to the default ones.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      RuntimeDirectory = "prometheus-junos-exporter";
      ExecStart = ''
        ${pkgs.prometheus-junos-exporter}/bin/junos_exporter \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
          --config.file ${configFile} ${concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
