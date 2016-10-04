{ stdenv, fetchurl, libsoup, graphicsmagick, SDL, json_glib
, GConf, atk, cairo, cmake, curl, dbus_glib, exiv2, glib
, libgnome_keyring, gtk3, ilmbase, intltool, lcms, lcms2
, lensfun, libXau, libXdmcp, libexif, libglade, libgphoto2, libjpeg
, libpng, libpthreadstubs, librsvg, libtiff, libxcb
, openexr, osm-gps-map, pixman, pkgconfig, sqlite, bash, libxslt, openjpeg
, mesa, lua, pugixml, colord, colord-gtk, libxshmfence, libxkbcommon
, epoxy, at_spi2_core, libwebp, libsecret, wrapGAppsHook, gnome3
}:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  version = "2.0.6";
  name = "darktable-${version}";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    sha256 = "1h9qwxyvcv0fc6y5b6l2x4jd5mmw026blhjkcihj00r1aa3c2s13";
  };

  buildInputs =
    [ GConf atk cairo cmake curl dbus_glib exiv2 glib libgnome_keyring gtk3
      ilmbase intltool lcms lcms2 lensfun libXau libXdmcp libexif
      libglade libgphoto2 libjpeg libpng libpthreadstubs
      librsvg libtiff libxcb openexr pixman pkgconfig sqlite libxslt
      libsoup graphicsmagick SDL json_glib openjpeg mesa lua pugixml
      colord colord-gtk libxshmfence libxkbcommon epoxy at_spi2_core
      libwebp libsecret wrapGAppsHook gnome3.adwaita-icon-theme
      osm-gps-map
    ];

  cmakeFlags = [
    "-DBUILD_USERMANUAL=False"
  ];

  meta = with stdenv.lib; {
    description = "Virtual lighttable and darkroom for photographers";
    homepage = https://www.darktable.org;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.rickynils maintainers.flosse ];
  };
}
