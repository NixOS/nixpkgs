{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.virtualisation.libvirtd.dbus;
in

{
  options.virtualisation.libvirtd.dbus = {
    enable = lib.mkEnableOption "exposing libvirtd APIs over D-Bus";
    package = lib.mkPackageOption pkgs "libvirt-dbus" { };
  };

  config = lib.mkIf cfg.enable {
    # Enables the libvirt-dbus.service systemd service.
    systemd.packages = [ cfg.package ];

    # Enables the org.libvirt D-Bus service.
    environment.systemPackages = [ cfg.package ];

    users = {
      users.libvirtdbus = {
        isSystemUser = true;
        group = "libvirtdbus";
        description = "Libvirt D-Bus bridge";
      };
      groups.libvirtdbus = { };
    };
  };

  meta.maintainers = with lib.maintainers; [ andre4ik3 ];
}
