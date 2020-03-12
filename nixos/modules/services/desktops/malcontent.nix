# Malcontent daemon.

{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.malcontent = {

      enable = mkEnableOption "Malcontent";

    };

  };


  ###### implementation

  config = mkIf config.services.malcontent.enable {

    environment.systemPackages = [ pkgs.malcontent ];

    services.dbus.packages = [ pkgs.malcontent ];

  };

}
