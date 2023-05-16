{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.i18n.inputMethod.uim;
in
{
  options = {

    i18n.inputMethod.uim = {
      toolbar = mkOption {
<<<<<<< HEAD
        type    = types.enum [ "gtk" "gtk3" "gtk-systray" "gtk3-systray" "qt5" ];
=======
        type    = types.enum [ "gtk" "gtk3" "gtk-systray" "gtk3-systray" "qt4" ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
        default = "gtk";
        example = "gtk-systray";
        description = lib.mdDoc ''
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
