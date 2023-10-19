# dleyna-server service.
{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface
  options = {
    services.dleyna-server = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = lib.mdDoc ''
          Whether to enable dleyna-server service, a DBus service
          for handling DLNA servers.
        '';
      };
    };
  };


  ###### implementation
  config = mkIf config.services.dleyna-server.enable {
    environment.systemPackages = [ pkgs.dleyna-server ];

    services.dbus.packages = [ pkgs.dleyna-server ];
  };
}
