# Remote desktop daemon using Pipewire.
{ config, lib, pkgs, ... }:

{
  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface
  options = {
    services.gnome.gnome-remote-desktop = {
      enable = lib.mkEnableOption "Remote Desktop support using Pipewire";
    };
  };

  ###### implementation
  config = lib.mkIf config.services.gnome.gnome-remote-desktop.enable {
    services.pipewire.enable = true;

    systemd.packages = [ pkgs.gnome.gnome-remote-desktop ];
  };
}
