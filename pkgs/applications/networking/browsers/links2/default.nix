{ stdenv, fetchurl
, gpm, libssl, pkgconfig, libev # Misc.
, libpng, libjpeg, libtiff, librsvg # graphic formats
, bzip2, zlib, xz # Transfer encodings
, enableFB ? true
, enableDirectFB ? false, directfb
, enableX11 ? true, libX11, libXt, libXau # GUI support
}:

stdenv.mkDerivation rec {
  version = "2.11";
  name = "links2-${version}";

  src = fetchurl {
    url = "${meta.homepage}/download/links-${version}.tar.bz2";
    sha256 = "0gqjdz1brdcx02mcwchi6bxy1i1ljbw5zpc6b321skrrsqkzkxw7";
  };

  buildInputs =
    [ libev librsvg libpng libjpeg libtiff gpm libssl xz bzip2 zlib ]
    ++ stdenv.lib.optionals enableX11 [ libX11 libXau libXt ]
    ++ stdenv.lib.optional enableDirectFB [ directfb ];

  nativeBuildInputs = [ pkgconfig bzip2 ];

  configureFlags = [ "--with-ssl" ]
    ++ stdenv.lib.optional (enableX11 || enableFB || enableDirectFB) "--enable-graphics"
    ++ stdenv.lib.optional enableX11 "--with-x"
    ++ stdenv.lib.optional enableFB "--with-fb"
    ++ stdenv.lib.optional enableDirectFB "--with-directfb";

  crossAttrs = {
    preConfigure = ''
      export CC=$crossConfig-gcc
    '';
  };

  meta = {
    homepage = http://links.twibright.com/;
    description = "A small browser with some graphics support";
    maintainers = with stdenv.lib.maintainers; [ raskin urkud viric ];
    platforms = stdenv.lib.platforms.linux;
  };
}
