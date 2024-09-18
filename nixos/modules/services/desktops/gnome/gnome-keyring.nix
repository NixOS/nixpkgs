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
    environment.systemPackages = [ pkgs.gnome-keyring ];

    services.dbus.packages = [
      pkgs.gnome-keyring
      pkgs.gcr
    ];

    xdg.portal.extraPortals = [ pkgs.gnome-keyring ];

    security.pam.services.login.enableGnomeKeyring = true;

    security.wrappers.gnome-keyring-daemon = {
      owner = "root";
      group = "root";
      capabilities = "cap_ipc_lock=ep";
      source = "${pkgs.gnome-keyring}/bin/gnome-keyring-daemon";
    };
  };
}
