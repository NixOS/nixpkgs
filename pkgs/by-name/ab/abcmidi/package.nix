{
  fetchFromGitHub,
  lib,
  stdenv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "abcmidi";
  version = "2024.12.16";

  src = fetchFromGitHub {
    owner = "sshlien";
    repo = "abcmidi";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-8kzgojLwVVFjpWiQ1/0S3GCVU8oEpoFItjtRDByauDg=";
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
