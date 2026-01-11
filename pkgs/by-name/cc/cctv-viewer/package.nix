{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt5,
  ffmpeg,
  gtest,
  libva,
}:

stdenv.mkDerivation {
  pname = "cctv-viewer";
  version = "0.1.9-unstable-2025-06-13";

  src = fetchFromGitHub {
    owner = "iEvgeny";
    repo = "cctv-viewer";
    rev = "8a8fff2612ae2123b8be156c954a29706383b480";
    hash = "sha256-Euw9S+iONAEENkFwo169x/+pcyeTXLe8wb70KKjv3bE=";
    fetchSubmodules = true;
  };

  cmakeFlags = [
    "-DBUILD_TESTS=OFF"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt5.wrapQtAppsHook
    qt5.qttools
    gtest
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtquickcontrols2
    qt5.qtsvg
    qt5.qtmultimedia
    qt5.qtgraphicaleffects
    ffmpeg
    libva
  ];

  installPhase = ''
    runHook preInstall

    install -D cctv-viewer --target-directory=$out/bin
    install -Dm644 $src/cctv-viewer.desktop --target-directory=$out/share/applications
    install -Dm644 $src/images/cctv-viewer.svg --target-directory=$out/share/icons/hicolor/scalable/apps

    runHook postInstall
  '';

  meta = {
    description = "Viewer and mounter for video streams";
    homepage = "https://cctv-viewer.org";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ teohz ];
    platforms = lib.platforms.linux;
  };
}
