{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  mkNoto,
}:

mkNoto rec {
  pname = "noto-sans-mongolian";
  version = "3.002";

  src = fetchFromGitHub {
    owner = "notofonts";
    repo = "mongolian";
    rev = "NotoSansMongolian-v${version}";
    hash = "sha256-YJ9p+/EBEtKmoF6h2RRyDBhAYJYWHomIxO2cvgzEwBc=";
  };

  isVariable = false;
  fontConfig = "sans-mongolian";

  passthru.updateScript = gitUpdater { rev-prefix = "NotoSansMongolian-v"; };

  meta = {
    description = "Unmodulated (“sans serif”) design for texts in the Central Asian Mongolian script";
    homepage = "https://fonts.google.com/noto/specimen/Noto+Sans+Mongolian";
    license = lib.licenses.ofl;
    platforms = lib.platforms.all;
    maintainers = lib.teams.notofonts.members;
  };
}
