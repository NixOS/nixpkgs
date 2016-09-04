{ stdenv,  fetchurl, gnome3, itstool, libxml2, pkgconfig, intltool,
  exiv2, libjpeg, libtiff, gstreamer, libraw, libsoup, libsecret,
  libchamplain, librsvg, libwebp, json_glib, webkit, lcms2, bison,
  flex, wrapGAppsHook }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "gthumb";
  version = "${major}.3";
  major = "3.4";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${major}/${name}.tar.xz";
    sha256 = "0pc2xl6kwhi5l3d0dj6nzdcj2vpihs7y1s3l1hwir8zy7cpx23y1";
  };

  nativeBuildInputs = [ pkgconfig wrapGAppsHook ];

  buildInputs = with gnome3;
    [ itstool libxml2 intltool glib gtk gsettings_desktop_schemas dconf
      exiv2 libjpeg libtiff gstreamer libraw libsoup libsecret libchamplain
      librsvg libwebp json_glib webkit lcms2 bison flex ];

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Apps/gthumb;
    description = "Image browser and viewer for GNOME";
    platforms = platforms.linux;
    license = licenses.gpl2;
    maintainers = [ maintainers.mimadrid ];
  };
}
