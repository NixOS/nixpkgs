{ lib, pkgs, ... }:

{
  imports = [
    ../../../common/cpu/intel
    ../../../common/pc/laptop
    ../../../common/pc/laptop/ssd
  ];

  boot.kernelParams = [ "mem_sleep_default=deep" ];

  services.thermald.enable = true;
}
