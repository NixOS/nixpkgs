{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.dwm;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.dwm = {
      enable = mkEnableOption "dwm";

      package = mkOption {
        type = types.package;
        default = pkgs.dwm;
        example = ''
          pkgs.dwm.override {
            patches = [
              my_patch_1
              my_patch_2
            ];
          }
        '';
        description = "dwm package to use.";
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "dwm";
        start =
          ''
            dwm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ cfg.package ];

  };

}
