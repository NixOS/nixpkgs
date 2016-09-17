{ stdenv, fetchurl, pkgconfig, glib, gettext }:

stdenv.mkDerivation rec {
  name= "sdcv-0.4.2";

  meta = {
    homepage = http://sdcv.sourceforge.net/;
    description = "Console version of StarDict program";
    maintainers = with stdenv.lib.maintainers; [ lovek323 ];
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };

  src = fetchurl {
    url = "mirror://sourceforge/sdcv/${name}.tar.bz2";
    sha256 = "1cnyv7gd1qvz8ma8545d3aq726wxrx4km7ykl97831irx5wz0r51";
  };

  hardeningDisable = [ "format" ];

  patches = ( if stdenv.isDarwin
              then [ ./sdcv.cpp.patch-darwin ./utils.hpp.patch ]
              else [ ./sdcv.cpp.patch ] );

  buildInputs = [ pkgconfig glib gettext ];

  preBuild = ''
    sed -i 's/guint32 page_size/size_t page_size/' src/lib/lib.cpp
  '';

  NIX_CFLAGS_COMPILE = "-D__GNU_LIBRARY__"
    + stdenv.lib.optionalString stdenv.isDarwin " -lintl";
}

