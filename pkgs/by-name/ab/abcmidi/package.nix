{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abcmidi";
  version = "2025.01.30";

  src = fetchFromGitHub {
    owner = "sshlien";
    repo = "abcmidi";
    tag = finalAttrs.version;
    hash = "sha256-3l9sOPwoi5jHZraEldNiXXMC3Dz3km5z848IBP+8aPg=";
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
