{ config, lib, pkgs, ... }:

with lib;

let
  wmcfg = config.services.xserver.windowManager;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.select = mkOption {
      type = with types; listOf (enum [ "icewm" ]);
    };
  };

  ###### implementation
  config = mkIf (elem "icewm" wmcfg.select) {
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
