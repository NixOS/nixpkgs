# GNOME Settings Daemon

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.gnome3.gnome-settings-daemon;

in

{

  imports = [
    (mkRemovedOptionModule
      ["services" "gnome3" "gnome-settings-daemon" "package"]
      "")
  ];

  ###### interface

  options = {

    services.gnome3.gnome-settings-daemon = {

      enable = mkEnableOption "GNOME Settings Daemon";

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [
      pkgs.gnome3.gnome-settings-daemon
    ];

    services.udev.packages = [
      pkgs.gnome3.gnome-settings-daemon
    ];

  };

}
