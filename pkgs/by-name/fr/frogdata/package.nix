{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  autoreconfHook,
  libtool,
  pkg-config,
  autoconf-archive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frogdata";
  version = "0.13";

  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "frogdata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-f3rPjc8iYPVJsL6pez2WBw+rCxy6xm3DzOi8S+PDkvg=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    libtool
    autoconf-archive
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = with lib; {
    description = "Data for Frog, a Tagger-Lemmatizer-Morphological-Analyzer-Dependency-Parser for Dutch";
    homepage = "https://languagemachines.github.io/frog";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];
  };

})
