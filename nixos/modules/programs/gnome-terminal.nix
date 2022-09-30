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

  # Added 2019-08-19
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gnome-terminal-server" "enable" ]
      [ "programs" "gnome-terminal" "enable" ])
  ];

  options = {
    programs.gnome-terminal.enable = mkEnableOption (lib.mdDoc "GNOME Terminal");
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.gnome.gnome-terminal ];
    services.dbus.packages = [ pkgs.gnome.gnome-terminal ];
    systemd.packages = [ pkgs.gnome.gnome-terminal ];

    programs.bash.vteIntegration = true;
    programs.zsh.vteIntegration = true;
  };
}
