{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.desktopManager.cinnamon;
in

{

  options = {
    services.xserver.desktopManager.cinnamon = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Enable the Cinnamon desktop environment.";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs.cinnamon // pkgs; [

    ]

    environment.pathsToLink = [

    ];

    services.xserver.desktopManager.session = [{
      name = "cinnamon";
      bgSupport = true;
      start = ''
        ${pkgs.runtimeShell} # TODO &
        waitPID=$!
      '';
    }];
  };
}
