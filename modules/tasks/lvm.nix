{ config, pkgs, ... }:

{

  ###### implementation

  config = {

    environment.systemPackages = [ pkgs.lvm2 ];

    services.udev.packages = [ pkgs.lvm2 ];

  };

}
