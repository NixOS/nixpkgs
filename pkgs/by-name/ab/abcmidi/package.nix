{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abcmidi";
  version = "2026.02.24";

  src = fetchFromGitHub {
    owner = "sshlien";
    repo = "abcmidi";
    tag = finalAttrs.version;
    hash = "sha256-Hy0ICuMK4pCaJn/36QwkCfEI5kgmkWyr9V4RhMpGQes=";
  };

  # TODO: remove once https://github.com/sshlien/abcmidi/pull/15 merged
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  meta = {
    homepage = "https://abc.sourceforge.net/abcMIDI/";
    downloadPage = "https://ifdo.ca/~seymour/runabc/top.html";
    license = lib.licenses.gpl2Plus;
    description = "Utilities for converting between abc and MIDI";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
