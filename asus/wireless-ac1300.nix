# Use this module if you use a realtek 18812au based wifi dongle, like ASUS Wireless-AC1300
{ pkgs, ... }:
{
  boot.extraModulePackages = [ pkgs.linuxPackages.rtl8812au ];
  boot.kernelModules = [ "8812au" ];
}
