# GVfs

{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.gvfs;

in

{

  meta = {
    maintainers = teams.gnome.members;
  };

  # Added 2019-08-19
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gvfs" "enable" ]
      [ "services" "gvfs" "enable" ])
  ];

  ###### interface

  options = {

    services.gvfs = {

      enable = mkEnableOption (lib.mdDoc "GVfs, a userspace virtual filesystem");

      # gvfs can be built with multiple configurations
      package = mkPackageOption pkgs [ "gnome" "gvfs" ] { };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ cfg.package ];

    services.dbus.packages = [ cfg.package ];

    systemd.packages = [ cfg.package ];

    services.udev.packages = [ pkgs.libmtp.out ];

    services.udisks2.enable = true;

    # Needed for unwrapped applications
    environment.sessionVariables.GIO_EXTRA_MODULES = [ "${cfg.package}/lib/gio/modules" ];

  };

}
