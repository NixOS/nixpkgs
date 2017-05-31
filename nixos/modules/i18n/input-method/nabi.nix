{ config, pkgs, pkgs_multiarch, lib, ... }:

with lib;
{
  config = mkIf (config.i18n.inputMethod.enabled == "nabi") {
    i18n.inputMethod.package = pkgs_multiarch.nabi;

    environment.variables = {
      GTK_IM_MODULE = "nabi";
      QT_IM_MODULE  = "nabi";
      XMODIFIERS    = "@im=nabi";
    };

    services.xserver.displayManager.sessionCommands = "${pkgs.nabi}/bin/nabi &";
  };
}
