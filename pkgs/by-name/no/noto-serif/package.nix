{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  mkNoto,
}:

mkNoto rec {
  pname = "noto-serif";
  version = "2.013";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "latin-greek-cyrillic";
    rev = "NotoSerif-v${version}";
    hash = "sha256-guiiPnvlJPA7g5MRFoffj91q3ETljh1bIJDV/vP7qww=";
  };

  isVariable = true;
  fontConfig = "serif";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSerif-v"; };

  meta = {
    description = "Modulated (“serif”) design for texts in the Indic Devanagari script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Serif+Devanagari";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = lib.teams.notofonts.members;
  };
}
