# Ofono daemon.
{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface
  options = {
    services.ofono = {
      enable = mkEnableOption "Ofono";
    };
  };

  ###### implementation
  config = mkIf config.services.ofono.enable {
    services.dbus.packages = [ pkgs.ofono ];

    systemd.packages = [ pkgs.ofono ];
  };
}
