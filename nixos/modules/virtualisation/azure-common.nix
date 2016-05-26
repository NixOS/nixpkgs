{ config, lib, pkgs, ... }:

with lib;
{
  imports = [ ../profiles/headless.nix ];

  require = [ ./azure-agent.nix ];
  virtualisation.azure.agent.enable = true;

  boot.kernelParams = [ "console=ttyS0" "earlyprintk=ttyS0" "rootdelay=300" "panic=1" "boot.panic_on_fail" ];
  boot.initrd.kernelModules = [ "hv_vmbus" "hv_netvsc" "hv_utils" "hv_storvsc" ];

  # Generate a GRUB menu.
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.version = 2;
  boot.loader.timeout = 0;

  # Don't put old configurations in the GRUB menu.  The user has no
  # way to select them anyway.
  boot.loader.grub.configurationLimit = 0;

  fileSystems."/".device = "/dev/disk/by-label/nixos";

  # Allow root logins only using the SSH key that the user specified
  # at instance creation time, ping client connections to avoid timeouts
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "without-password";
  services.openssh.extraConfig = ''
    ClientAliveInterval 180
  '';

  # Force getting the hostname from Azure
  networking.hostName = mkDefault "";

  # Always include cryptsetup so that NixOps can use it.
  # sg_scan is needed to finalize disk removal on older kernels
  environment.systemPackages = [ pkgs.cryptsetup pkgs.sg3_utils ];

  networking.usePredictableInterfaceNames = false;

  services.udev.extraRules = ''
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:0", ATTR{removable}=="0", SYMLINK+="disk/by-lun/0",
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:1", ATTR{removable}=="0", SYMLINK+="disk/by-lun/1",
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:2", ATTR{removable}=="0", SYMLINK+="disk/by-lun/2"
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:3", ATTR{removable}=="0", SYMLINK+="disk/by-lun/3"

    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:4", ATTR{removable}=="0", SYMLINK+="disk/by-lun/4"
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:5", ATTR{removable}=="0", SYMLINK+="disk/by-lun/5"
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:6", ATTR{removable}=="0", SYMLINK+="disk/by-lun/6"
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:7", ATTR{removable}=="0", SYMLINK+="disk/by-lun/7"

    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:8", ATTR{removable}=="0", SYMLINK+="disk/by-lun/8"
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:9", ATTR{removable}=="0", SYMLINK+="disk/by-lun/9"
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:10", ATTR{removable}=="0", SYMLINK+="disk/by-lun/10"
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:11", ATTR{removable}=="0", SYMLINK+="disk/by-lun/11"

    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:12", ATTR{removable}=="0", SYMLINK+="disk/by-lun/12"
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:13", ATTR{removable}=="0", SYMLINK+="disk/by-lun/13"
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:14", ATTR{removable}=="0", SYMLINK+="disk/by-lun/14"
    ENV{DEVTYPE}=="disk", KERNEL!="sda" SUBSYSTEM=="block", SUBSYSTEMS=="scsi", KERNELS=="?:0:0:15", ATTR{removable}=="0", SYMLINK+="disk/by-lun/15"

  '';

}
