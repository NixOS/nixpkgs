{ lib, stdenv, fetchFromGitHub, fftw, libjpeg, log4cpp, openjpeg
, libpng12, poppler, qtbase, qt5, qmake, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "engauge-digitizer";
  version = "12.2.2";

  src = fetchFromGitHub {
    owner = "markummitchell";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-Wj9o3wWbtHsEi6LFH4xDpwVR9BwcWc472jJ/QFDQZvY=";
  };

  nativeBuildInputs = [ qmake wrapQtAppsHook ];

  buildInputs = [
    qtbase
    qt5.qttools
    poppler
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

  POPPLER_INCLUDE = "${poppler.dev}/include/poppler/qt5";

  POPPLER_LIB = "${poppler}/lib";

  OPENJPEG_INCLUDE = "${openjpeg.dev}/include/${openjpeg.pname}-${lib.versions.majorMinor openjpeg.version}";

  OPENJPEG_LIB = "${openjpeg}/lib";

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp bin/engauge $out/bin/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Engauge Digitizer is a tool for recovering graph data from an image file";
    mainProgram = "engauge";
    homepage = "https://markummitchell.github.io/engauge-digitizer";
    license = with licenses; [ gpl2Only ];
    platforms = platforms.linux;
    maintainers = [ maintainers.sheepforce ];
  };
}
