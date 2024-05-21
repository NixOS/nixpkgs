{
  lib,
  stdenv,
  fetchFromGitHub,
  testers,
  cmake,
  gitUpdater,
  fetchpatch,
  libdevil,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "avisynthplus";
  version = "3.7.3";

  src = fetchFromGitHub {
    owner = "AviSynth";
    repo = "AviSynthPlus";
    rev = "v${finalAttrs.version}";
    hash = "sha256-v/AErktcegdrwxDbD0DZ/ZAxgaZmkZD+qxR3EPFsT08=";
  };

  patches = [
    # Remove after next relaese
    (fetchpatch {
      name = "fix-absolute-path.patch";
      url = "https://github.com/AviSynth/AviSynthPlus/commit/818983691e962ec3e590fcad07032f8a139a6b16.patch";
      hash = "sha256-4yUOnjtOroX+bhNUKbYz/giKaslzYdwPaaJWNkrTBr4=";
    })
  ];

  buildInputs = [ libdevil ];

  nativeBuildInputs = [ cmake ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.pkg-config = testers.testMetaPkgConfig finalAttrs.finalPackage;
  };

  meta = with lib; {
    description = "An improved version of the AviSynth frameserver";
    homepage = "https://avs-plus.net/";
    changelog = "https://github.com/AviSynth/AviSynthPlus/releases/tag/${finalAttrs.src.rev}";
    license = licenses.gpl2Only;
    pkgConfigModules = [ "avisynth" ];
    platforms = platforms.unix;
    maintainers = with maintainers; [ jopejoe1 ];
  };
})
