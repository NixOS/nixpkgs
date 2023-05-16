{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.xserver.windowManager.dwm;

in

{

  ###### interface

  options = {
    services.xserver.windowManager.dwm = {
      enable = mkEnableOption (lib.mdDoc "dwm");
      package = mkOption {
        type        = types.package;
        default     = pkgs.dwm;
        defaultText = literalExpression "pkgs.dwm";
        example     = literalExpression ''
          pkgs.dwm.overrideAttrs (oldAttrs: rec {
            patches = [
              (super.fetchpatch {
                url = "https://dwm.suckless.org/patches/steam/dwm-steam-6.2.diff";
<<<<<<< HEAD
                sha256 = "sha256-f3lffBjz7+0Khyn9c9orzReoLTqBb/9gVGshYARGdVc=";
=======
                sha256 = "1ld1z3fh6p5f8gr62zknx3axsinraayzxw3rz1qwg73mx2zk5y1f";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
              })
            ];
          })
        '';
        description = lib.mdDoc ''
          dwm package to use.
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
<<<<<<< HEAD
            export _JAVA_AWT_WM_NONREPARENTING=1
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
            dwm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ cfg.package ];

  };

}
