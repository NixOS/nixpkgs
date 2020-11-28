{ config, lib, ... }:

{
  boot.kernelParams = [
    "hid_apple.iso_layout=0"
  ];

  hardware.facetimehd.enable = lib.mkDefault
    (config.nixpkgs.config.allowUnfree or false);

  services.mbpfan.enable = lib.mkDefault true;
}
