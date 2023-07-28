{ config, pkgs, lib, ... }:

with lib;

let
  im = config.i18n.inputMethod;
  cfg = im.fcitx5;
  fcitx5Package = pkgs.fcitx5-with-addons.override { inherit (cfg) addons; };
in
{
  options = {
    i18n.inputMethod.fcitx5 = {
      addons = mkOption {
        type = with types; listOf package;
        default = [ ];
        example = literalExpression "with pkgs; [ fcitx5-rime ]";
        description = lib.mdDoc ''
          Enabled Fcitx5 addons.
        '';
      };
      quickPhrase = mkOption {
        type = with types; attrsOf string;
        default = { };
        example = literalExpression ''
          {
            smile = "（・∀・）";
            angry = "(￣ー￣)";
          }
        '';
        description = lib.mdDoc "Quick phrases.";
      };
      quickPhraseFiles = mkOption {
        type = with types; attrsOf path;
        default = { };
        example = literalExpression ''
          {
            words = ./words.mb;
            numbers = ./numbers.mb;
          }
        '';
        description = lib.mdDoc "Quick phrase files.";
      };
    };
  };

  imports = [
    (mkRemovedOptionModule [ "i18n" "inputMethod" "fcitx5" "enableRimeData" ] ''
      RIME data is now included in `fcitx5-rime` by default, and can be customized using `fcitx5-rime.override { rimeDataPkgs = ...; }`
    '')
  ];

  config = mkIf (im.enabled == "fcitx5") {
    i18n.inputMethod.package = fcitx5Package;

    i18n.inputMethod.fcitx5.addons = lib.optionals (cfg.quickPhrase != { }) [
      (pkgs.writeTextDir "share/fcitx5/data/QuickPhrase.mb"
        (lib.concatStringsSep "\n"
          (lib.mapAttrsToList (name: value: "${name} ${value}") cfg.quickPhrase)))
    ] ++ lib.optionals (cfg.quickPhraseFiles != { }) [
      (pkgs.linkFarm "quickPhraseFiles" (lib.mapAttrs'
        (name: value: lib.nameValuePair ("share/fcitx5/data/quickphrase.d/${name}.mb") value)
        cfg.quickPhraseFiles))
    ];

    environment.variables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
      QT_PLUGIN_PATH = [ "${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
    };
  };
}
