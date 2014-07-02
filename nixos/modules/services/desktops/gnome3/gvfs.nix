# gvfs backends

{ config, lib, ... }:

with lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{

  ###### interface

  options = {

    services.gnome3.gvfs = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable gvfs backends, userspace virtual filesystem used
          by GNOME components via D-Bus.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.gnome3.gvfs.enable {

    environment.systemPackages = [ gnome3.gvfs ];

    services.dbus.packages = [ gnome3.gvfs ];

  };

}
