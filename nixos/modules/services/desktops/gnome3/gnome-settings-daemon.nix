# GNOME Settings Daemon

{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.gnome-settings-daemon = {

      enable = mkEnableOption "GNOME Settings Daemon";

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-settings-daemon.enable {

    environment.systemPackages = [ pkgs.gnome3.gnome-settings-daemon ];

    services.udev.packages = [ pkgs.gnome3.gnome-settings-daemon ];

    security.wrappers.gsd-backlight-helper.source = "${pkgs.gnome3.gnome-settings-daemon}/libexec/gsd-backlight-helper";

    nixpkgs.overlays = [
      (self: super: {
        gnome3 = super.gnome3.overrideScope' (gself: gsuper: {
          gnome-settings-daemon = gsuper.gnome-settings-daemon.override {
            inherit (config.security) wrapperDir;
          };
        });
      })
    ];

  };

}
