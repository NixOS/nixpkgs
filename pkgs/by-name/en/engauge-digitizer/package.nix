{
  lib,
  stdenv,
  fetchFromGitHub,
  fftw,
  libjpeg,
  log4cpp,
  openjpeg,
  libpng12,
  libsForQt5,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "engauge-digitizer";
  version = "12.2.2";

  src = fetchFromGitHub {
    owner = "akhuettel";
    repo = "engauge-digitizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wj9o3wWbtHsEi6LFH4xDpwVR9BwcWc472jJ/QFDQZvY=";
  };

  nativeBuildInputs = [
    qt5.qmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    libsForQt5.poppler
    libpng12
    openjpeg
    openjpeg.dev
    log4cpp
    libjpeg
    fftw
  ];

  qmakeFlags = [
    "CONFIG+=jpeg2000"
    "CONFIG+=pdf"
    "CONFIG+=log4cpp_null"
  ];

  env = {
    POPPLER_INCLUDE = "${libsForQt5.poppler.dev}/include/poppler/qt5";

    POPPLER_LIB = "${libsForQt5.poppler}/lib";

    OPENJPEG_INCLUDE = "${openjpeg.dev}/include/openjpeg-${lib.versions.majorMinor openjpeg.version}";

    OPENJPEG_LIB = "${openjpeg}/lib";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/engauge $out/bin/

    runHook postInstall
  '';

  meta = {
    description = "Engauge Digitizer is a tool for recovering graph data from an image file";
    mainProgram = "engauge";
    homepage = "https://markummitchell.github.io/engauge-digitizer";
    license = with lib.licenses; [ gpl2Only ];
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
