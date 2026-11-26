{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  kdePackages,
  obs-studio,
  qt6,
  libxt,
  libxtst,
  libxi,
  libxinerama,
  libxext,
  libxdmcp,
  libxau,
  libx11,
  libxkbcommon,
  libxkbfile,
  sdl3,
  libinput,
  libxrandr,
  udev,
  wayland,
  wayland-protocols,
  wayland-scanner,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-input-overlay";
  version = "5.1.3";

  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "input-overlay";
    tag = finalAttrs.version;
    hash = "sha256-ilhb2bLC7844FDhOoTXJ4JF4RoAjrs2Cb8QPnwVUPV8=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
    kdePackages.extra-cmake-modules
    wayland-scanner
  ];

  buildInputs = [
    obs-studio
    qt6.qtbase
    sdl3
    libx11
    libxau
    libxdmcp
    libxtst
    libxext
    libxi
    libxt
    libxinerama
    libxkbcommon
    libxkbfile
    libinput
    libxrandr
    udev
    wayland
    wayland-protocols
  ];

  cmakeFlags = lib.optionals stdenv.hostPlatform.isx86 [
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
    inherit (obs-studio.meta) platforms;
  };
})
