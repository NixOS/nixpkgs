{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  curl,
  libXext,
  libXft,
  libXi,
  libXinerama,
  libXtst,
  libXv,
  libXxf86vm,
  libjpeg,
  libpng,
  lirc,
  ncurses,
  pkg-config,
  readline,
  shared-mime-info,
  xine-lib,
  xorgproto,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "xine-ui";
  version = "0.99.14";

  src = fetchurl {
    url = "mirror://sourceforge/xine/xine-ui-${finalAttrs.version}.tar.xz";
    hash = "sha256-1NSQ1c7OcOK7mEnJ5ILyz4evAwLUUbYUR2/cw2Qs2cM=";
  };

  outputs = [
    "out"
    "dev"
    "lib"
    "man"
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    shared-mime-info
  ];

  buildInputs = [
    curl
    libXext
    libXft
    libXi
    libXinerama
    libXtst
    libXv
    libXxf86vm
    libjpeg
    libpng
    lirc
    ncurses
    readline
    xine-lib
    xorgproto
  ];

  configureFlags = [ "--with-readline=${readline.dev}" ];

  env = {
    LIRC_CFLAGS = "-I${lirc}/include";
    LIRC_LIBS = "-L ${lirc}/lib -llirc_client";
  };

  postInstall = ''
    substituteInPlace $out/share/applications/xine.desktop \
      --replace "MimeType=;" "MimeType="
  '';

  meta = {
    homepage = "https://xine.sourceforge.net/";
    description = "Xlib-based frontend for Xine video player";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    platforms = lib.platforms.linux;
  };
})
