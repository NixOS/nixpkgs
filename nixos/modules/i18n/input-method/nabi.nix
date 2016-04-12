{ config, pkgs, lib, ... }:

with lib;
{
  config = mkIf (config.i18n.inputMethod.enabled == "nabi") {
    environment.systemPackages = [ pkgs.nabi ];

    environment.variables = {
      GTK_IM_MODULE = "nabi";
      QT_IM_MODULE  = "nabi";
      XMODIFIERS    = "@im=nabi";
    };

    services.xserver.displayManager.sessionCommands = "${pkgs.nabi}/bin/nabi &";
  };
}
