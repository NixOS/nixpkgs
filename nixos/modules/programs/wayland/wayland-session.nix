{ lib, pkgs, ... }: {
    security = {
      polkit.enable = true;
      pam.services.swaylock = {};
    };

    hardware.opengl.enable = lib.mkDefault true;
    fonts.enableDefaultPackages = lib.mkDefault true;

    programs = {
      dconf.enable = lib.mkDefault true;
      xwayland.enable = lib.mkDefault true;
    };

    xdg.portal = {
      enable = lib.mkDefault true;

      extraPortals = [
        # For screen sharing
        pkgs.xdg-desktop-portal-wlr
      ];
    };
}
