{ lib, stdenv, fetchurl
, gpm, openssl, pkg-config, libev # Misc.
, libpng, libjpeg, libtiff, librsvg # graphic formats
, bzip2, zlib, xz # Transfer encodings
, enableFB ? true
, enableDirectFB ? false, directfb
, enableX11 ? true, libX11, libXt, libXau # GUI support
}:

stdenv.mkDerivation rec {
  version = "2.27";
  pname = "links2";

  src = fetchurl {
    url = "${meta.homepage}/download/links-${version}.tar.bz2";
    sha256 = "sha256-2N3L/O3nzd6Aq+sKI2NY9X+mvrK8+S4QliTpuJb567Q=";
  };

  buildInputs = with lib;
    [ libev librsvg libpng libjpeg libtiff openssl xz bzip2 zlib ]
    ++ optionals stdenv.isLinux [ gpm ]
    ++ optionals enableX11 [ libX11 libXau libXt ]
    ++ optional enableDirectFB [ directfb ];

  nativeBuildInputs = [ pkg-config bzip2 ];

  configureFlags = [ "--with-ssl" ]
    ++ lib.optional (enableX11 || enableFB || enableDirectFB) "--enable-graphics"
    ++ lib.optional enableX11 "--with-x"
    ++ lib.optional enableFB "--with-fb"
    ++ lib.optional enableDirectFB "--with-directfb";

  meta = with lib; {
    homepage = "http://links.twibright.com/";
    description = "A small browser with some graphics support";
    maintainers = with maintainers; [ raskin ];
    mainProgram = "links";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
}
