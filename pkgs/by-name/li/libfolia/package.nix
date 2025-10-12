{
  lib,
  stdenv,
  fetchFromGitHub,
  gitUpdater,
  autoreconfHook,
  libtool,
  pkg-config,
  autoconf-archive,
  libxml2,
  icu,
  bzip2,
  libtar,
  ticcutils,
  frog,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libfolia";
  version = "2.21.1";

  src = fetchFromGitHub {
    owner = "LanguageMachines";
    repo = "libfolia";
    tag = "v${finalAttrs.version}";
    hash = "sha256-p1caLiYcmokrjiDXLEkPpTOIPIR8Ofv/JsRkHs4PsPE=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];
  buildInputs = [
    bzip2
    libtool
    autoconf-archive
    libtar
    libxml2
    icu
    ticcutils
  ];

  # compat with icu61+ https://github.com/unicode-org/icu/blob/release-64-2/icu4c/readme.html#L554
  CXXFLAGS = [ "-DU_USING_ICU_NAMESPACE=1" ];

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
    description = "C++ API for FoLiA documents; an XML-based linguistic annotation format";
    mainProgram = "folialint";
    homepage = "https://proycon.github.io/folia/";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ roberth ];

    longDescription = ''
      A high-level C++ API to read, manipulate, and create FoLiA documents. FoLiA is an XML-based annotation format, suitable for the representation of linguistically annotated language resources. FoLiA’s intended use is as a format for storing and/or exchanging language resources, including corpora.
    '';
  };

})
