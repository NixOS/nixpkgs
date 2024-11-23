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
    services.dbus.packages = [ pkgs.gnome-remote-desktop ];

    environment.systemPackages = [ pkgs.gnome-remote-desktop ];

    systemd.packages = [ pkgs.gnome-remote-desktop ];
    systemd.tmpfiles.packages = [ pkgs.gnome-remote-desktop ];

    # TODO: if possible, switch to using provided g-r-d sysusers.d
    users = {
      users.gnome-remote-desktop = {
        isSystemUser = true;
        group = "gnome-remote-desktop";
        home = "/var/lib/gnome-remote-desktop";
      };
      groups.gnome-remote-desktop = { };
    };
  };
}
