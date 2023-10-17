{ lib, pkgs, xwayland ? true }:

with lib;

{
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  hardware.opengl.enable = mkDefault true;
  fonts.enableDefaultPackages = mkDefault true;

  programs = {
    dconf.enable = mkDefault true;
    xwayland.enable = mkDefault xwayland;
  };

  xdg.portal.wlr.enable = mkDefault true;
}
