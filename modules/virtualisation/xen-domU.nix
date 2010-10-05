# Common configuration for Xen DomU NixOS virtual machines.

{ config, pkgs, ... }:

{
  # We're being booted using pv-grub, which means that we need to
  # generate a GRUB 1 menu without actually installing GRUB.
  boot.loader.grub.version = 1;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.extraPerEntryConfig = "root (hd0)";

  boot.initrd.kernelModules = [ "xen-blkfront" ];

  # Backgrounds don't work, so don't bother.
  services.ttyBackgrounds.enable = false;

  # Send syslog messages to the Xen console.
  services.syslogd.tty = "hvc0";

  # Start a mingetty on the Xen console (so that you can login using
  # "xm console" in Dom0). 
  services.mingetty.ttys = [ "hvc0" "tty1" "tty2" ];
}
