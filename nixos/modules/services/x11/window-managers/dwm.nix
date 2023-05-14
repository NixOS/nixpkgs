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
                sha256 = "1ld1z3fh6p5f8gr62zknx3axsinraayzxw3rz1qwg73mx2zk5y1f";
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
            dwm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ cfg.package ];

  };

}
