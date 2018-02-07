{ stdenv,  fetchurl, gnome3, itstool, libxml2, pkgconfig, intltool,
  exiv2, libjpeg, libtiff, gstreamer, libraw, libsoup, libsecret,
  libchamplain, librsvg, libwebp, json_glib, webkit, lcms2, bison,
  flex, hicolor_icon_theme, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "gthumb";
  version = "${major}.0";
  major = "3.6";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${major}/${name}.tar.xz";
    sha256 = "1zc7myvnzgq7dawjg03rqvwfad7p938m20f25sfhv65jsfq8n928";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = with gnome3;
    [ itstool libxml2 intltool glib gtk gsettings_desktop_schemas dconf
      exiv2 libjpeg libtiff gstreamer libraw libsoup libsecret libchamplain
      librsvg libwebp json_glib webkit lcms2 bison flex hicolor_icon_theme defaultIconTheme ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/gthumb;
    description = "Image browser and viewer for GNOME";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.mimadrid ];
  };
}
