{ config, lib, pkgs, options }:

with lib;

let
  cfg = config.services.prometheus.exporters.libvirt;
in
{
  port = 9177;
  extraOpts = {
    libvirtUri = mkOption {
      type = types.str;
      default = "qemu:///system";
      description = lib.mdDoc "Libvirt URI from which to extract metrics";
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-libvirt-exporter}/bin/libvirt-exporter \
        --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
        --libvirt.uri ${cfg.libvirtUri} ${concatStringsSep " " cfg.extraFlags}
      '';
    };
  };
}
