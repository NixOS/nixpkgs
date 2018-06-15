# GPaste daemon.
{ config, lib, pkgs, ... }:

with lib;

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
    environment.systemPackages = [ pkgs.gnome3.gpaste ];
    services.dbus.packages = [ pkgs.gnome3.gpaste ];
    services.xserver.desktopManager.gnome3.sessionPath = [ pkgs.gnome3.gpaste ];
    systemd.packages = [ pkgs.gnome3.gpaste ];
  };
}
