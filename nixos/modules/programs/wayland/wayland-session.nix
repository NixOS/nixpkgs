{
  lib,
  pkgs,
  xwayland ? true,
  wlr-portal ? true,
}:

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

  xdg.portal.wlr.enable = wlr-portal;
}
