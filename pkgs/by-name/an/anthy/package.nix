{
  lib,
  stdenv,
  fetchFromGitHub,
  autoconf,
  automake,
  libtool,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "anthy";
  version = "1.0.0.20260213";
  __stucturedAttrs = true;

  meta = {
    description = "Hiragana text to Kana Kanji mixed text Japanese input method";
    homepage = "https://web.archive.org/web/20250404073626/https://osdn.net/projects/anthy/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };

  src = fetchFromGitHub {
    owner = "fujiwarat";
    repo = "anthy-unicode";
    rev = finalAttrs.version;
    hash = "sha256-lyd6cvuddQa535ZXhng6iQbP9cwfPXWXBEsqOEsjkHI=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    libtool
  ];

  configurePhase = ''
    ./autogen.sh --prefix="$out"
  '';
})
