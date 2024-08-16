{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abcmidi";
  version = "2024.08.11";

  src = fetchFromGitHub {
    owner = "sshlien";
    repo = "abcmidi";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-ljRwRSF6Odv99ej8mmMjtf9NE0du7TtAypkw7W9TEYU=";
  };

  meta = {
    homepage = "https://abc.sourceforge.net/abcMIDI/";
    downloadPage = "https://ifdo.ca/~seymour/runabc/top.html";
    license = lib.licenses.gpl2Plus;
    description = "Utilities for converting between abc and MIDI";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
