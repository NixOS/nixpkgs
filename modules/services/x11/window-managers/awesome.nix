{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.xserver.windowManager.awesome;

in

{

  ###### interface

  options = {

    services.xserver.windowManager.awesome.enable = mkOption {
      default = false;
      description = "Enable the Awesome window manager.";
    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "awesome";
        start =
          ''
            ${pkgs.awesome}/bin/awesome &
            waitPID=$!
          '';
      };

    environment.x11Packages = [ pkgs.awesome ];

  };

}
