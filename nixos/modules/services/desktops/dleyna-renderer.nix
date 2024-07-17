# dleyna-renderer service.
{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  ###### interface
  options = {
    services.dleyna-renderer = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable dleyna-renderer service, a DBus service
          for handling DLNA renderers.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf config.services.dleyna-renderer.enable {
    environment.systemPackages = [ pkgs.dleyna-renderer ];

    services.dbus.packages = [ pkgs.dleyna-renderer ];
  };
}
