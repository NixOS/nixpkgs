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
  version = "5.0.5";
  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "input-overlay";
    rev = "v${version}";
    hash = "sha256-9HqEz+KnTt8MyhwqFWjalbl3H/DCzumckXMctCGhs3o=";
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

  postInstall = ''
    mkdir $out/lib $out/share
    mv $out/obs-plugins/64bit $out/lib/obs-plugins
    rm -rf $out/obs-plugins
    mv $out/data $out/share/obs
  '';

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Show keyboard, gamepad and mouse input on stream";
    homepage = "https://github.com/univrsal/input-overlay";
    maintainers = with maintainers; [ glittershark ];
    license = licenses.gpl2;
    platforms = platforms.linux;
    # never built on aarch64-linux since first introduction in nixpkgs
    broken = stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64;
  };
}
