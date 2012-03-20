{ config, pkgs, ... }:

with pkgs.lib;

let virtualbox = config.boot.kernelPackages.virtualbox; in

{
  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" ];
  boot.extraModulePackages = [ virtualbox ];
  environment.systemPackages = [ virtualbox ];

  users.extraGroups = singleton { name = "vboxusers"; };
  
  services.udev.extraRules =
    ''
      KERNEL=="vboxdrv",    OWNER="root", GROUP="vboxusers", MODE="0660"
      KERNEL=="vboxnetctl", OWNER="root", GROUP="root",      MODE="0600"
    '';
}
