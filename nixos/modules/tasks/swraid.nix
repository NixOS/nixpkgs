{ config, pkgs, ... }:

{

  environment.systemPackages = [ pkgs.mdadm ];

  services.udev.packages = [ pkgs.mdadm ];

  boot.initrd.availableKernelModules = [ "md_mod" "raid0" "raid1" "raid456" ];

}
