# GPaste.
{ config, lib, pkgs, ... }:

{

  ###### interface
  options = {
     programs.gpaste = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Whether to enable GPaste, a clipboard manager.
        '';
      };
    };
  };

  ###### implementation
  config = lib.mkIf config.programs.gpaste.enable {
    environment.systemPackages = [ pkgs.gnome.gpaste ];
    services.dbus.packages = [ pkgs.gnome.gpaste ];
    systemd.packages = [ pkgs.gnome.gpaste ];
    # gnome-control-center crashes in Keyboard Shortcuts pane without the GSettings schemas.
    services.xserver.desktopManager.gnome.sessionPath = [ pkgs.gnome.gpaste ];
    # gpaste-reloaded applet doesn't work without the typelib
    services.xserver.desktopManager.cinnamon.sessionPath = [ pkgs.gnome.gpaste ];
  };
}
