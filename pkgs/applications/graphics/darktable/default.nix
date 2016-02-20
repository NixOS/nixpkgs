{ stdenv, fetchurl, libsoup, graphicsmagick, SDL, json_glib
, GConf, atk, cairo, cmake, curl, dbus_glib, exiv2, glib
, libgnome_keyring, gtk3, ilmbase, intltool, lcms, lcms2
, lensfun, libXau, libXdmcp, libexif, libglade, libgphoto2, libjpeg
, libpng, libpthreadstubs, librsvg, libtiff, libxcb
, openexr, pixman, pkgconfig, sqlite, bash, libxslt, openjpeg
, mesa, lua, pugixml, colord, colord-gtk, libxshmfence, libxkbcommon
, epoxy, at_spi2_core, libwebp, libsecret, wrapGAppsHook, gnome3
}:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  version = "2.0.0";
  name = "darktable-${version}";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    sha256 = "1cbwvzqn3158cy7r499rdwipx7fpb30lrrvh6jy5a4xvpcjzbwnl";
  };

  buildInputs =
    [ GConf atk cairo cmake curl dbus_glib exiv2 glib libgnome_keyring gtk3
      ilmbase intltool lcms lcms2 lensfun libXau libXdmcp libexif
      libglade libgphoto2 libjpeg libpng libpthreadstubs
      librsvg libtiff libxcb openexr pixman pkgconfig sqlite libxslt
      libsoup graphicsmagick SDL json_glib openjpeg mesa lua pugixml
      colord colord-gtk libxshmfence libxkbcommon epoxy at_spi2_core
      libwebp libsecret wrapGAppsHook gnome3.adwaita-icon-theme
    ];

  cmakeFlags = [
    "-DBUILD_USERMANUAL=False"
  ];

  meta = with stdenv.lib; {
    description = "Virtual lighttable and darkroom for photographers";
    homepage = http://www.darktable.org;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu maintainers.rickynils maintainers.flosse ];
  };
}
