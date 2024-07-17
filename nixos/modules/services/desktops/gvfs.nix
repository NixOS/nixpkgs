# GVfs

{
  config,
  lib,
  pkgs,
  ...
}:

let

  cfg = config.services.gvfs;

in

{

  meta = {
    maintainers = lib.teams.gnome.members;
  };

  ###### interface

  options = {

    services.gvfs = {

      enable = lib.mkEnableOption "GVfs, a userspace virtual filesystem";

      # gvfs can be built with multiple configurations
      package = lib.mkPackageOption pkgs [
        "gnome"
        "gvfs"
      ] { };

    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    services.udev.packages = [ pkgs.libmtp.out ];

    services.udisks2.enable = true;

    # Needed for unwrapped applications
    environment.sessionVariables.GIO_EXTRA_MODULES = [ "${cfg.package}/lib/gio/modules" ];

  };

}
