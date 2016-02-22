{ config, pkgs, lib, ... }:

with lib;

{
  options = {
    i18n.inputMethod = {
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
    };
  };
}
