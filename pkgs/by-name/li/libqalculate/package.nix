{
  lib,
  stdenv,
  fetchFromGitHub,
  intltool,
  pkg-config,
  doxygen,
  autoreconfHook,
  buildPackages,
  curl,
  gettext,
  libiconv,
  readline,
  libxml2,
  mpfr,
  icu,
  gnuplot,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqalculate";
  version = "5.5.2";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "libqalculate";
    rev = "v${finalAttrs.version}";
    hash = "sha256-sjVvsgDQbKXU+N7JrA36zezDfAGcDbyQ0fn1zMThYXQ=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    intltool
    pkg-config
    autoreconfHook
    doxygen
  ];
  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  buildInputs = [
    curl
    gettext
    libiconv
    readline
  ];
  propagatedBuildInputs = [
    libxml2
    mpfr
    icu
  ];
  enableParallelBuilding = true;

  preConfigure = ''
    intltoolize -f
  '';

  patchPhase = ''
    substituteInPlace libqalculate/Calculator-plot.cc \
      --replace-fail 'commandline = "gnuplot"' 'commandline = "${gnuplot}/bin/gnuplot"' \
      --replace-fail '"gnuplot - ' '"${gnuplot}/bin/gnuplot - '
  '';

  preBuild = ''
    pushd docs/reference
    doxygen Doxyfile
    popd
  '';

  meta = {
    description = "Advanced calculator library";
    homepage = "http://qalculate.github.io";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      doronbehar
      alyaeanyx
    ];
    mainProgram = "qalc";
    platforms = lib.platforms.all;
  };
})
