{
  lib,
  stdenv,
  fetchFromGitHub,
  fontconfig,
  gpgme,
  libX11,
  libXinerama,
  libXft,
  pkg-config,
  zlib,
  writeText,
  libassuan,
  libconfig,
  libgpg-error,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pinentry-dmenu";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "ritze";
    repo = "pinentry-dmenu";
    tag = finalAttrs.version;
    hash = "sha256-FmP9tI/oU7VM8x+Wu6bbeg1CVopZc6oOWnd4qUptVV8=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fontconfig
    gpgme
    libassuan
    libconfig
    libgpg-error
    libX11
    libXinerama
    libXft
  ];

  preConfigure = ''
    makeFlagsArray+=(
      PREFIX="$out"
      CC="$CC"
      # default config.mk hardcodes dependent libraries and include paths
      INCS="`$PKG_CONFIG --cflags fontconfig x11 xft xinerama`"
      LIBS="`$PKG_CONFIG --libs   fontconfig x11 xft xinerama`"
    )
  '';

  meta = {
    description = "Pinentry implementation based on dmenu";
    homepage = "https://github.com/ritze/pinentry-dmenu";
    changelog = "https://github.com/ritze/pinentry-dmenu/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ sweiglbosker ];
    mainProgram = "pinentry-dmenu";
    platforms = lib.platforms.linux;
  };
})
