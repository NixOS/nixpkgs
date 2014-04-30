{ config, pkgs, ... }:

with pkgs.lib;

let
  cfg = config.programs.uim;
in
{
  options = {
    programs.uim = {
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
    gtk2ImModules = [ "${pkgs.uim}/lib/gtk-2.0/2.10.0/immodules/*.so" ];
    gtk3ImModules = [ "${pkgs.uim}/lib/gtk-3.0/3.0.0/immodules/*.so" ];
    environment.variables.GTK_IM_MODULES = "uim";
    environment.variables.QT_IM_MODULES = "uim";
    environment.variables.XMODIFIERS = "@im=uim";
    services.xserver.displayManager.sessionCommands = "uim-xim &";
  };
}
