{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  obs-studio,
  libuiohook,
  qtbase,
  xorg,
  libxkbcommon,
  libxkbfile,
  SDL2,
}:

stdenv.mkDerivation rec {
  pname = "obs-input-overlay";
  version = "5.0.6";

  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "input-overlay";
    rev = "refs/tags/${version}";
    hash = "sha256-ju4u7hhx+hTuq7Oh0DBPV8RRM8zqyyvYV74KymU0+2c=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    obs-studio
    libuiohook
    qtbase
    SDL2
    xorg.libX11
    xorg.libXau
    xorg.libXdmcp
    xorg.libXtst
    xorg.libXext
    xorg.libXi
    xorg.libXt
    xorg.libXinerama
    libxkbcommon
    libxkbfile
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_FLAGS=-msse4.1"
  ];

  postUnpack = ''
    sed -i '/set(CMAKE_CXX_FLAGS "-march=native")/d' 'source/CMakeLists.txt'
  '';

  dontWrapQtApps = true;

  meta = {
    description = "Show keyboard, gamepad and mouse input on stream";
    homepage = "https://github.com/univrsal/input-overlay";
    maintainers = with lib.maintainers; [ glittershark ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
}
