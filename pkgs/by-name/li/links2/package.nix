{
  lib,
  stdenv,
  fetchurl,
  gpm,
  openssl,
  pkg-config,
  libev, # Misc.
  libpng,
  libjpeg,
  libtiff,
  librsvg,
  libavif, # graphic formats
  bzip2,
  zlib,
  xz, # Transfer encodings
  enableFB ? (!stdenv.hostPlatform.isDarwin),
  enableDirectFB ? false,
  directfb,
  enableX11 ? (!stdenv.hostPlatform.isDarwin),
  libX11,
  libXt,
  libXau, # GUI support
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.30";
  pname = "links2";

  src = fetchurl {
    url = "http://links.twibright.com/download/links-${finalAttrs.version}.tar.bz2";
    hash = "sha256-xGMca1oRUnzcPLeHL8I7fyslwrAh1Za+QQ2ttAMV8WY=";
  };

  buildInputs =
    [
      libev
      librsvg
      libpng
      libjpeg
      libtiff
      libavif
      openssl
      xz
      bzip2
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ gpm ]
    ++ lib.optionals enableX11 [
      libX11
      libXau
      libXt
    ]
    ++ lib.optionals enableDirectFB [ directfb ];

  nativeBuildInputs = [
    pkg-config
    bzip2
  ];

  configureFlags =
    [ "--with-ssl" ]
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
