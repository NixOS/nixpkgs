{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.uim;
in
{
  options = {
    uim = {
      enable = mkOption {
        type = types.bool;
        default = false;
        example = true;
        description = "enable UIM input method";
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.uim ];
    gtkPlugins = [ pkgs.uim ];
    qtPlugins = [ pkgs.uim ];
    environment.variables.GTK_IM_MODULE = "uim";
    environment.variables.QT_IM_MODULE = "uim";
    environment.variables.XMODIFIERS = "@im=uim";
    services.xserver.displayManager.sessionCommands = "uim-xim &";
  };
}
