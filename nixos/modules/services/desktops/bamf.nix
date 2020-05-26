# Bamf

{ config, lib, pkgs, ... }:

with lib;

{
  meta = {
    maintainers = with maintainers; [ worldofpeace ];
  };

  ###### interface

  options = {
    services.bamf = {
      enable = mkEnableOption "bamf";
    };
  };

  ###### implementation

  config = mkIf config.services.bamf.enable {
    services.dbus.packages = [ pkgs.bamf ];

    systemd.packages = [ pkgs.bamf ];
  };
}
