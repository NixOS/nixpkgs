# dleyna-renderer service.
{ config, lib, pkgs, ... }:
{
  ###### interface
  options = {
    services.dleyna-renderer = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable dleyna-renderer service, a DBus service
          for handling DLNA renderers.
        '';
      };
    };
  };


  ###### implementation
  config = lib.mkIf config.services.dleyna-renderer.enable {
    environment.systemPackages = [ pkgs.dleyna-renderer ];

    services.dbus.packages = [ pkgs.dleyna-renderer ];
  };
}
