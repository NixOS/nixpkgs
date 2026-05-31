{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
  exiv2,
  mpv,
  opencv4,
}:

stdenv.mkDerivation {
  pname = "qimgv";
  version = "1.0.3-unstable-2026-01-19";

  src = fetchFromGitHub {
    owner = "easymodo";
    repo = "qimgv";
    rev = "3127a2d211b124ad4fcf853d01e6df9323bdfdc3";
    sha256 = "sha256-avn02kdMyA5PZUSykxgIk1I78zHQ/WKd26tQO8lMOow=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
  ];

  cmakeFlags = [
    "-DVIDEO_SUPPORT=ON"
    "-DUSE_QT5=OFF"
    "-DKDE_SUPPORT=ON"
  ];

  buildInputs = [
    exiv2
    mpv
    opencv4.cxxdev
    kdePackages.qtbase
    kdePackages.qtimageformats
    kdePackages.qtsvg
    kdePackages.qttools
    kdePackages.kimageformats
    kdePackages.kwindowsystem
  ];

  postPatch = ''
    sed -i "s@/usr/bin/mpv@${mpv}/bin/mpv@" \
      qimgv/settings.cpp
  '';

  # Wrap the library path so it can see `libqimgv_player_mpv.so`, which is used
  # to play video files within qimgv itself.
  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${placeholder "out"}/lib"
  ];

  meta = {
    description = "Qt6 image viewer with optional video support";
    mainProgram = "qimgv";
    homepage = "https://github.com/easymodo/qimgv";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ cole-h ];
  };
}
