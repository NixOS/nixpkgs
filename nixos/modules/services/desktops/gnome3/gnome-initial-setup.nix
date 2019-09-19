# GNOME Initial Setup.

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.gnome-initial-setup = {

      enable = mkEnableOption "GNOME Initial Setup, a Simple, easy, and safe way to prepare a new system";

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-initial-setup.enable {

    environment.systemPackages = [
      pkgs.gnome3.gnome-initial-setup
    ];

    systemd.packages = [
      pkgs.gnome3.gnome-initial-setup
    ];

    systemd.user.targets."gnome-session".wants = [
      "gnome-initial-setup-copy-worker.service"
      "gnome-initial-setup-first-login.service"
      "gnome-welcome-tour.service"
    ];

    systemd.user.targets."gnome-session@gnome-initial-setup".wants = [
      "gnome-initial-setup.service"
    ];

    # Setup conflicts
    systemd.user.services."gnome-initial-setup-copy-worker".conflicts = [
      "gnome-session@gnome-login.target"
    ];

    systemd.user.services."gnome-initial-setup-first-login".conflicts = [
      "gnome-session@gnome-login.target"
      "gnome-session@gnome-initial-setup.target"
    ];

  };

}
