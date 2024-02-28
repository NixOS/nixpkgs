{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  gitUpdater,
  fetchpatch,
}:

stdenv.mkDerivation (
  finalAttrs: {
    pname = "avisynthplus";
    version = "3.7.3";

    src = fetchFromGitHub {
      owner = "AviSynth";
      repo = "AviSynthPlus";
      rev = "v${finalAttrs.version}";
      hash = "sha256-v/AErktcegdrwxDbD0DZ/ZAxgaZmkZD+qxR3EPFsT08=";
    };

    patches = [
      (fetchpatch {
        name = "fix-absolute-path.patch";
        url = "https://github.com/AviSynth/AviSynthPlus/commit/818983691e962ec3e590fcad07032f8a139a6b16.patch";
        hash = "sha256-4yUOnjtOroX+bhNUKbYz/giKaslzYdwPaaJWNkrTBr4=";
      })
    ];

    buildInputs = [ cmake ];

    passthru.updateScript = gitUpdater { rev-prefix = "v"; };

    meta = with lib; {
      description = "AviSynth with improvements";
      homepage = "https://avs-plus.net/";
      changelog = "https://github.com/AviSynth/AviSynthPlus/releases/tag/v${finalAttrs.version}";
      license = licenses.gpl2Plus;
      platforms = platforms.unix;
      maintainers = with maintainers; [ jopejoe1 ];
    };
  }
)
