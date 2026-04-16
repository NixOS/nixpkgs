{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.prometheus.exporters.libvirt;
in
{
  port = 9177;
  extraOpts = {
    libvirtUri = lib.mkOption {
      type = lib.types.str;
      default = "qemu:///system";
      description = "Libvirt URI from which to extract metrics";
    };
  };
  serviceOpts = {
    serviceConfig = {
      ExecStart = ''
        ${pkgs.prometheus-libvirt-exporter.exe} \
        --web.listen-address ${cfg.listenAddress}:${toString cfg.port} \
        --libvirt.uri ${cfg.libvirtUri} ${lib.concatStringsSep " " cfg.extraFlags}
      '';
      RestrictAddressFamilies = [
        "AF_UNIX"
        "AF_INET"
        "AF_INET6"
      ];
    };
  };
}
