{ lib
, stdenv
, fetchFromGitHub
, SDL2
, cmake
, ffmpeg
, glew
, libzip
, pkg-config
, python3
, qtbase
, qtmultimedia
, snappy
, wrapQtAppsHook
, zlib
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ppsspp";
  version = "1.13.1";

  src = fetchFromGitHub {
    owner = "hrydgard";
    repo = "ppsspp";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    sha256 = "sha256-WsFy2aSOmkII2Lte5et4W6qj0AXUKWWkYe88T0OQP08=";
  };

  postPatch = ''
    substituteInPlace git-version.cmake --replace unknown ${finalAttrs.src.rev}
    substituteInPlace UI/NativeApp.cpp --replace /usr/share $out/share
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    wrapQtAppsHook
  ];

  buildInputs = [
    SDL2
    ffmpeg
    glew
    libzip
    qtbase
    qtmultimedia
    snappy
    zlib
  ];

  cmakeFlags = [
    "-DHEADLESS=OFF"
    "-DOpenGL_GL_PREFERENCE=GLVND"
    "-DUSE_SYSTEM_FFMPEG=ON"
    "-DUSE_SYSTEM_LIBZIP=ON"
    "-DUSE_SYSTEM_SNAPPY=ON"
    "-DUSING_QT_UI=ON"
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/ppsspp
    install -Dm555 PPSSPPQt $out/bin/ppsspp
    mv assets $out/share/ppsspp
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.ppsspp.org/";
    description = "A HLE Playstation Portable emulator, written in C++";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
})
# TODO: add SDL headless port
