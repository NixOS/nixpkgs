# GNOME Keyring daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.gnome3.gnome-keyring = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Keyring daemon, a service designed to
          take care of the user's security credentials,
          such as user names and passwords.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-keyring.enable {

    environment.systemPackages = [ pkgs.gnome3.gnome-keyring ];

    services.dbus.packages = [ pkgs.gnome3.gnome-keyring pkgs.gcr ];

    security.pam.services.login.enableGnomeKeyring = true;

    security.wrappers.gnome-keyring-daemon = {
      source = "${pkgs.gnome3.gnome-keyring}/bin/gnome-keyring-daemon";
      capabilities = "cap_ipc_lock=ep";
    };

  };

}
