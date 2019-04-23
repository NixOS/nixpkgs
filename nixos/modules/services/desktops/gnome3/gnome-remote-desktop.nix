# Remote desktop daemon using Pipewire.
{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface
  options = {
    services.gnome3.gnome-remote-desktop = {
      enable = mkEnableOption "Remote Desktop support using Pipewire";
    };
  };

  ###### implementation
  config = mkIf config.services.gnome3.gnome-remote-desktop.enable {
    systemd.packages = [ pkgs.gnome3.gnome-remote-desktop ];
  };
}
