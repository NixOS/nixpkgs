{ config, pkgs, lib, ... }:

with lib;

let
  im = config.i18n.inputMethod;
  cfg = im.fcitx5;
  rimeEnabled = any (p: p.pname == "fcitx5-rime") cfg.addons;
  addons = cfg.addons ++ (if rimeEnabled then im.rime.packages else []);
  fcitx5Package = pkgs.fcitx5-with-addons.override { inherit addons; };
in
{
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
    };
  };

  config = mkIf (im.enabled == "fcitx5") {
    i18n.inputMethod.package = fcitx5Package;

    environment.variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      QT_PLUGIN_PATH = [ "${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
    };

    i18n.inputMethod.rime.packages = lib.mkIf rimeEnabled [
      pkgs.fcitx5-rime # fcitx5-rime contains rime data fcitx5.yaml
    ];
  };
}
