# Malcontent daemon.

{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.malcontent = {

      enable = mkEnableOption "Malcontent, parental control support for applications";

    };

  };


  ###### implementation

  config = mkIf config.services.malcontent.enable {

    environment.systemPackages = with pkgs; [
      malcontent
      malcontent-ui
    ];

    services.dbus.packages = [ pkgs.malcontent ];

    services.accounts-daemon.enable = true;

  };

}
