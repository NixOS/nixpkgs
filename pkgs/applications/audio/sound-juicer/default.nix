{ stdenv, fetchurl, pkgconfig, gtk3, intltool, itstool, libxml2, brasero
, libcanberra_gtk3, gnome3, gst_all_1, libmusicbrainz5, libdiscid, isocodes
, makeWrapper }:

let
  major = "3.15";
  minor = "92";
  GST_PLUGIN_PATH = stdenv.lib.makeSearchPath "lib/gstreamer-1.0" [
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-libav ];

in stdenv.mkDerivation rec {
  version = "${major}.${minor}";
  name = "sound-juicer-${version}";

  src = fetchurl {
    url = "http://download.gnome.org/sources/sound-juicer/${major}/${name}.tar.xz";
    sha256 = "b1420f267a4c553f6ca242d3b6082b60682c3d7b431ac3c979bd1ccfbf2687dd";
  };

  buildInputs = [ pkgconfig gtk3 intltool itstool libxml2 brasero libcanberra_gtk3
                  gnome3.gsettings_desktop_schemas libmusicbrainz5 libdiscid isocodes
                  makeWrapper gnome3.dconf
                  gst_all_1.gstreamer gst_all_1.gst-plugins-base
                  gst_all_1.gst-plugins-good gst_all_1.gst-plugins-bad ];

  preFixup = ''
    for f in $out/bin/* $out/libexec/*; do
      wrapProgram "$f" \
        --prefix XDG_DATA_DIRS : "${gnome3.gnome_themes_standard}/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
        --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "$GST_PLUGIN_SYSTEM_PATH_1_0" \
        --prefix GIO_EXTRA_MODULES : "${gnome3.dconf}/lib/gio/modules" \
        --prefix GST_PLUGIN_PATH : "${GST_PLUGIN_PATH}"
    done
  '';

  postInstall = ''
    rm $out/share/icons/hicolor/icon-theme.cache
  '';

  meta = with stdenv.lib; {
    description = "A Gnome CD Ripper";
    homepage = https://wiki.gnome.org/Apps/SoundJuicer;
    maintainers = [ maintainers.bdimcheff ];
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
