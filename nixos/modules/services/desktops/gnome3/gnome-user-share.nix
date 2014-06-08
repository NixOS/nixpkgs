# GNOME User Share daemon.

{ config, pkgs, ... }:

with pkgs.lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{

  ###### interface

  options = {

    services.gnome3.gnome-user-share = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GNOME User Share, a service that exports the
          contents of the Public folder in your home directory on the local network.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gnome-user-share.enable {

    environment.systemPackages = [ gnome3.gnome-user-share ];

    services.xserver.displayManager.sessionCommands = with gnome3; ''
      # Don't let gnome-control-center depend upon gnome-user-share
      export XDG_DATA_DIRS=$XDG_DATA_DIRS''${XDG_DATA_DIRS:+:}${gnome-user-share}/share/gsettings-schemas/${gnome-user-share.name}
    '';

  };

}
