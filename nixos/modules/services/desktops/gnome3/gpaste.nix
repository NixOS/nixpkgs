# GPaste daemon.
{ config, lib, ... }:

with lib;

let
  gnome3 = config.environment.gnome3.packageSet;
in
{
  ###### interface
  options = {
    services.gnome3.gpaste = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable GPaste, a clipboard manager.
        '';
      };
    };
  };

  ###### implementation
  config = mkIf config.services.gnome3.gpaste.enable {
    environment.systemPackages = [ gnome3.gpaste ];
    services.dbus.packages = [ gnome3.gpaste ];
    services.xserver.desktopManager.gnome3.sessionPath = [ gnome3.gpaste ];
    systemd.packages = [ gnome3.gpaste ];
  };
}
