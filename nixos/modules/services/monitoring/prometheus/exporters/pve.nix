{ config, lib, pkgs, options }:

with lib;
let
  cfg = config.services.prometheus.exporters.pve;

  # pve exporter requires a config file so create an empty one if configFile is not provided
  emptyConfigFile = pkgs.writeTextFile {
    name = "pve.yml";
    text = "default:";
  };

  computedConfigFile = "${if cfg.configFile == null then emptyConfigFile else cfg.configFile}";
in
{
  port = 9221;
  extraOpts = {
    package = mkOption {
      type = types.package;
      default = pkgs.prometheus-pve-exporter;
      defaultText = literalExpression "pkgs.prometheus-pve-exporter";
      example = literalExpression "pkgs.prometheus-pve-exporter";
      description = lib.mdDoc ''
        The package to use for prometheus-pve-exporter
      '';
    };

    environmentFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/etc/prometheus-pve-exporter/pve.env";
      description = lib.mdDoc ''
        Path to the service's environment file. This path can either be a computed path in /nix/store or a path in the local filesystem.

        The environment file should NOT be stored in /nix/store as it contains passwords and/or keys in plain text.

        Environment reference: https://github.com/prometheus-pve/prometheus-pve-exporter#authentication
      '';
    };

    configFile = mkOption {
      type = with types; nullOr path;
      default = null;
      example = "/etc/prometheus-pve-exporter/pve.yml";
      description = lib.mdDoc ''
        Path to the service's config file. This path can either be a computed path in /nix/store or a path in the local filesystem.

        The config file should NOT be stored in /nix/store as it will contain passwords and/or keys in plain text.

        If both configFile and environmentFile are provided, the configFile option will be ignored.

        Configuration reference: https://github.com/prometheus-pve/prometheus-pve-exporter/#authentication
      '';
    };

    collectors = {
      status = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Collect Node/VM/CT status
        '';
      };
      version = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Collect PVE version info
        '';
      };
      node = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Collect PVE node info
        '';
      };
      cluster = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Collect PVE cluster info
        '';
      };
      resources = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Collect PVE resources info
        '';
      };
      config = mkOption {
        type = types.bool;
        default = true;
        description = lib.mdDoc ''
          Collect PVE onboot status
        '';
      };
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${cfg.package}/bin/pve_exporter \
          --${if cfg.collectors.status == true then "" else "no-"}collector.status \
          --${if cfg.collectors.version == true then "" else "no-"}collector.version \
          --${if cfg.collectors.node == true then "" else "no-"}collector.node \
          --${if cfg.collectors.cluster == true then "" else "no-"}collector.cluster \
          --${if cfg.collectors.resources == true then "" else "no-"}collector.resources \
          --${if cfg.collectors.config == true then "" else "no-"}collector.config \
          ${computedConfigFile} \
          ${toString cfg.port} ${cfg.listenAddress}
      '';
    } // optionalAttrs (cfg.environmentFile != null) {
          EnvironmentFile = cfg.environmentFile;
    };
  };
}
