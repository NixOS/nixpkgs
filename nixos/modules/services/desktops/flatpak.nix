# flatpak service.
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.flatpak;
in {
  meta = {
    doc = ./flatpak.xml;
    maintainers = pkgs.flatpak.meta.maintainers;
  };

  ###### interface
  options = {
    services.flatpak = {
      enable = mkEnableOption "flatpak";
    };
  };


  ###### implementation
  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.flatpak ];

    services.dbus.packages = [ pkgs.flatpak ];

    systemd.packages = [ pkgs.flatpak ];

    environment.profiles = [
      "$HOME/.local/share/flatpak/exports"
      "/var/lib/flatpak/exports"
    ];
  };
}
