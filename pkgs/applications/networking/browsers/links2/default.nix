{ stdenv, fetchurl
, gpm, openssl, pkgconfig, libev # Misc.
, libpng, libjpeg, libtiff, librsvg # graphic formats
, bzip2, zlib, xz # Transfer encodings
, enableFB ? true
, enableDirectFB ? false, directfb
, enableX11 ? true, libX11, libXt, libXau # GUI support
}:

stdenv.mkDerivation rec {
  version = "2.15";
  name = "links2-${version}";

  src = fetchurl {
    url = "${meta.homepage}/download/links-${version}.tar.bz2";
    sha256 = "1jp3xyvp87a188b4kg5ycqahrazj7928zncgsznzn54w8d5iqahy";
  };

  buildInputs = with stdenv.lib;
    [ libev librsvg libpng libjpeg libtiff openssl xz bzip2 zlib ]
    ++ optionals stdenv.isLinux [ gpm ]
    ++ optionals enableX11 [ libX11 libXau libXt ]
    ++ optional enableDirectFB [ directfb ];

  nativeBuildInputs = [ pkgconfig bzip2 ];

  configureFlags = [ "--with-ssl" ]
    ++ stdenv.lib.optional (enableX11 || enableFB || enableDirectFB) "--enable-graphics"
    ++ stdenv.lib.optional enableX11 "--with-x"
    ++ stdenv.lib.optional enableFB "--with-fb"
    ++ stdenv.lib.optional enableDirectFB "--with-directfb";

  meta = with stdenv.lib; {
    homepage = http://links.twibright.com/;
    description = "A small browser with some graphics support";
    maintainers = with maintainers; [ raskin viric ];
    platforms = platforms.unix;
  };
}
