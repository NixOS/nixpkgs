{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
{
  config = mkIf (config.i18n.inputMethod.enabled == "hime") {
    i18n.inputMethod.package = pkgs.hime;
    environment.variables = {
      GTK_IM_MODULE = "hime";
      QT_IM_MODULE = "hime";
      XMODIFIERS = "@im=hime";
    };
    services.xserver.displayManager.sessionCommands = "${pkgs.hime}/bin/hime &";
  };
}
