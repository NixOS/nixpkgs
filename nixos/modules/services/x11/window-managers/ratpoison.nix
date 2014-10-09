{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.ratpoison;
in
{
  ###### interface
  options = {
    services.xserver.windowManager.ratpoison.enable = mkOption {
      default = false;
      description = "Enable the Ratpoison window manager.";
    };
  };

  ###### implementation
  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "ratpoison";
      start = ''
        ${pkgs.ratpoison}/bin/ratpoison &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.ratpoison ];
  };
}
