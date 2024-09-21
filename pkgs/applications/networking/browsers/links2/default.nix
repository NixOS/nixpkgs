{ lib, stdenv, fetchurl
, gpm, openssl, pkg-config, libev # Misc.
, libpng, libjpeg, libtiff, librsvg, libavif # graphic formats
, bzip2, zlib, xz # Transfer encodings
, enableFB ? (!stdenv.isDarwin)
, enableDirectFB ? false, directfb
, enableX11 ? (!stdenv.isDarwin), libX11, libXt, libXau # GUI support
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.29";
  pname = "links2";

  src = fetchurl {
    url = "http://links.twibright.com/download/links-${finalAttrs.version}.tar.bz2";
    hash = "sha256-IqqWwLOOGm+PftnXpBZ6R/w3JGCXdZ72BZ7Pj56teZg=";
  };

  buildInputs =
    [ libev librsvg libpng libjpeg libtiff libavif openssl xz bzip2 zlib ]
    ++ lib.optionals stdenv.isLinux [ gpm ]
    ++ lib.optionals enableX11 [ libX11 libXau libXt ]
    ++ lib.optionals enableDirectFB [ directfb ];

  nativeBuildInputs = [ pkg-config bzip2 ];

  configureFlags = [ "--with-ssl" ]
    ++ lib.optional (enableX11 || enableFB || enableDirectFB) "--enable-graphics"
    ++ lib.optional enableX11 "--with-x"
    ++ lib.optional enableFB "--with-fb"
    ++ lib.optional enableDirectFB "--with-directfb";

  env = lib.optionalAttrs stdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-int";
  };

  meta = with lib; {
    homepage = "http://links.twibright.com/";
    description = "Small browser with some graphics support";
    maintainers = with maintainers; [ raskin ];
    mainProgram = "links";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
  };
})
