{ config, pkgs, pkgs_multiarch, lib, ... }:

with lib;

let
  cfg = config.i18n.inputMethod.fcitx;
  fcitxPackage = system: pkgs_multiarch.fcitx.${system}.override { plugins = map (es: es.${system}) cfg.engines; };
  fcitxEngines = types.listOf (types.attrsOf (types.package // {
    name  = "fcitxEngine";
    check = x: attrByPath ["meta" "isFcitxEngine"] false x;
  }));
in
{
  options = {

    i18n.inputMethod.fcitx = {
      engines = mkOption {
        type    = fcitxEngines;
        default = [];
        example = literalExample "with pkgs_multiarch.fcitx-engines; [ mozc hangul ]";
        description =
          let
            enginesDrv = filterAttrs (const isDerivation) pkgs.fcitx-engines;
            engines = concatStringsSep ", "
              (map (name: "<literal>${name}</literal>") (attrNames enginesDrv));
          in
            "Enabled Fcitx engines. Available engines are: ${engines}.";
      };
    };

  };

  config = mkIf (config.i18n.inputMethod.enabled == "fcitx") {
    i18n.inputMethod.package = mapAttrs (name: stdenv: fcitxPackage stdenv.system) pkgs_multiarch.stdenv;

    environment.variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE  = "fcitx";
      XMODIFIERS    = "@im=fcitx";
    };
    services.xserver.displayManager.sessionCommands = "${fcitxPackage pkgs.stdenv.system}/bin/fcitx";
  };
}
