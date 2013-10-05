{ stdenv, fetchurl, pkgconfig, gtk, libglade, libgnomecanvas, fribidi
, libpng, popt, libgsf, enchant, wv, librsvg, bzip2, libjpeg
}:

stdenv.mkDerivation {
  name = "abiword-2.8.6";

  src = fetchurl {
    url = http://www.abisource.org/downloads/abiword/2.8.6/source/abiword-2.8.6.tar.gz;
    sha256 = "059sd2apxdmcacc4pll880i7vm18h0kyjsq299m1mz3c7ak8k46r";
  };

  prePatch = ''
    sed -i -e '/#include <glib\/gerror.h>/d' src/af/util/xp/ut_go_file.h
    sed -i -e 's|#include <glib/gmacros.h>|#include <glib.h>|' \
      goffice-bits/goffice/app/goffice-app.h
    sed -i -e 's/ptr->jmpbuf/jmpbuf(png_ptr)/' src/af/util/xp/ut_png.cpp
    sed -i -e 's/\(m_pPNG\)->\(jmpbuf\)/png_\2(\1)/' \
      src/wp/impexp/gtk/ie_impGraphic_GdkPixbuf.cpp
    sed -i -e 's/--no-undefined //' src/Makefile*
  '';

  enableParallelBuilding = true;

  buildInputs =
    [ pkgconfig gtk libglade librsvg bzip2 libgnomecanvas fribidi libpng popt
      libgsf enchant wv libjpeg
    ];

  meta = {
    description = "Word processing program, similar to Microsof Word";
  };
}
