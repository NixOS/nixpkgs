{
  config,
  pkgs,
  lib,
  ...
}:

with lib;
let
  imcfg = config.i18n.inputMethod;
in
{
  config = mkIf (imcfg.enable && imcfg.type == "nabi") {
    i18n.inputMethod.package = pkgs.nabi;

    environment.variables = {
      GTK_IM_MODULE = "nabi";
      QT_IM_MODULE = "nabi";
      XMODIFIERS = "@im=nabi";
    };

    services.xserver.displayManager.sessionCommands = "${pkgs.nabi}/bin/nabi &";
  };
}
