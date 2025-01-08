{
  config,
  lib,
  pkgs,
  options,
  ...
}:

let
  cfg = config.services.prometheus.exporters.dnsmasq;
  inherit (lib)
    lib.mkOption
    types
    concatStringsSep
    escapeShellArg
    ;
in
{
  port = 9153;
  extraOpts = {
    dnsmasqListenAddress = lib.mkOption {
      type = lib.types.str;
      default = "localhost:53";
      description = ''
        Address on which dnsmasq listens.
      '';
    };
    leasesPath = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/dnsmasq/dnsmasq.leases";
      example = "/var/lib/misc/dnsmasq.leases";
      description = ''
        Path to the `dnsmasq.leases` file.
      '';
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-dnsmasq-exporter}/bin/dnsmasq_exporter \
          --listen ${cfg.listenAddress}:${toString cfg.port} \
          --dnsmasq ${cfg.dnsmasqListenAddress} \
          --leases_path ${lib.escapeShellArg cfg.leasesPath} \
          ${lib.concatStringsSep " \\\n  " cfg.extraFlags}
      '';
    };
  };
}
