{ lib, pkgs, ... }: with lib; {
    security = {
      polkit.enable = true;
      pam.services.swaylock = {};
    };

    hardware.opengl.enable = mkDefault true;
    fonts.enableDefaultPackages = mkDefault true;

    programs = {
      dconf.enable = mkDefault true;
      xwayland.enable = mkDefault true;
    };

    xdg.portal = {
      enable = mkDefault true;

      extraPortals = [
        # For screen sharing
        pkgs.xdg-desktop-portal-wlr
      ];

      # https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1050913
      config.default = mkDefault [ "wlr" "gtk" ];
    };
}
