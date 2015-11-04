{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.clfswm;
in

{
  options = {
    services.xserver.windowManager.clfswm = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Enable the clfswm tiling window manager.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "clfswm";
      start = ''
        ${pkgs.clfswm}/bin/clfswm &
        waitPID=$!
      '';
    };
    environment.systemPackages = [ pkgs.clfswm ];
  };
}
