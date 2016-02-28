{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.i18n.inputMethod.fcitx;
  fcitxPackage = pkgs.fcitx-with-plugins.override { plugins = cfg.engines; };
  fcitxEngine = types.package // {
    name  = "fcitx-engine";
    check = x: (lib.types.package.check x) && (attrByPath ["meta" "isFcitxEngine"] false x);
  };
in
{
  options = {

    i18n.inputMethod.fcitx = {
      engines = mkOption {
        type    = with types; listOf fcitxEngine;
        default = [];
        example = literalExample "with pkgs.fcitx-engines; [ mozc hangul ]";
        description =
          let
            engines =
              lib.concatStringsSep ", "
              (map (name: "<literal>${name}</literal>")
               (lib.attrNames pkgs.fcitx-engines));
          in
            "Enabled Fcitx engines. Available engines are: ${engines}.";
      };
    };

  };

  config = mkIf (config.i18n.inputMethod.enabled == "fcitx") {
    environment.systemPackages = [ fcitxPackage ];

    environment.variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE  = "fcitx";
      XMODIFIERS    = "@im=fcitx";
    };
    services.xserver.displayManager.sessionCommands = "${fcitxPackage}/bin/fcitx";
  };
}
