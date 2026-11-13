{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  autoreconfHook,
  bzip2,
  libtar,
  libtool,
  pkg-config,
  autoconf-archive,
  libxml2,
  icu,
  ticcutils,
  timbl,
  frog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mbt";
  version = "3.12";

  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "mbt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GBjLkQV+y3x+b+Jw0/Ni3q6zM03Ilk4IgGMteKq+cM0=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    bzip2
    libtar
    libtool
    autoconf-archive
    libxml2
    icu
    ticcutils
    timbl
  ];
  patches = [ ./mbt-add-libxml2-dep.patch ];

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

  meta = {
    description = "Memory Based Tagger";
    homepage = "https://languagemachines.github.io/mbt/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ roberth ];

    longDescription = ''
      MBT is a memory-based tagger-generator and tagger in one. The tagger-generator part can generate a sequence tagger on the basis of a training set of tagged sequences; the tagger part can tag new sequences. MBT can, for instance, be used to generate part-of-speech taggers or chunkers for natural language processing. It has also been used for named-entity recognition, information extraction in domain-specific texts, and disfluency chunking in transcribed speech.

      Mbt is used by Frog for Dutch tagging.
    '';
  };

})
