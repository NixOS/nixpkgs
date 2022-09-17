# GNOME Keyring daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2021-05-07
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gnome-keyring" "enable" ]
      [ "services" "gnome" "gnome-keyring" "enable" ]
    )
  ];

  ###### interface

  options = {

    services.gnome.gnome-keyring = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable GNOME Keyring daemon, a service designed to
          take care of the user's security credentials,
          such as user names and passwords.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome.gnome-keyring.enable {

    environment.systemPackages = [ pkgs.gnome.gnome-keyring ];

    services.dbus.packages = [ pkgs.gnome.gnome-keyring pkgs.gcr ];

    xdg.portal.extraPortals = [ pkgs.gnome.gnome-keyring ];

    security.pam.services.login.enableGnomeKeyring = true;

    security.wrappers.gnome-keyring-daemon = {
      owner = "root";
      group = "root";
      capabilities = "cap_ipc_lock=ep";
      source = "${pkgs.gnome.gnome-keyring}/bin/gnome-keyring-daemon";
    };

  };

}
