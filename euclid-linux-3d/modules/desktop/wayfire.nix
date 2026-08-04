{ config, pkgs, lib, ... }:

{
  programs.wayfire = {
    enable = true;
    plugins = with pkgs.wayfirePlugins; [
      wayfire-plugins-extra
      wcm
    ];
  };

  # Required for legacy X11 apps
  programs.xwayland.enable = true;

  # Essential Wayfire dependencies and shell
  environment.systemPackages = with pkgs; [
    wayfire
    wayfirePlugins.wayfire-plugins-extra
    wayfirePlugins.wf-shell
    wayfirePlugins.wcm
    wayland-utils
    xwayland
    xdg-desktop-portal
    xdg-desktop-portal-wlr
    xdg-desktop-portal-gtk
  ];

  # Desktop portals
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    config.common.default = [ "wlr" "gtk" ];
  };
}
