{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.sawfish;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.sawfish.enable = mkOption {
      default = false;
      description = "Enable the Sawfish window manager.";
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "sawfish";
      start = ''
        ${pkgs.sawfish}/bin/sawfish &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.sawfish ];
  };
}
