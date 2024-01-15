# neard service.
{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface
  options = {
    services.neard = {
      enable = mkEnableOption (lib.mdDoc "neard, NFC daemon");
    };
  };


  ###### implementation
  config = mkIf config.services.neard.enable {
    environment.systemPackages = [ pkgs.neard ];

    services.dbus.packages = [ pkgs.neard ];

    systemd.packages = [ pkgs.neard ];
  };
}
