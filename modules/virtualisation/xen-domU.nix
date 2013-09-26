# Common configuration for Xen DomU NixOS virtual machines.

{ config, pkgs, ... }:

{
  # We're being booted using pv-grub, which means that we need to
  # generate a GRUB 1 menu without actually installing GRUB.
  boot.loader.grub.version = 1;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.extraPerEntryConfig = "root (hd0)";

  boot.initrd.kernelModules = [ "xen-blkfront" ];

  # Send syslog messages to the Xen console.
  services.syslogd.tty = "hvc0";

  # Don't run ntpd, since we should get the correct time from Dom0.
  services.ntp.enable = false;
}
