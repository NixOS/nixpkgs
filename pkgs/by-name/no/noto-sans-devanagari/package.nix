{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  mkNoto,
}:

mkNoto rec {
  pname = "noto-sans-devanagari";
  version = "2.006";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "devanagari";
    rev = "NotoSansDevanagari-v${version}";
    hash = "sha256-hhzTvFkGAZMvUVSN3nPENvTiHDJIxYSPq6HqdNuOfiI=";
  };

  isVariable = true;
  fontConfig = "sans-devanagari";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansDevanagari-v"; };

  meta = {
    description = "Unmodulated (“sans serif”) design for texts in the Indic Devanagari script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Devanagari";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = lib.teams.notofonts.members;
  };
}
