# pantheon files daemon.

{ config, pkgs, lib, ... }:

with lib;

{

  meta.maintainers = pkgs.pantheon.maintainers;

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
