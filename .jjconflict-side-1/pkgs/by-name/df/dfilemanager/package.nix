{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  file,
}:

stdenv.mkDerivation {
  pname = "dfilemanager";
  version = "unstable-2021-02-20";

  src = fetchFromGitHub {
    owner = "probonopd";
    repo = "dfilemanager";
    rev = "61179500a92575e05cf9a71d401c388726bfd73d";
    hash = "sha256-BHd2dZDVxy82vR6PyXIS5M6zBGJ4bQfOhdBCdOww4kc=";
  };

  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
  ];
  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    libsForQt5.solid
    file
  ];

  cmakeFlags = [ "-DQT5BUILD=true" ];

  meta = {
    homepage = "https://github.com/probonopd/dfilemanager";
    description = "File manager written in Qt/C++";
    mainProgram = "dfm";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
