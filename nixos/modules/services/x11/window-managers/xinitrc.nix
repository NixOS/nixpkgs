{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.windowManager.xinitrc;
in

{
  options = {
    services.xserver.windowManager.xinitrc = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "Run the users's .xinitrc";
      };
    };
  };

  config = mkIf cfg.enable {
    services.xserver.windowManager.session = singleton {
      name = "xinitrc";
      start = ''
        $HOME/.xinitrc &
        waitPID=$!
      '';
    };
  };
}
