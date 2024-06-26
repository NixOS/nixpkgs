{
  stdenv,
  lib,
  fetchFromGitHub,
  pkg-config,
  cmake,
  wrapQtAppsHook,
  libzip,
  boost,
  fftw,
  libusb1,
  qtbase,
  qtsvg,
  qtwayland,
  python3,
  desktopToDarwinBundle,
}:

stdenv.mkDerivation rec {
  pname = "dsview";

  version = "1.3.2";

  src = fetchFromGitHub {
    owner = "DreamSourceLab";
    repo = "DSView";
    rev = "v${version}";
    sha256 = "sha256-d/TfCuJzAM0WObOiBhgfsTirlvdROrlCm+oL1cqUrIs=";
  };

  patches = [
    # Fix absolute install paths
    ./install.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ] ++ lib.optional stdenv.isDarwin desktopToDarwinBundle;

  buildInputs = [
    boost
    fftw
    qtbase
    qtsvg
    libusb1
    libzip
    python3
  ] ++ lib.optional stdenv.isLinux qtwayland;

  meta = with lib; {
    description = "GUI program for supporting various instruments from DreamSourceLab, including logic analyzer, oscilloscope, etc";
    mainProgram = "DSView";
    homepage = "https://www.dreamsourcelab.com/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [
      bachp
      carlossless
    ];
  };
}
