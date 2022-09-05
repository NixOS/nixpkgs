{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.icewm;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.icewm.enable = mkEnableOption (lib.mdDoc "icewm");
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

    environment.systemPackages = [ pkgs.icewm ];
  };
}
