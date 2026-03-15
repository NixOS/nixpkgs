{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  obs-studio,
  onnxruntime,
  opencv,
  qt6,
  pkg-config,
  curl,
}:

stdenv.mkDerivation rec {
  pname = "obs-backgroundremoval";
  version = "1.3.7";

  src = fetchFromGitHub {
    owner = "royshil";
    repo = "obs-backgroundremoval";
    rev = version;
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
    "--preset ubuntu-x86_64"
    "-DCMAKE_MODULE_PATH:PATH=${src}/cmake"
    "-DVCPKG_TARGET_TRIPLET="
    "-DUSE_PKGCONFIG=ON"
    "-DUSE_SYSTEM_ONNXRUNTIME=ON"
    "-DUSE_SYSTEM_OPENCV=ON"
    "-DDISABLE_ONNXRUNTIME_GPU=ON"
  ];

  buildPhase = ''
    cd ..
    cmake --build build_x86_64 --parallel
  '';

  installPhase = ''
    cmake --install build_x86_64 --prefix "$out"
  '';

  meta = {
    description = "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/royshil/obs-backgroundremoval";
    maintainers = with lib.maintainers; [ zahrun ];
    license = lib.licenses.mit;
    inherit (obs-studio.meta) platforms;
  };
}
