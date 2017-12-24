{ config, lib, pkgs, ... }:

{
  imports = [ ../. ];

  # hard disk protection if the laptop falls
  services.hdapsd.enable = lib.mkDefault true;
  services.xserver.videoDrivers = [ "intel" ];
}
