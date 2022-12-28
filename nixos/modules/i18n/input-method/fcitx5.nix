{ config, pkgs, lib, ... }:

with lib;

let
  im = config.i18n.inputMethod;
  cfg = im.fcitx5;
  addons = cfg.addons ++ optional cfg.enableRimeData pkgs.rime-data;
  fcitx5Package = pkgs.fcitx5-with-addons.override { inherit addons; };
  whetherRimeDataDir = any (p: p.pname == "fcitx5-rime") cfg.addons;
in {
  options = {
    i18n.inputMethod.fcitx5 = {
      addons = mkOption {
        type = with types; listOf package;
        default = [];
        example = literalExpression "with pkgs; [ fcitx5-rime ]";
        description = lib.mdDoc ''
          Enabled Fcitx5 addons.
        '';
      };

      enableRimeData = mkEnableOption (lib.mdDoc "default rime-data with fcitx5-rime");
    };
  };

  config = mkIf (im.enabled == "fcitx5") {
    i18n.inputMethod.package = fcitx5Package;

    environment = mkMerge [{
      variables = {
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
        QT_PLUGIN_PATH = [ "${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
      };
    }
    (mkIf whetherRimeDataDir {
      pathsToLink = [
        "/share/rime-data"
      ];

      variables =  {
        NIX_RIME_DATA_DIR = "/run/current-system/sw/share/rime-data";
      };
    })];
  };
}
