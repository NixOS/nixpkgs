{ config, pkgs, lib, ... }:

with lib;

let 
  cfg = config.i18n.inputMethod.uim;
in
{
  options = {

    i18n.inputMethod.uim = {
      enable = mkOption {
        type    = types.bool;
        default = false;
        example = true;
        description = ''
          Enable uim input method.
          Uim can be used to input of Chinese, Korean, Japanese and other special characters.
        '';
      };
      toolbar = mkOption {
        type    = types.enum [ "gtk" "gtk3" "gtk-systray" "gtk3-systray" "qt4" ];
        default = "gtk";
        example = "gtk-systray";
        description = ''
          selected UIM toolbar.
        '';
      };
    };

  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.uim ];
    gtkPlugins = [ pkgs.uim ];
    qtPlugins  = [ pkgs.uim ];

    environment.variables = {
      GTK_IM_MODULE = "uim";
      QT_IM_MODULE  = "uim";
      XMODIFIERS    = "@im=uim";
    };
    services.xserver.displayManager.sessionCommands = ''
      ${pkgs.uim}/bin/uim-xim &
      ${pkgs.uim}/bin/uim-toolbar-${cfg.toolbar} &
    '';
  };
}
