{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.pve;
  inherit (lib)
    lib.mkOption
    types
    mkPackageOption
    lib.optionalString
    lib.optionalAttrs
    ;

  # pve exporter requires a config file so create an empty one if configFile is not provided
  emptyConfigFile = pkgs.writeTextFile {
    name = "pve.yml";
    text = "default:";
  };

  computedConfigFile = if cfg.configFile == null then emptyConfigFile else cfg.configFile;
in
{
  port = 9221;
  extraOpts = {
    package = lib.mkPackageOption pkgs "prometheus-pve-exporter" { };

    environmentFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      example = "/etc/prometheus-pve-exporter/pve.env";
      description = ''
        Path to the service's environment file. This path can either be a computed path in /nix/store or a path in the local filesystem.

        The environment file should NOT be stored in /nix/store as it contains passwords and/or keys in plain text.

        Environment reference: https://github.com/prometheus-pve/prometheus-pve-exporter#authentication
      '';
    };

    configFile = lib.mkOption {
      type = with lib.types; nullOr path;
      default = null;
      example = "/etc/prometheus-pve-exporter/pve.yml";
      description = ''
        Path to the service's config file. This path can either be a computed path in /nix/store or a path in the local filesystem.

        The config file should NOT be stored in /nix/store as it will contain passwords and/or keys in plain text.

        If both configFile and environmentFile are provided, the configFile option will be ignored.

        Configuration reference: https://github.com/prometheus-pve/prometheus-pve-exporter/#authentication
      '';
    };

    server = {
      keyFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        example = "/var/lib/prometheus-pve-exporter/privkey.key";
        description = ''
          Path to a SSL private key file for the server
        '';
      };

      certFile = lib.mkOption {
        type = with lib.types; nullOr path;
        default = null;
        example = "/var/lib/prometheus-pve-exporter/full-chain.pem";
        description = ''
          Path to a SSL certificate file for the server
        '';
      };
    };

    collectors = {
      status = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Collect Node/VM/CT status
        '';
      };
      version = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Collect PVE version info
        '';
      };
      node = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Collect PVE node info
        '';
      };
      cluster = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Collect PVE cluster info
        '';
      };
      resources = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Collect PVE resources info
        '';
      };
      config = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Collect PVE onboot status
        '';
      };
      replication = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Collect PVE replication info
        '';
      };
    };
  };
  serviceOpts = {
    serviceConfig =
      {
        DynamicUser = cfg.environmentFile == null;
        LoadCredential = "configFile:${computedConfigFile}";
        ExecStart = ''
          ${cfg.package}/bin/pve_exporter \
            --${lib.optionalString (!cfg.collectors.status) "no-"}collector.status \
            --${lib.optionalString (!cfg.collectors.version) "no-"}collector.version \
            --${lib.optionalString (!cfg.collectors.node) "no-"}collector.node \
            --${lib.optionalString (!cfg.collectors.cluster) "no-"}collector.cluster \
            --${lib.optionalString (!cfg.collectors.resources) "no-"}collector.resources \
            --${lib.optionalString (!cfg.collectors.config) "no-"}collector.config \
            --${lib.optionalString (!cfg.collectors.replication) "no-"}collector.replication \
            ${lib.optionalString (cfg.server.keyFile != null) "--server.keyfile ${cfg.server.keyFile}"} \
            ${lib.optionalString (cfg.server.certFile != null) "--server.certfile ${cfg.server.certFile}"} \
            --config.file %d/configFile \
            --web.listen-address ${cfg.listenAddress}:${toString cfg.port}
        '';
      }
      // lib.optionalAttrs (cfg.environmentFile != null) {
        EnvironmentFile = cfg.environmentFile;
      };
  };
}
