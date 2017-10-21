{ config, lib, pkgs, ... }:

with lib;

{

  ###### implementation

  config = mkIf (!config.boot.isContainer) {

    environment.systemPackages = [ pkgs.lvm2 ];

    services.udev.packages = [ pkgs.lvm2 ];

  };

}
