{ stdenv, fetchurl
, GConf, atk, cairo, cmake, curl, dbus_glib, exiv2, glib
, libgnome_keyring, gphoto2, gtk, ilmbase, intltool, lcms, lcms2
, lensfun, libXau, libXdmcp, libexif, libglade, libgphoto2, libjpeg
, libpng, libpthreadstubs, libraw1394, librsvg, libtiff, libxcb
, openexr, pixman, pkgconfig, sqlite, bash, libxslt }:

assert stdenv ? glibc;

stdenv.mkDerivation rec {
  version = "1.2.2";
  name = "darktable-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/darktable/darktable/1.2/darktable-${version}.tar.xz";
    sha256 = "0nf85wjhlisbgwkfkc1wb8y7dpnx3v8zk9g3ghbd51gi7s62x40j";
  };

  buildInputs =
    [ GConf atk cairo cmake curl dbus_glib exiv2 glib libgnome_keyring gtk
      ilmbase intltool lcms lcms2 lensfun libXau libXdmcp libexif
      libglade libgphoto2 libjpeg libpng libpthreadstubs libraw1394
      librsvg libtiff libxcb openexr pixman pkgconfig sqlite libxslt
    ];

  preConfigure = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk}/include/gtk-2.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gtk}/lib/gtk-2.0/include"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${cairo}/include/cairo"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${atk}/include/atk-1.0"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${ilmbase}/include/OpenEXR"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${openexr}/include/OpenEXR"

    substituteInPlace tools/create_preferences.sh.in --replace '#!/usr/bin/env bash' '#!${bash}/bin/bash'
  '';

  cmakeFlags = [
    "-DPTHREAD_INCLUDE_DIR=${stdenv.glibc}/include"
    "-DPTHREAD_LIBRARY=${stdenv.glibc}/lib/libpthread.so"
    "-DCMAKE_BUILD_TYPE=Release"
    "-DGTK2_GLIBCONFIG_INCLUDE_DIR=${glib}/lib/glib-2.0/include"
    "-DGTK2_GDKCONFIG_INCLUDE_DIR=${gtk}/lib/gtk-2.0/include"
  ];

  meta = with stdenv.lib; {
    description = "Virtual lighttable and darkroom for photographers";
    homepage = http://darktable.sourceforge.net;
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = [ maintainers.goibhniu ];
  };
}
