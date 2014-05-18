# GNOME Documents daemon.

{ config, pkgs, ... }:

with pkgs.lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{

  ###### interface

  options = {

    services.gnome3.gnome-documents = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME Documents services, a document
          manager application for GNOME.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-documents.enable {

    environment.systemPackages = [ gnome3.gnome-documents ];

    services.dbus.packages = [ gnome3.gnome-documents ];

    services.gnome3.gnome-online-accounts.enable = true;

    services.gnome3.gnome-online-miners.enable = true;

  };

}
