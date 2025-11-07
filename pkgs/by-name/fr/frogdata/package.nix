{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  autoreconfHook,
  libtool,
  pkg-config,
  autoconf-archive,
  frog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frogdata";
  version = "0.22";

  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "frogdata";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N5AA3y18nPpqrnkDpnTweucz6l1aabQyosX4OwPBUzo=";
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
    tests = {
      /**
        Reverse dependencies. Does not respect overrides.
      */
      reverseDependencies = lib.recurseIntoAttrs {
        inherit frog;
      };
    };
  };

  meta = with lib; {
    description = "Data for Frog, a Tagger-Lemmatizer-Morphological-Analyzer-Dependency-Parser for Dutch";
    homepage = "https://languagemachines.github.io/frog";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];
  };

})
