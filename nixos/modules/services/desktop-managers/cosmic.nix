# Copyright (c) 2024, Lily Foster <lily@lily.flowers>

# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

# This module was originally developed independently by lilystarlight in
# https://github.com/lilyinstarlight/nixos-cosmic and was migrated to nixpkgs by Aleksana.

{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.desktopManager.cosmic;
in
{
  meta.maintainers = lib.teams.cosmic.members;

  options = {
    services.desktopManager.cosmic = {
      enable = lib.mkEnableOption "COSMIC desktop environment";

      xwayland.enable = lib.mkEnableOption "Xwayland support for cosmic-comp" // {
        default = true;
      };
    };

    environment.cosmic.excludePackages = lib.mkOption {
      description = "List of COSMIC packages to exclude from the default environment";
      type = lib.types.listOf lib.types.package;
      default = [ ];
      example = lib.literalExpression "[ pkgs.cosmic-edit ]";
    };
  };

  config = lib.mkIf cfg.enable {
    # environment packages
    environment.pathsToLink = [ "/share/cosmic" ];
    environment.systemPackages = lib.utils.removePackagesByName (
      with pkgs;
      [
        adwaita-icon-theme
        alsa-utils
        cosmic-applets
        cosmic-applibrary
        cosmic-bg
        (cosmic-comp.override {
          useXWayland = config.services.desktopManager.cosmic.xwayland.enable;
        })
        cosmic-edit
        cosmic-files
        cosmic-greeter
        cosmic-icons
        cosmic-launcher
        cosmic-notifications
        cosmic-osd
        cosmic-panel
        cosmic-randr
        cosmic-screenshot
        cosmic-session
        cosmic-settings
        cosmic-settings-daemon
        cosmic-term
        cosmic-wallpapers
        cosmic-workspaces-epoch
        hicolor-icon-theme
        playerctl
        pop-icon-theme
        pop-launcher
      ]
      ++ lib.optionals config.services.flatpak.enable [
        cosmic-store
      ]
    ) config.environment.cosmic.excludePackages;

    # xdg portal packages and config
    xdg.portal = {
      enable = true;
      extraPortals =
        with pkgs;
        [
          xdg-desktop-portal-cosmic
          xdg-desktop-portal-gtk
        ];
      configPackages = lib.mkDefault (
        with pkgs;
        [
          xdg-desktop-portal-cosmic
        ]
      );
    };

    # fonts
    fonts.packages = lib.utils.removePackagesByName (with pkgs; [
      fira
    ]) config.environment.cosmic.excludePackages;

    # required features
    hardware.graphics.enable = true;
    services.libinput.enable = true;
    xdg.mime.enable = true;
    xdg.icons.enable = true;

    # optional features
    hardware.bluetooth.enable = lib.mkDefault true;
    services.acpid.enable = lib.mkDefault true;
    services.pipewire = {
      enable = lib.mkDefault true;
      alsa.enable = lib.mkDefault true;
      pulse.enable = lib.mkDefault true;
    };
    services.gvfs.enable = lib.mkDefault true;
    networking.networkmanager.enable = lib.mkDefault true;
    services.gnome.gnome-keyring.enable = lib.mkDefault true;

    # general graphical session features
    programs.dconf.enable = lib.mkDefault true;

    # required dbus services
    services.accounts-daemon.enable = true;
    services.upower.enable = true;
    services.power-profiles-daemon.enable = lib.mkDefault (
      !config.hardware.system76.power-daemon.enable
    );
    security.polkit.enable = true;
    security.rtkit.enable = true;

    # session packages
    services.displayManager.sessionPackages = with pkgs; [ cosmic-session ];
    systemd.packages = with pkgs; [ cosmic-session ];
    # TODO: remove when upstream has XDG autostart support
    systemd.user.targets.cosmic-session = {
      wants = [ "xdg-desktop-autostart.target" ];
      before = [ "xdg-desktop-autostart.target" ];
    };

    # required for screen locker
    security.pam.services.cosmic-greeter = { };
  };
}
