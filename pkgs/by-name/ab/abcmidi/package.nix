{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abcmidi";
  version = "2025.11.26";

  src = fetchFromGitHub {
    owner = "sshlien";
    repo = "abcmidi";
    tag = finalAttrs.version;
    hash = "sha256-OBlkk5Fq3ep+wZqFfSXNqrXtznisNFjn9uDVj/Q4Odk=";
  };

<<<<<<< HEAD
  # TODO: remove once https://github.com/sshlien/abcmidi/pull/15 merged
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  meta = {
    homepage = "https://abc.sourceforge.net/abcMIDI/";
    downloadPage = "https://ifdo.ca/~seymour/runabc/top.html";
    license = lib.licenses.gpl2Plus;
    description = "Utilities for converting between abc and MIDI";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
