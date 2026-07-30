{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.mango;
in
{
  options.programs.mango = {
    enable = lib.mkEnableOption "Mango, a Wayland compositor based on dwl and scenefx";

    package = lib.mkPackageOption pkgs "mango" {
      default = [ "mango" ];
      example = "pkgs.mango.override { enableXWayland = false; }";
    };
  };

  imports = [
    (lib.mkRenamedOptionModule [ "programs" "mangowc" ] [ "programs" "mango" ])
  ];

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    # Necessary Wayland plumbing
    xdg.portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gtk
      ];

      config.mango = {
        default = [
          "gtk"
        ];

        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "wlr" ];
        "org.freedesktop.impl.portal.ScreenShot" = [ "wlr" ];

        # wlr does not have this interface, let gtk handle
        "org.freedesktop.impl.portal.Inhibit" = [ "gtk" ];
      };
    };

    # Set up the session for Display Managers (GDM, SDDM, etc.)
    services.displayManager.sessionPackages = [ cfg.package ];
  };
}
