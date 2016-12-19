{ config, pkgs, lib, ... }:

with lib;

let 
  cfg = config.i18n.inputMethod.uim;
in
{
  options = {

    i18n.inputMethod.uim = {
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

  config = mkIf (config.i18n.inputMethod.enabled == "uim") {
    i18n.inputMethod.package = pkgs.uim;

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
