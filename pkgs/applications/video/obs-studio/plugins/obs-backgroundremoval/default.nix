{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  obs-studio,
  onnxruntime,
  opencv,
  qt6,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "obs-backgroundremoval";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "occ-ai";
    repo = "obs-backgroundremoval";
    tag = version;
    hash = "sha256-bl0KixfBnBeyidZ4+RJhX4TDy33l9awo0wISMr7XUwk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    obs-studio
    onnxruntime
    opencv.cxxdev
    qt6.qtbase
    curl
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "-DUSE_SYSTEM_ONNXRUNTIME=ON"
    "-DUSE_SYSTEM_OPENCV=ON"
    "-DENABLE_FRONTEND_API=OFF"
    "-DENABLE_QT=OFF"
  ];

  meta = {
    description = "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/occ-ai/obs-backgroundremoval";
    maintainers = with lib.maintainers; [
      randomizedcoder
      zahrun
    ];
    license = lib.licenses.mit;
    inherit (obs-studio.meta) platforms;
  };
}
