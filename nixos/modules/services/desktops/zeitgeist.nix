# Zeitgeist

{ config, lib, pkgs, ... }:

with lib;

{
  ###### interface

  options = {
    services.zeitgeist = {
      enable = mkEnableOption "zeitgeist";
    };
  };

  ###### implementation

  config = mkIf config.services.zeitgeist.enable {

    environment.systemPackages = [ pkgs.zeitgeist ];

    services.dbus.packages = [ pkgs.zeitgeist ];

    systemd.packages = [ pkgs.zeitgeist ];
  };
}
