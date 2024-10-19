{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abcmidi";
  version = "2024.10.10";

  src = fetchFromGitHub {
    owner = "sshlien";
    repo = "abcmidi";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-dAxr1RJrYppt/Gw6ZF3fL0lDhwJNG5v75M6VA1okrtw=";
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
