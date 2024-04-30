# GNOME Terminal.

{ config, pkgs, lib, ... }:

with lib;

let

  cfg = config.programs.gnome-terminal;

in

{

  meta = {
    maintainers = teams.gnome.members;
  };

  options = {
    programs.gnome-terminal.enable = mkEnableOption "GNOME Terminal";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnome.gnome-terminal ];
    services.dbus.packages = [ pkgs.gnome.gnome-terminal ];
    systemd.packages = [ pkgs.gnome.gnome-terminal ];

    programs.bash.vteIntegration = true;
    programs.zsh.vteIntegration = true;
  };
}
