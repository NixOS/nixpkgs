{ config, pkgs, lib, ... }:

with lib;
let
  cfg = config.i18n.inputMethod;
  gtk2_cache = pkgs.stdenv.mkDerivation {
    preferLocalBuild = true; 
    allowSubstitutes = false;
    name = "gtk2-immodule.cache";
    buildInputs = [ pkgs.gtk cfg.package ];
    buildCommand = ''
      GTK_PATH=${cfg.package}/lib/gtk-2.0/ gtk-query-immodules-2.0 > $out
    '';
  };
  gtk3_cache = pkgs.stdenv.mkDerivation {
    preferLocalBuild = true; 
    allowSubstitutes = false;
    name = "gtk3-immodule.cache";
    buildInputs = [ pkgs.gtk3 cfg.package ];
    buildCommand = ''
      GTK_PATH=${cfg.package}/lib/gtk-3.0/ gtk-query-immodules-3.0 > $out
    '';
  };
in
{
  options.i18n = {
    inputMethod = {
      enabled = mkOption {
        type    = types.nullOr (types.enum [ "ibus" "fcitx" "nabi" "uim" ]);
        default = null;
        example = "fcitx";
        description = ''
          Select the enabled input method. Input methods is a software to input symbols that are not available on standard input devices.

          Input methods are specially used to input Chinese, Japanese and Korean characters.

          Currently the following input methods are available in NixOS:

          <itemizedlist>
          <listitem><para>ibus: The intelligent input bus, extra input engines can be added using <literal>i18n.inputMethod.ibus.engines</literal>.</para></listitem>
          <listitem><para>fcitx: A customizable lightweight input method, extra input engines can be added using <literal>i18n.inputMethod.fcitx.engines</literal>.</para></listitem>
          <listitem><para>nabi: A Korean input method based on XIM. Nabi doesn't support Qt 5.</para></listitem>
          <listitem><para>uim: The universal input method, is a library with a XIM bridge. uim mainly support Chinese, Japanese and Korean.</para></listitem>
          </itemizedlist>
        '';
      };

      package = mkOption {
        internal = true;
        type     = types.path;
        default  = null;
        description = ''
          The input method method package.
        '';
      };
    };
  };

  config = mkIf (cfg.enabled != null) {
    environment.systemPackages = [ cfg.package ];

    environment.variables = {
      GTK_IM_MODULE_FILE  = "/etc/gtk2.0/immodules.cache";
      GTK3_IM_MODULE_FILE = "/etc/gtk3.0/immodules.cache";
    };

    environment.etc = [
      { source = gtk2_cache;
        target = "gtk2.0/immodules.cache"; }
      { source = gtk3_cache;
        target = "gtk3.0/immodules.cache"; }
    ];

  };

}
