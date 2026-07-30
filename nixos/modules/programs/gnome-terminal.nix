# GNOME Terminal.

{
  config,
  pkgs,
  lib,
  ...
}:

let

  cfg = config.programs.gnome-terminal;

in

{

  meta = {
    teams = [ lib.teams.gnome ];
  };

  options = {
    programs.gnome-terminal.enable = lib.mkEnableOption "GNOME Terminal";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnome-terminal ];
    services.dbus.packages = [ pkgs.gnome-terminal ];
    systemd.packages = [ pkgs.gnome-terminal ];

    programs.bash.vteIntegration = true;
    programs.zsh.vteIntegration = true;
  };
}
