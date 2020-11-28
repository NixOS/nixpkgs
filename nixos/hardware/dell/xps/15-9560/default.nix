{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ./xps-common.nix
  ];

  # This configuration makes intel default and optionaly applications could run nvidia with optirun.
  # To Optimize for your use case import intel or nvidia only configuration instead
  # xps-9560/intel
  # or
  # xps-9560/nvidia


 ##### bumblebee working, needs reboot to take affect and to use it run: optirun "<application>"
 services.xserver.videoDrivers = lib.mkDefault [ "intel" "nvidia" ];
 boot.blacklistedKernelModules = lib.mkDefault [ "nouveau" "bbswitch" ];
 boot.extraModulePackages = lib.mkDefault [ pkgs.linuxPackages.nvidia_x11 ];
 hardware.bumblebee.enable = lib.mkDefault true;
 hardware.bumblebee.pmMethod = lib.mkDefault "none";

}
