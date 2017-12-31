# flatpak service.
{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface
  options = {
    services.flatpak = {
      enable = mkEnableOption "flatpak";
    };
  };


  ###### implementation
  config = mkIf config.services.flatpak.enable {
    environment.systemPackages = [ pkgs.flatpak ];

    services.dbus.packages = [ pkgs.flatpak ];

    systemd.packages = [ pkgs.flatpak ];

    environment.variables.PATH = [
      "$HOME/.local/share/flatpak/exports/bin"
      "/var/lib/flatpak/exports/bin"
    ];
  };
}
