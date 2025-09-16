{
  stdenv,
  lib,
  fetchFromGitHub,
  qtbase,
  qttools,
  qtsvg,
  qt5compat,
  opencascade-occt,
  libGLU,
  cmake,
  wrapQtAppsHook,
  rustPlatform,
  cargo,
  rustc,
}:

stdenv.mkDerivation rec {
  pname = "librepcb";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "librepcb";
    repo = "librepcb";
    rev = version;
    hash = "sha256-J4y0ikZNuOguN9msmEQzgcY0/REnOEOoDkY/ga+Cfd8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qttools
    qtsvg
    qt5compat
    wrapQtAppsHook
    opencascade-occt
    libGLU
    rustPlatform.cargoSetupHook
    cargo
    rustc
  ];
  buildInputs = [ qtbase ];

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit src cargoRoot;
    hash = "sha256-1td3WjxbDq2lX7c0trpYRhO82ChNAG/ZABBRsekYtq4=";
  };

  cargoRoot = "libs/librepcb/rust-core";

  meta = with lib; {
    description = "Free EDA software to develop printed circuit boards";
    homepage = "https://librepcb.org/";
    maintainers = with maintainers; [
      luz
      thoughtpolice
    ];
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
  };
}
