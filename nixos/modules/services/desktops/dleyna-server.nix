# dleyna-server service.
{
  config,
  lib,
  pkgs,
  ...
}:
{
  ###### interface
  options = {
    services.dleyna-server = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable dleyna-server service, a DBus service
          for handling DLNA servers.
        '';
      };
    };
  };

  ###### implementation
  config = lib.mkIf config.services.dleyna-server.enable {
    environment.systemPackages = [ pkgs.dleyna-server ];

    services.dbus.packages = [ pkgs.dleyna-server ];
  };
}
