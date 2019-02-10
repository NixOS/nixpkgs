# pantheon files daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  ###### interface

  options = {

    services.pantheon.files = {

      enable = mkEnableOption "pantheon files daemon";

    };

  };


  ###### implementation

  config = mkIf config.services.pantheon.files.enable {

    environment.systemPackages = [
      pkgs.pantheon.elementary-files
    ];

    services.dbus.packages = [
      pkgs.pantheon.elementary-files
    ];

  };

}
