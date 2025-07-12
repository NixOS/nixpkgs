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
  # Upstream's `plot` UX is not ideal - it doesn't write a good message
  # suggesting the user to install this optional dependency when they write
  # `plot(..)`. Not to mention support for non-x dependent `gnuplot_qt`
  # executable. Hence we hardcode a path to a gnuplot binary by default, and
  # changing this is possible via putting an empty string as a `gnuplotBinary`
  # - to let `libqalculate` pick it from $PATH during runtime. See also:
  # https://github.com/Qalculate/libqalculate/issues/796
  gnuplot,
  gnuplotBinary ? lib.getExe gnuplot,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libqalculate";
  version = "5.6.0";

  src = fetchFromGitHub {
    owner = "qalculate";
    repo = "libqalculate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VYnJPXbWxfWtcIiTYGDO3ULtKTNtdBviFUUrXywxDcw=";
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

  postPatch = lib.optionalString (gnuplotBinary != "") ''
    substituteInPlace libqalculate/Calculator-plot.cc \
      --replace-fail 'commandline = "gnuplot"' 'commandline = "${gnuplotBinary}"' \
      --replace-fail '"gnuplot - ' '"${gnuplotBinary} - '
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
      pentane
    ];
    mainProgram = "qalc";
    platforms = lib.platforms.all;
  };
})
