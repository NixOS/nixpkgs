# blueman service
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.blueman;
in {
  ###### interface
  options = {
    services.blueman = {
      enable = mkEnableOption (lib.mdDoc "blueman");
    };
  };

  ###### implementation
  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.blueman ];

    services.dbus.packages = [ pkgs.blueman ];

    systemd.packages = [ pkgs.blueman ];
  };
}
