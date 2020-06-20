{ config, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [ rtl8812au ];
  boot.kernelModules = [ "8812au" ];
}
