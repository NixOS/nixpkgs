# neard service.
{ config, lib, pkgs, ... }:
{
  ###### interface
  options = {
    services.neard = {
      enable = lib.mkEnableOption "neard, an NFC daemon";
    };
  };


  ###### implementation
  config = lib.mkIf config.services.neard.enable {
    environment.systemPackages = [ pkgs.neard ];

    services.dbus.packages = [ pkgs.neard ];

    systemd.packages = [ pkgs.neard ];
  };
}
