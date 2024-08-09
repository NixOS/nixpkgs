{ config, lib, ... }:

with lib;

let
  cfg = config.hardware.tuxedo-drivers;
  tuxedo-drivers = config.boot.kernelPackages.tuxedo-drivers;
in
  {
    imports = [
      (mkRenamedOptionModule ["hardware" "tuxedo-keyboard" ] ["hardware" "tuxedo-drivers" ])
    ];

    options.hardware.tuxedo-drivers = {
      enable = mkEnableOption "the drivers for TUXEDO Computers laptops.";
    };

    config = mkIf cfg.enable
    {
      boot.kernelModules = ["tuxedo_keyboard"];
      boot.extraModulePackages = [ tuxedo-drivers ];
    };
  }
