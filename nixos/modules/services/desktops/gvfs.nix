# GVfs

{ config, lib, pkgs, ... }:

with lib;

{

  # Added 2019-08-19
  imports = [
    (mkRenamedOptionModule
      [ "services" "gnome3" "gvfs" "enable" ]
      [ "services" "gvfs" "enable" ])
  ];

  ###### interface

  options = {

    services.gvfs = {

      enable = mkEnableOption "GVfs, a userspace virtual filesystem";

    };

  };


  ###### implementation

  config = mkIf config.services.gvfs.enable {

    environment.systemPackages = [ pkgs.gnome3.gvfs ];

    services.dbus.packages = [ pkgs.gnome3.gvfs ];

    systemd.packages = [ pkgs.gnome3.gvfs ];

    services.udev.packages = [ pkgs.libmtp.bin ];

  };

}
