{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.frr;
  inherit (lib)
    mkOption
    types
    concatStringsSep
    concatMapStringsSep
    ;
in
{
  port = 9342;
  extraOpts = {
    user = mkOption {
      type = types.str;
      default = "frr";
      description = ''
        User name under which the frr exporter shall be run.
        The exporter talks to frr using a unix socket, which is owned by frr.
      '';
    };
    group = mkOption {
      type = types.str;
      default = "frrtty";
      description = ''
        Group under which the frr exporter shall be run.
        The exporter talks to frr using a unix socket, which is owned by frrtty group.
      '';
    };
    enabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "vrrp" ];
      description = ''
        Collectors to enable. The collectors listed here are enabled in addition to the default ones.
      '';
    };
    disabledCollectors = mkOption {
      type = types.listOf types.str;
      default = [ ];
      example = [ "bfd" ];
      description = ''
        Collectors to disable which are enabled by default.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      DynamicUser = false;
      RuntimeDirectory = "prometheus-frr-exporter";
      RestrictAddressFamilies = [ "AF_UNIX" ];
      ExecStart = ''
        ${lib.getExe pkgs.prometheus-frr-exporter} \
          ${concatMapStringsSep " " (x: "--collector." + x) cfg.enabledCollectors} \
          ${concatMapStringsSep " " (x: "--no-collector." + x) cfg.disabledCollectors} \
          --web.listen-address ${cfg.listenAddress}:${toString cfg.port} ${concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
