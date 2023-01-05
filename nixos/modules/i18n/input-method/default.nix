{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.i18n.inputMethod;

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
      enabled = mkOption {
        type    = types.nullOr (types.enum [ "ibus" "fcitx" "fcitx5" "nabi" "uim" "hime" "kime" ]);
        default = null;
        example = "fcitx";
        description = lib.mdDoc ''
          Select the enabled input method. Input methods is a software to input symbols that are not available on standard input devices.

          Input methods are specially used to input Chinese, Japanese and Korean characters.

          Currently the following input methods are available in NixOS:

          - ibus: The intelligent input bus, extra input engines can be added using `i18n.inputMethod.ibus.engines`.
          - fcitx: A customizable lightweight input method, extra input engines can be added using `i18n.inputMethod.fcitx.engines`.
          - fcitx5: The next generation of fcitx, addons (including engines, dictionaries, skins) can be added using `i18n.inputMethod.fcitx5.addons`.
          - nabi: A Korean input method based on XIM. Nabi doesn't support Qt 5.
          - uim: The universal input method, is a library with a XIM bridge. uim mainly support Chinese, Japanese and Korean.
          - hime: An extremely easy-to-use input method framework.
          - kime: Koream IME.
        '';
      };

      package = mkOption {
        internal = true;
        type     = types.nullOr types.path;
        default  = null;
        description = lib.mdDoc ''
          The input method method package.
        '';
      };
    };
  };

  config = mkIf (cfg.enabled != null) {
    environment.systemPackages = [ cfg.package gtk2_cache gtk3_cache ];
  };

  meta = {
    maintainers = with lib.maintainers; [ ericsagnes ];
    # Don't edit the docbook xml directly, edit the md and generate it using md-to-db.sh
    doc = ./default.xml;
  };

}
