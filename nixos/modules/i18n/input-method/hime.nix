{ config, pkgs, ... }:

with lib;
{
  options = {
    i18n.inputMethod.hime = {
      enableChewing = mkOption {
        type    =  with types; nullOr bool;
        default = null;
        description = "enable chewing input method";
      };
      enableAnthy = mkOption {
        type    =  with types; nullOr bool;
        default = null;
        description = "enable anthy input method";
      };
    };
  };

  config = mkIf (config.i18n.inputMethod.enabled == "hime") {
    environment.variables = {
      GTK_IM_MODULE = "hime";
      QT_IM_MODULE  = "hime";
      XMODIFIERS    = "@im=hime";
    };
    services.xserver.displayManager.sessionCommands = "${pkgs.hime}/bin/hime &";
  };
}
