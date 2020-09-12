{ config, pkgs, lib, ... }:
{
  options.virtualisation.spiceUSBRedirection.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = ''
      Install the SPICE USB redirection helper with setuid
      privileges. This allows unprivileged users to pass USB devices
      connected to this machine to libvirt VMs, both local and
      remote. Note that this allows users arbitrary access to USB
      devices.
    '';
  };

  config = lib.mkIf config.virtualisation.spiceUSBRedirection.enable {
    environment.systemPackages = [ pkgs.spice_gtk ];
    security.wrappers.spice-client-glib-usb-acl-helper.source = "${pkgs.spice_gtk}/bin/spice-client-glib-usb-acl-helper";
  };

  meta.maintainers = [ lib.maintainers.lheckemann ];
}
