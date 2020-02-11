{ config, lib, pkgs, ... }:

{
  imports = [
    ../.
    ../../../common/cpu/amd
  ];

  boot.kernelPackages = pkgs.linuxPackages_5_2;
}
