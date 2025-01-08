{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.mikrotik;
in
{
  port = 9436;
  extraOpts = {
    configFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = ''
        Path to a mikrotik exporter configuration file. Mutually exclusive with
        {option}`configuration` option.
      '';
      example = lib.literalExpression "./mikrotik.yml";
    };

    configuration = lib.mkOption {
      type = lib.types.nullOr lib.types.attrs;
      default = null;
      description = ''
        Mikrotik exporter configuration as nix attribute set. Mutually exclusive with
        {option}`configFile` option.

        See <https://github.com/nshttpd/mikrotik-exporter/blob/master/README.md>
        for the description of the configuration file format.
      '';
      example = lib.literalExpression ''
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
  serviceOpts =
    let
      configFile =
        if cfg.configFile != null then
          cfg.configFile
        else
          "${pkgs.writeText "mikrotik-exporter.yml" (builtins.toJSON cfg.configuration)}";
    in
    {
      serviceConfig = {
        # -port is misleading name, it actually accepts address too
        ExecStart = ''
          ${pkgs.prometheus-mikrotik-exporter}/bin/mikrotik-exporter \
            -config-file=${lib.escapeShellArg configFile} \
            -port=${cfg.listenAddress}:${toString cfg.port} \
            ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
        '';
      };
    };
}
