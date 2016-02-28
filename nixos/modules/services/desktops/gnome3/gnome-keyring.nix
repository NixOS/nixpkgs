# GNOME Keyring daemon.

{ config, pkgs, lib, ... }:

with lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
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

    environment.systemPackages = [ gnome3.gnome_keyring ];

    services.dbus.packages = [ gnome3.gnome_keyring gnome3.gcr ];

  };

}
