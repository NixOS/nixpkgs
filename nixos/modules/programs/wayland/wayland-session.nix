{ lib, pkgs, xwayland ? true }:

{
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  hardware.opengl.enable = lib.mkDefault true;
  fonts.enableDefaultPackages = lib.mkDefault true;

  programs = {
    dconf.enable = lib.mkDefault true;
    xwayland.enable = lib.mkDefault xwayland;
  };

  xdg.portal.wlr.enable = lib.mkDefault true;
}
