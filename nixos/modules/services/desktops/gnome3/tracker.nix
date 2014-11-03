# Tracker daemon.

{ config, pkgs, lib, ... }:

with lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{

  ###### interface

  options = {

    services.gnome3.tracker = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable Tracker services, a search engine,
          search tool and metadata storage system.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.tracker.enable {

    environment.systemPackages = [ gnome3.tracker ];

    services.dbus.packages = [ gnome3.tracker ];

  };

}
