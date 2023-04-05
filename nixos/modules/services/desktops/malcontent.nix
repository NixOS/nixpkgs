# Malcontent daemon.

{ config, lib, pkgs, ... }:

with lib;

{

  ###### interface

  options = {

    services.malcontent = {

      enable = mkEnableOption (lib.mdDoc "Malcontent, parental control support for applications");

    };

  };


  ###### implementation

  config = mkIf config.services.malcontent.enable {

    environment.systemPackages = with pkgs; [
      malcontent
      malcontent-ui
    ];

    services.dbus.packages = [
      # D-Bus services are in `out`, not the default `bin` output that would be picked up by `makeDbusConf`.
      pkgs.malcontent.out
    ];

    services.accounts-daemon.enable = true;

  };

}
