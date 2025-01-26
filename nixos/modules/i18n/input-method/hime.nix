{
  config,
  pkgs,
  lib,
  ...
}:
let
  imcfg = config.i18n.inputMethod;
in
{
  config = lib.mkIf (imcfg.enable && imcfg.type == "hime") {
    i18n.inputMethod.package = pkgs.hime;
    environment.variables = {
      GTK_IM_MODULE = "hime";
      QT_IM_MODULE = "hime";
      XMODIFIERS = "@im=hime";
    };
    services.xserver.displayManager.sessionCommands = "${pkgs.hime}/bin/hime &";
  };
}
