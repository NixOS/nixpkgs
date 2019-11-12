{ config, lib, ... }:

{
  imports = [ 
    ../../.
    ../../../common/pc/laptop
    ../../../common/pc/ssd
  ];

  # Built-in iSight is recognized by the generic uvcvideo kernel module
  hardware.facetimehd.enable = false;

  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
