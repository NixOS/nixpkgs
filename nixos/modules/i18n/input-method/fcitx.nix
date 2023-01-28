{ config, pkgs, lib, ... }:

with lib;

let
  cfg = config.i18n.inputMethod.fcitx;
  fcitxPackage = pkgs.fcitx.override { plugins = cfg.engines; };
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
        example = literalExpression "with pkgs.fcitx-engines; [ mozc hangul ]";
        description =
          let
            enginesDrv = filterAttrs (const isDerivation) pkgs.fcitx-engines;
            engines = concatStringsSep ", "
              (map (name: "`${name}`") (attrNames enginesDrv));
          in
            lib.mdDoc "Enabled Fcitx engines. Available engines are: ${engines}.";
      };
    };

  };

  config = mkIf (config.i18n.inputMethod.enabled == "fcitx") {
    i18n.inputMethod.package = fcitxPackage;

    environment.variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE  = "fcitx";
      XMODIFIERS    = "@im=fcitx";
    };
    services.xserver.displayManager.sessionCommands = "${fcitxPackage}/bin/fcitx";
  };

  # uses attributes of the linked package
  meta.buildDocsInSandbox = false;
}
