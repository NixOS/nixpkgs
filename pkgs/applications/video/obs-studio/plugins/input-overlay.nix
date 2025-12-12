{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  ninja,
  obs-studio,
  qtbase,
  xorg,
  libxkbcommon,
  libxkbfile,
  sdl3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-input-overlay";
  version = "5.1.0-unstable-2025-09-23";

  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "input-overlay";
    rev = "4d62e7d0c55f8ff62c3a0e7b1a8f3092086b23b7";
    hash = "sha256-cUULaOoV4fffEvsHkcG3lnFCIHSvnv3LHg+SDuuVLao=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    obs-studio
    qtbase
    sdl3
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

  cmakeFlags = lib.optionals stdenv.hostPlatform.isx86 [
    "-DCMAKE_CXX_FLAGS=-msse4.1"
  ];

  postUnpack = ''
    sed -i '/set(CMAKE_CXX_FLAGS "-march=native")/d' 'source/CMakeLists.txt'
  '';

  preFixup = ''
    # Remove broken uiohook development files
    rm -r $out/lib/cmake $out/lib/pkgconfig
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
