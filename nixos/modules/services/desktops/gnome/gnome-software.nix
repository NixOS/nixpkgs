{
  config,
  pkgs,
  lib,
  ...
}:

{
  meta = {
    teams = [ lib.teams.gnome ];
  };

  options = {
    services.gnome.gnome-software = {
      enable = lib.mkEnableOption "GNOME Software, package manager for GNOME";
    };
  };

  config = lib.mkIf config.services.gnome.gnome-software.enable {
    environment.systemPackages = [
      pkgs.gnome-software
    ];

    systemd.packages = [
      pkgs.gnome-software
    ];
  };
}
