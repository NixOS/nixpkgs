{ stdenv, fetchurl, desktop_file_utils, enchant, gnome, gstreamer, gstreamermm,
  gst_plugins_base, gst_plugins_good, intltool, hicolor_icon_theme,
  libsigcxx, libxmlxx, makeWrapper, xdg_utils, pkgconfig } :

let
  ver_maj = "0.41";
  ver_min = "0";
in

stdenv.mkDerivation rec {
  name = "subtitle-editor-${ver_maj}.${ver_min}";

  buildInputs =  [
    desktop_file_utils enchant gnome.gtk gnome.gtkmm gstreamer gstreamermm
    gst_plugins_base gst_plugins_good intltool hicolor_icon_theme libsigcxx libxmlxx
    makeWrapper xdg_utils pkgconfig
  ];

  src = fetchurl {
    url = "http://download.gna.org/subtitleeditor/${ver_maj}/subtitleeditor-${ver_maj}.${ver_min}.tar.gz";
    md5 = "3c21ccd8296001dcb1a02c62396db1b6";
  };

  doCheck = true;

  postInstall = ''
    wrapProgram "$out/bin/subtitleeditor" --prefix \
      GST_PLUGIN_SYSTEM_PATH ":" "$GST_PLUGIN_SYSTEM_PATH"                                                     \
  '';


  meta = {
    description = "GTK+2 application to edit video subtitles";
    longDescription = ''
      Subtitle Editor is a GTK+2 tool to edit subtitles for GNU/Linux/*BSD. It can be
      used for new subtitles or as a tool to transform, edit, correct and refine
      existing subtitle. This program also shows sound waves, which makes it easier
      to synchronise subtitles to voices.
      '';
    homepage = http://home.gna.org/subtitleeditor;
    license = stdenv.lib.licenses.gpl3;
    maintainers = stdenv.lib.maintainers.plcplc;
    platforms = stdenv.lib.platforms.linux;
  };
}
