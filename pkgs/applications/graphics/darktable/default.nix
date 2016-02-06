{ stdenv, fetchurl, libsoup, graphicsmagick, SDL, json_glib
, GConf, atk, cairo, cmake, curl, dbus_glib, exiv2, glib
, libgnome_keyring, gtk, ilmbase, intltool, lcms, lcms2
, lensfun, libXau, libXdmcp, libexif, libglade, libgphoto2, libjpeg
, libpng, libpthreadstubs, libraw1394, librsvg, libtiff, libxcb
, openexr, pixman, pkgconfig, sqlite, bash, libxslt, openjpeg
, mesa, majorVersion ? 1, gtk3, lua5_2, pugixml }:

assert stdenv ? glibc;

with stdenv.lib;

let
  version = if majorVersion == 1 then "1.6.9" else "2.0.0";
  sha256 = if majorVersion == 1 then "0wri89ygjpv7npiz58mnydhgldywp6arqp9jq3v0g54a56fiwwhg" else "1cbwvzqn3158cy7r499rdwipx7fpb30lrrvh6jy5a4xvpcjzbwnl";

  optionalPreConfigure = if majorVersion == 1 then ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk}/include/gtk-2.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk}/lib/gtk-2.0/include"
  '' else ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk3}/include/gtk-3.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk3}/lib/gtk-3.0/include"
  '';

  optionalBuildInputs = if majorVersion == 1 then [gtk libraw1394] else [gtk3 lua5_2 (pugixml.override {pic = true;})];

in

stdenv.mkDerivation rec {
inherit version;
  name = "darktable-${version}";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    sha256 = sha256;
  };

  buildInputs =
    [ GConf atk cairo cmake curl dbus_glib exiv2 glib libgnome_keyring
      ilmbase intltool lcms lcms2 lensfun libXau libXdmcp libexif
      libglade libgphoto2 libjpeg libpng libpthreadstubs
      librsvg libtiff libxcb openexr pixman pkgconfig sqlite libxslt
      libsoup graphicsmagick SDL json_glib openjpeg mesa
    ] ++ optionalBuildInputs;

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${cairo}/include/cairo"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${atk}/include/atk-1.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${ilmbase}/include/OpenEXR"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${openexr}/include/OpenEXR"
  '' + optionalPreConfigure;

  cmakeFlags = [
    "-DPTHREAD_INCLUDE_DIR=${stdenv.glibc}/include"
    "-DPTHREAD_LIBRARY=${stdenv.glibc}/lib/libpthread.so"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBINARY_PACKAGE_BUILD=1"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk}/lib/gtk-2.0/include"
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
