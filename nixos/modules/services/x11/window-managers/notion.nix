{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.notion;
in

{
  options = {
    services.xserver.windowManager.notion = {
      enable = mkOption {
        default = false;
        example = true;
        description = "Enable the notion tiling window manager.";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager = {
      session = [{
        name = "notion";
        start = ''
          ${pkgs.notion}/bin/notion &
          waitPID=$!
        '';
      }];
    };
    environment.systemPackages = [ pkgs.notion ];
  };
}
