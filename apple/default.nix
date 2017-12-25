{ config, lib, ... }:

{
  hardware.facetimehd.enable = lib.mkDefault
    (config.nixpkgs.config.allowUnfree or false);

  services.mbpfan.enable = lib.mkDefault true;
}
