{ stdenv, fetchurl, libsoup, graphicsmagick, SDL, json_glib
, GConf, atk, cairo, cmake, curl, dbus_glib, exiv2, glib
, libgnome_keyring, gtk, ilmbase, intltool, lcms, lcms2
, lensfun, libXau, libXdmcp, libexif, libglade, libgphoto2, libjpeg
, libpng, libpthreadstubs, libraw1394, librsvg, libtiff, libxcb
, openexr, pixman, pkgconfig, sqlite, bash, libxslt, openjpeg
, mesa }:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  version = "1.6.8";
  name = "darktable-${version}";

  src = fetchurl {
    url = "https://github.com/darktable-org/darktable/releases/download/release-${version}/darktable-${version}.tar.xz";
    sha256 = "0189d5pn6g01rynfkhxynrqgfi24v94x8fp0fs7ilrncv0dzhxmn";
  };

  buildInputs =
    [ GConf atk cairo cmake curl dbus_glib exiv2 glib libgnome_keyring gtk
      ilmbase intltool lcms lcms2 lensfun libXau libXdmcp libexif
      libglade libgphoto2 libjpeg libpng libpthreadstubs libraw1394
      librsvg libtiff libxcb openexr pixman pkgconfig sqlite libxslt
      libsoup graphicsmagick SDL json_glib openjpeg mesa
    ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk}/include/gtk-2.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk}/lib/gtk-2.0/include"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${cairo}/include/cairo"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${atk}/include/atk-1.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${ilmbase}/include/OpenEXR"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${openexr}/include/OpenEXR"
  '';

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
