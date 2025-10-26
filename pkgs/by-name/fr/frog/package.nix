{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  callPackage,
  autoreconfHook,
  bzip2,
  libtar,
  libtool,
  pkg-config,
  autoconf-archive,
  libxml2,
  icu,
  libexttextcat,
  ticcutils,
  timbl,
  mbt,
  libfolia,
  ucto,
  frogdata,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "frog";
  version = "0.34";

  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "frog";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+oao0aOhXAnXnWbfZXcCzBFER8Q8TaYciAVQHlZ1D+E=";
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
    libexttextcat
    ticcutils
    timbl
    mbt
    libfolia
    ucto
    frogdata
  ];

  postInstall = ''
    # frog expects the data files installed in the same prefix
    mkdir -p $out/share/frog/;
    for f in ${frogdata}/share/frog/*; do
      ln -s $f $out/share/frog/;
    done;

    make check
  '';

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
    tests.simple = callPackage ./test.nix { frog = finalAttrs.finalPackage; };
  };

  meta = with lib; {
    description = "Tagger-Lemmatizer-Morphological-Analyzer-Dependency-Parser for Dutch";
    homepage = "https://languagemachines.github.io/frog";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      Frog is an integration of memory-based natural language processing (NLP) modules developed for Dutch. All NLP modules are based on Timbl, the Tilburg memory-based learning software package. Most modules were created in the 1990s at the ILK Research Group (Tilburg University, the Netherlands) and the CLiPS Research Centre (University of Antwerp, Belgium). Over the years they have been integrated into a single text processing tool, which is currently maintained and developed by the Language Machines Research Group and the Centre for Language and Speech Technology at Radboud University Nijmegen. A dependency parser, a base phrase chunker, and a named-entity recognizer module were added more recently. Where possible, Frog makes use of multi-processor support to run subtasks in parallel.

      Various (re)programming rounds have been made possible through funding by NWO, the Netherlands Organisation for Scientific Research, particularly under the CGN project, the IMIX programme, the Implicit Linguistics project, the CLARIN-NL programme and the CLARIAH programme.
    '';
  };

})
