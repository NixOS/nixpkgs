{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
  cfg = wmcfg.icewm;
in
{
  ###### implementation
  config = mkIf (elem "icewm" wmcfg.enable) {
    services.xserver.windowManager.session = singleton
      { name = "icewm";
        start =
          ''
            ${pkgs.icewm}/bin/icewm &
            waitPID=$!
          '';
      };

    environment.systemPackages = [ pkgs.icewm ];
  };
}
