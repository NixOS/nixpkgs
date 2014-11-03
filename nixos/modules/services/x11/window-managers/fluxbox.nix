{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.fluxbox;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.fluxbox.enable = mkOption {
      default = false;
      description = "Enable the Fluxbox window manager.";
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "fluxbox";
      start = ''
        ${pkgs.fluxbox}/bin/startfluxbox &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.fluxbox ];
  };
}
