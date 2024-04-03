# Remote desktop daemon using Pipewire.
{ config, lib, pkgs, ... }:

with lib;

{
  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2021-05-07
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gnome-remote-desktop" "enable" ]
      [ "services" "gnome" "gnome-remote-desktop" "enable" ]
    )
  ];

  ###### interface
  options = {
    services.gnome.gnome-remote-desktop = {
      enable = mkEnableOption (lib.mdDoc "Remote Desktop support using Pipewire");
    };
  };

  ###### implementation
  config = mkIf config.services.gnome.gnome-remote-desktop.enable {
    services.pipewire.enable = true;
    services.dbus.packages = [ pkgs.gnome.gnome-remote-desktop ];

    environment.systemPackages = [ pkgs.gnome.gnome-remote-desktop ];

    systemd.packages = [ pkgs.gnome.gnome-remote-desktop ];
    systemd.tmpfiles.packages = [ pkgs.gnome.gnome-remote-desktop ];

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
