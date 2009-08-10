{pkgs, config, ...}:

let
  wisGo7007 = config.boot.kernelPackages.wis_go7007;

  wisGo7007Pkg = [ wis_go7007 ];
  wisGo7007Firmware = [ "${wis_go7007}/firmware" ];
in

{
  boot.extraModulePackages = [wisGo7007Pkg];

  environment.extraPackages = [wisGo7007Pkg];

  services.udev.addFirmware = [wisGo7007Firmware];
  services.udev.packages = [wisGo7007Pkg];
}
