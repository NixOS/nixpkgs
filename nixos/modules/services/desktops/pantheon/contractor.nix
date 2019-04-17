# Contractor

{ config, pkgs, lib, ... }:

with lib;

{

  meta.maintainers = pkgs.pantheon.maintainers;

  ###### interface

  options = {

    services.pantheon.contractor = {

      enable = mkEnableOption "contractor, a desktop-wide extension service used by pantheon";

    };

  };


  ###### implementation

  config = mkIf config.services.pantheon.contractor.enable {

    environment.systemPackages = with  pkgs.pantheon; [
      contractor
      extra-elementary-contracts
    ];

    services.dbus.packages = [ pkgs.pantheon.contractor ];

    environment.pathsToLink = [
      "/share/contractor"
    ];

  };

}
