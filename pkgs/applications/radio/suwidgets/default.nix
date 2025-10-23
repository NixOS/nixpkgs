{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  qtbase,
  pkg-config,
  sigutils,
  fftwSinglePrec,
}:

stdenv.mkDerivation {
  pname = "suwidgets";
  version = "unstable-2022-04-03";

  src = fetchFromGitHub {
    owner = "BatchDrake";
    repo = "SuWidgets";
    rev = "826b3eeae5b682dc063f53b427caa9c7c48131ea";
    sha256 = "sha256-cyFLsP+8GbALdlgEnVX4201Qq/KAxb/Vv+sJqbFpvUk=";
  };

  dontWrapQtApps = true;

  postPatch = ''
    substituteInPlace SuWidgets.pri \
      --replace "PKGCONFIG += sigutils fftw3" "PKGCONFIG += sigutils fftw3f"
  '';

  nativeBuildInputs = [
    qmake
    pkg-config
  ];

  buildInputs = [
    qtbase
    sigutils
    fftwSinglePrec
  ];

  qmakeFlags = [
    "SuWidgetsLib.pro"
  ];

  meta = with lib; {
    description = "Sigutils-related widgets";
    homepage = "https://github.com/BatchDrake/SuWidgets";
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [
      polygon
      oxapentane
    ];
  };
}
