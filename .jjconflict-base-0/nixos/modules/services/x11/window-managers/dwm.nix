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
      package = mkPackageOption pkgs "dwm" {
        example = ''
          pkgs.dwm.overrideAttrs (oldAttrs: rec {
            patches = [
              (super.fetchpatch {
                url = "https://dwm.suckless.org/patches/steam/dwm-steam-6.2.diff";
                sha256 = "sha256-f3lffBjz7+0Khyn9c9orzReoLTqBb/9gVGshYARGdVc=";
              })
            ];
          })
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable {

    services.xserver.windowManager.session = singleton
      { name = "dwm";
        start =
          ''
            export _JAVA_AWT_WM_NONREPARENTING=1
            dwm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ cfg.package ];

  };

}
