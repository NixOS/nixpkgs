{
  lib,
  enableXWayland ? true,
  enableWlrPortal ? true,
}:

{
  security = {
    polkit.enable = true;
    pam.services.swaylock = {};
  };

  programs = {
    dconf.enable = lib.mkDefault true;
    xwayland.enable = lib.mkDefault enableXWayland;
  };

  services.graphical-desktop.enable = true;

  xdg.portal.wlr.enable = enableWlrPortal;

  # Window manager only sessions (unlike DEs) don't handle XDG
  # autostart files, so force them to run the service
  services.xserver.desktopManager.runXdgAutostartIfNone = lib.mkDefault true;
}
