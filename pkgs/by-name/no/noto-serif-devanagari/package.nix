{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  mkNoto,
}:

mkNoto rec {
  pname = "noto-serif-devanagari";
  version = "2.006";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "devanagari";
    rev = "NotoSerifDevanagari-v${version}";
    hash = "sha256-V+ikOT0EbtLPsnauNIIOimUUoxFKCCxIJRPIgZusPZE=";
  };

  isVariable = true;
  fontConfig = "serif-devanagari";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSerifDevanagari-v"; };

  meta = {
    description = "Unmodulated (“sans serif”) design for texts in the Indic Devanagari script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Devanagari";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = lib.teams.notofonts.members;
  };
}
