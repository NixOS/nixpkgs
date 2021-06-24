# GPaste.
{ config, lib, pkgs, ... }:

with lib;

{

  # Added 2019-08-09
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gpaste" "enable" ]
      [ "programs" "gpaste" "enable" ])
  ];

  ###### interface
  options = {
     programs.gpaste = {
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
  config = mkIf config.programs.gpaste.enable {
    environment.systemPackages = [ pkgs.gnome3.gpaste ];
    services.dbus.packages = [ pkgs.gnome3.gpaste ];
    systemd.packages = [ pkgs.gnome3.gpaste ];
    # gnome-control-center crashes in Keyboard Shortcuts pane without the GSettings schemas.
    services.xserver.desktopManager.gnome3.sessionPath = [ pkgs.gnome3.gpaste ];
  };
}
