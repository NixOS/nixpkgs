{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.xserver.windowManager.icewm;

in

{

  ###### interface

  options = {
  
    services.xserver.windowManager.icewm.enable = mkOption {
      default = false;
      description = "Enable the IceWM window manager.";
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "icewm";
        start =
          ''
            ${pkgs.icewm}/bin/icewm &
            waitPID=$!
          '';
      };

    environment.x11Packages = [ pkgs.icewm ];
    
  };

}
