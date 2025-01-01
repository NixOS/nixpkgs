{ config, pkgs, lib, ... }:
let
  cfg = config.i18n.inputMethod;

  allowedTypes = lib.types.enum [ "ibus" "fcitx5" "nabi" "uim" "hime" "kime" ];

  gtk2_cache = pkgs.runCommand "gtk2-immodule.cache"
    { preferLocalBuild = true;
      allowSubstitutes = false;
      buildInputs = [ pkgs.gtk2 cfg.package ];
    }
    ''
      mkdir -p $out/etc/gtk-2.0/
      GTK_PATH=${cfg.package}/lib/gtk-2.0/ gtk-query-immodules-2.0 > $out/etc/gtk-2.0/immodules.cache
    '';

  gtk3_cache = pkgs.runCommand "gtk3-immodule.cache"
    { preferLocalBuild = true;
      allowSubstitutes = false;
      buildInputs = [ pkgs.gtk3 cfg.package ];
    }
    ''
      mkdir -p $out/etc/gtk-3.0/
      GTK_PATH=${cfg.package}/lib/gtk-3.0/ gtk-query-immodules-3.0 > $out/etc/gtk-3.0/immodules.cache
    '';

in
{
  options.i18n = {
    inputMethod = {
      enable = lib.mkEnableOption "an additional input method type" // {
        default = cfg.enabled != null;
        defaultText = lib.literalMD "`true` if the deprecated option `enabled` is set, false otherwise";
      };

      enabled = lib.mkOption {
        type    = lib.types.nullOr allowedTypes;
        default = null;
        example = "fcitx5";
        description = "Deprecated - use `type` and `enable = true` instead";
      };

      type = lib.mkOption {
        type    = lib.types.nullOr allowedTypes;
        default = cfg.enabled;
        defaultText = lib.literalMD "The value of the deprecated option `enabled`, defaulting to null";
        example = "fcitx5";
        description = ''
          Select the enabled input method. Input methods is a software to input symbols that are not available on standard input devices.

          Input methods are specially used to input Chinese, Japanese and Korean characters.

          Currently the following input methods are available in NixOS:

          - ibus: The intelligent input bus, extra input engines can be added using `i18n.inputMethod.ibus.engines`.
          - fcitx5: The next generation of fcitx, addons (including engines, dictionaries, skins) can be added using `i18n.inputMethod.fcitx5.addons`.
          - nabi: A Korean input method based on XIM. Nabi doesn't support Qt 5.
          - uim: The universal input method, is a library with a XIM bridge. uim mainly support Chinese, Japanese and Korean.
          - hime: An extremely easy-to-use input method framework.
          - kime: Koream IME.
        '';
      };

      package = lib.mkOption {
        internal = true;
        type     = lib.types.nullOr lib.types.path;
        default  = null;
        description = ''
          The input method method package.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optional (cfg.enabled != null) "i18n.inputMethod.enabled will be removed in a future release. Please use .type, and .enable = true instead";
    environment.systemPackages = [ cfg.package gtk2_cache gtk3_cache ];
  };

  meta = {
    maintainers = with lib.maintainers; [ ericsagnes ];
    doc = ./default.md;
  };

}
