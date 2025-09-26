{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.programs.zoom-us = {
    enable = lib.mkEnableOption "zoom.us video conferencing application";
    package = lib.mkPackageOption pkgs "zoom-us" { };
  };

  config.environment.systemPackages = lib.mkIf config.programs.zoom-us.enable (
    lib.singleton (
      # The pattern here is to use the already-overridden value, or provide a default based on the
      # configuration elsewhere.
      config.programs.zoom-us.package.override (prev: {
        # Support pulseaudio if it's enabled on the system.
        pulseaudioSupport = prev.pulseaudioSupport or config.services.pulseaudio.enable;

        # Support Plasma 6 desktop environment if it's enabled on the system.
        plasma6XdgDesktopPortalSupport =
          prev.plasma6XdgDesktopPortalSupport or config.services.desktopManager.plasma6.enable;

        # Support LXQT desktop environment if it's enabled on the system.
        # There's also `config.services.xserver.desktopManager.lxqt.enable`
        lxqtXdgDesktopPortalSupport = prev.lxqtXdgDesktopPortalSupport or config.xdg.portal.lxqt.enable;

        # Support GNOME desktop environment if it's enabled on the system.
        gnomeXdgDesktopPortalSupport =
          prev.gnomeXdgDesktopPortalSupport or config.services.desktopManager.gnome.enable;

        # Support Hyprland desktop for Wayland if it's enabled on the system.
        hyprlandXdgDesktopPortalSupport =
          prev.hyprlandXdgDesktopPortalSupport or config.programs.hyprland.enable;

        # Support `wlroots` XDG desktop portal support if it's enabled.
        wlrXdgDesktopPortalSupport = prev.wlrXdgDesktopPortalSupport or config.xdg.portal.wlr.enable;

        # Support xapp XDG desktop portals if the Cinnamon desktop environment is enabled.
        # The site claims that it's also used for Xfce4 and MATE; consider adding those to the
        # default in the future.
        xappXdgDesktopPortalSupport =
          prev.xappXdgDesktopPortalSupport or config.services.xserver.desktopManager.cinnamon.enable;

        # Finally, if the `xdg.portal.enable` option is set somehow, use the `targetPkgs` function
        # to add those relevant packages in.
        targetPkgs =
          prev.targetPkgs or (
            pkgs:
            lib.optionals config.xdg.portal.enable (
              [ pkgs.xdg-desktop-portal ] ++ config.xdg.portal.extraPortals
            )
          );
      })
    )
  );
}
