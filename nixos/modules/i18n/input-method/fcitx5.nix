{ config, pkgs, lib, ... }:
let
  imcfg = config.i18n.inputMethod;
  cfg = imcfg.fcitx5;
  fcitx5Package =
    if cfg.plasma6Support
    then pkgs.qt6Packages.fcitx5-with-addons.override { inherit (cfg) addons; }
    else pkgs.libsForQt5.fcitx5-with-addons.override { inherit (cfg) addons; };
  settingsFormat = pkgs.formats.ini { };
  settingsFormatWithGlobalSection = pkgs.formats.iniWithGlobalSection { };
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
            The global options in `config` file in INI format.
          '';
        };
        inputMethod = lib.mkOption {
          type = lib.types.submodule {
            freeformType = settingsFormat.type;
          };
          default = { };
          description = ''
            The input method configure in `profile` file in INI format.
          '';
        };
        addons = lib.mkOption {
          type = with lib.types; (attrsOf settingsFormatWithGlobalSection.type);
          default = { };
          description = ''
            The addon configures in `conf` folder in INI format with global sections.
            Each item is written to the corresponding file.
          '';
          example = lib.literalExpression "{ pinyin.globalSection.EmojiEnabled = \"True\"; }";
        };
        tables = lib.mkOption {
          type = with lib.types; (attrsOf settingsFormat.type);
          default = { };
          description = ''
            The configuration for tables, used for input methods that map sequences of key presses
            into characters, in INI format.
            Each item is written to the corresponding file.
          '';
          example = literalExpression ''{ cangjie5.MatchingKey = "z"; }'';
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
          "xdg/fcitx5/${p}".source = f.generate p v;
        };
      in
      lib.attrsets.mergeAttrsList [
        (optionalFile "config" settingsFormat cfg.settings.globalOptions)
        (optionalFile "profile" settingsFormat cfg.settings.inputMethod)
        (lib.concatMapAttrs
          (name: optionalFile "conf/${name}.conf" settingsFormatWithGlobalSection)
          cfg.settings.addons)
        (lib.concatMapAttrs
          (name: optionalFile "table/${name}.conf" settingsFormat)
          cfg.settings.tables)
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
