{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  zlib,
  openjpeg,
  libjpeg_turbo,
  libpng,
  libtiff,
  boost,
  libcanberra,
}:

stdenv.mkDerivation rec {
  pname = "scantailor-universal";
  version = "0.2.14";

  src = fetchFromGitHub {
    owner = "trufanov-nok";
    repo = pname;
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-n8NbokK+U0FAuYXtjRJcxlI1XAmI4hk5zV3sF86hB/s=";
  };

  buildInputs = [
    libsForQt5.qtbase
    zlib
    libjpeg_turbo
    libpng
    libtiff
    boost
    libcanberra
    openjpeg
  ];
  nativeBuildInputs = [
    cmake
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
  ];

  meta = {
    description = "Interactive post-processing tool for scanned pages";
    homepage = "https://github.com/trufanov-nok/scantailor";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ unclamped ];
    platforms = lib.platforms.unix;
    mainProgram = "scantailor-universal-cli";
  };
}
