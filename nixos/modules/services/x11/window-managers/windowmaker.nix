{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.windowmaker;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.windowmaker.enable = mkOption {
      default = false;
      description = "Enable the Windowmaker window manager.";
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "windowmaker";
      start = ''
        ${pkgs.windowmaker}/bin/wmaker &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.windowmaker ];
  };
}
