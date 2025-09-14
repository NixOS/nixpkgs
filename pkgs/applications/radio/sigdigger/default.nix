{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
  pkg-config,
  sigutils,
  fftwSinglePrec,
  suwidgets,
  wrapQtAppsHook,
  suscan,
  libsndfile,
  soapysdr-with-plugins,
  libxml2,
  volk,
}:

stdenv.mkDerivation rec {
  pname = "sigdigger";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "BatchDrake";
    repo = "SigDigger";
    rev = "v${version}";
    sha256 = "sha256-dS+Fc0iQz7GIlGaR556Ur/EQh3Uzhqm9uBW42IuEqoE=";
  };

  nativeBuildInputs = [
    qmake
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs = [
    qtbase
    sigutils
    fftwSinglePrec
    suwidgets
    suscan
    libsndfile
    libxml2
    volk
    soapysdr-with-plugins
  ];

  qmakeFlags = [
    "SUWIDGETS_PREFIX=${suwidgets}"
    "SigDigger.pro"
  ];

  meta = {
    description = "Qt-based digital signal analyzer, using Suscan core and Sigutils DSP library";
    mainProgram = "SigDigger";
    homepage = "https://github.com/BatchDrake/SigDigger";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
      polygon
      oxapentane
    ];
  };
}
