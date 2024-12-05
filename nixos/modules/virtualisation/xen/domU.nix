# Common configuration for Xen DomU NixOS virtual machines.

{ ... }:

{
  boot.loader.grub.device = "nodev";

  boot.initrd.kernelModules = [
    "xen-blkfront"
    "xen-tpmfront"
    "xen-kbdfront"
    "xen-fbfront"
    "xen-netfront"
    "xen-pcifront"
    "xen-scsifront"
  ];

  # Send syslog messages to the Xen console.
  services.syslogd.tty = "hvc0";

  # Don't run ntpd, since we should get the correct time from Dom0.
  services.timesyncd.enable = false;
}
