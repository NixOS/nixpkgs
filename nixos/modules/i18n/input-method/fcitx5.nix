{ config, pkgs, lib, ... }:
let
  imcfg = config.i18n.inputMethod;
  cfg = imcfg.fcitx5;
  fcitx5Package =
    if cfg.plasma6Support
    then pkgs.qt6Packages.fcitx5-with-addons.override { inherit (cfg) addons; }
    else pkgs.libsForQt5.fcitx5-with-addons.override { inherit (cfg) addons; };
  settingsFormat = pkgs.formats.ini { };
in
{
  options = {
    i18n.inputMethod.fcitx5 = {
      addons = lib.mkOption {
        type = with lib.types; listOf package;
        default = [ ];
        example = lib.literalExpression "with pkgs; [ fcitx5-rime ]";
        description = ''
          Enabled Fcitx5 addons.
        '';
      };
      waylandFrontend = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Use the Wayland input method frontend.
          See [Using Fcitx 5 on Wayland](https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland).
        '';
      };
      plasma6Support = lib.mkOption {
        type = lib.types.bool;
        default = config.services.desktopManager.plasma6.enable;
        defaultText = lib.literalExpression "config.services.desktopManager.plasma6.enable";
        description = ''
          Use qt6 versions of fcitx5 packages.
          Required for configuring fcitx5 in KDE System Settings.
        '';
      };
      quickPhrase = lib.mkOption {
        type = with lib.types; attrsOf str;
        default = { };
        example = lib.literalExpression ''
          {
            smile = "（・∀・）";
            angry = "(￣ー￣)";
          }
        '';
        description = "Quick phrases.";
      };
      quickPhraseFiles = lib.mkOption {
        type = with lib.types; attrsOf path;
        default = { };
        example = lib.literalExpression ''
          {
            words = ./words.mb;
            numbers = ./numbers.mb;
          }
        '';
        description = "Quick phrase files.";
      };
      settings = {
        globalOptions = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;
          };
          default = { };
          description = ''
            The global options in `config` file in ini format.
          '';
        };
        inputMethod = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;
          };
          default = { };
          description = ''
            The input method configure in `profile` file in ini format.
          '';
        };
        addons = lib.mkOption {
          type = with lib.types; (attrsOf anything);
          default = { };
          description = ''
            The addon configures in `conf` folder in ini format with global sections.
            Each item is written to the corresponding file.
          '';
          example = lib.literalExpression "{ pinyin.globalSection.EmojiEnabled = \"True\"; }";
        };
      };
      ignoreUserConfig = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = ''
          Ignore the user configures. **Warning**: When this is enabled, the
          user config files are totally ignored and the user dict can't be saved
          and loaded.
        '';
      };
    };
  };

  imports = [
    (lib.mkRemovedOptionModule [ "i18n" "inputMethod" "fcitx5" "enableRimeData" ] ''
      RIME data is now included in `fcitx5-rime` by default, and can be customized using `fcitx5-rime.override { rimeDataPkgs = ...; }`
    '')
  ];

  config = lib.mkIf (imcfg.enable && imcfg.type == "fcitx5") {
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
    environment.etc =
      let
        optionalFile = p: f: v: lib.optionalAttrs (v != { }) {
          "xdg/fcitx5/${p}".text = f v;
        };
      in
      lib.attrsets.mergeAttrsList [
        (optionalFile "config" (lib.generators.toINI { }) cfg.settings.globalOptions)
        (optionalFile "profile" (lib.generators.toINI { }) cfg.settings.inputMethod)
        (lib.concatMapAttrs
          (name: value: optionalFile
            "conf/${name}.conf"
            (lib.generators.toINIWithGlobalSection { })
            value)
          cfg.settings.addons)
      ];

    environment.variables = {
      XMODIFIERS = "@im=fcitx";
      QT_PLUGIN_PATH = [ "${fcitx5Package}/${pkgs.qt6.qtbase.qtPluginPrefix}" ];
    } // lib.optionalAttrs (!cfg.waylandFrontend) {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
    } // lib.optionalAttrs cfg.ignoreUserConfig {
      SKIP_FCITX_USER_PATH = "1";
    };
  };
}
