# GNOME Keyring daemon.

{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.services.gnome.gnome-keyring;
in
{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  options = {
    services.gnome.gnome-keyring = {
      enable = lib.mkEnableOption ''
        GNOME Keyring daemon, a service designed to
        take care of the user's security credentials,
        such as user names and passwords
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnome.gnome-keyring ];

    services.dbus.packages = [
      pkgs.gnome.gnome-keyring
      pkgs.gcr
    ];

    xdg.portal.extraPortals = [ pkgs.gnome.gnome-keyring ];

    security.pam.services = lib.mkMerge [
      {
        login.enableGnomeKeyring = true;
      }
      (lib.mkIf config.services.xserver.displayManager.gdm.enable {
        gdm-password.enableGnomeKeyring = true;
        gdm-autologin.enableGnomeKeyring = true;
      })
      (lib.mkIf (config.services.xserver.displayManager.gdm.enable && config.services.fprintd.enable) {
        gdm-fingerprint.enableGnomeKeyring = true;
      })
    ];

    security.wrappers.gnome-keyring-daemon = {
      owner = "root";
      group = "root";
      capabilities = "cap_ipc_lock=ep";
      source = "${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon";
    };
  };
}
