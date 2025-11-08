{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.node-cert;
  inherit (lib) mkOption types concatStringsSep;
in
{
  port = 9141;

  extraOpts = {
    paths = mkOption {
      type = types.listOf types.str;
      description = ''
        List of paths to search for SSL certificates.
      '';
    };

    excludePaths = mkOption {
      type = types.listOf types.str;
      description = ''
        List of paths to exclute from searching for SSL certificates.
      '';
      default = [ ];
    };

    includeGlobs = mkOption {
      type = types.listOf types.str;
      description = ''
        List files matching a pattern to include. Uses Go blob pattern.
      '';
      default = [ ];
    };

    excludeGlobs = mkOption {
      type = types.listOf types.str;
      description = ''
        List files matching a pattern to include. Uses Go blob pattern.
      '';
      default = [ ];
    };

    user = mkOption {
      type = types.str;
      description = ''
        User owning the certs.
      '';
      default = "acme";
    };
  };

  serviceOpts = {
    serviceConfig = {
      User = cfg.user;
      ExecStart = ''
        ${lib.getExe pkgs.prometheus-node-cert-exporter} \
          --listen ${toString cfg.listenAddress}:${toString cfg.port} \
          --path ${concatStringsSep "," cfg.paths} \
          --exclude-path "${concatStringsSep "," cfg.excludePaths}" \
          --include-glob "${concatStringsSep "," cfg.includeGlobs}" \
          --exclude-glob "${concatStringsSep "," cfg.excludeGlobs}" \
          ${concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
