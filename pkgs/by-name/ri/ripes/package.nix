{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qt6,
  cereal,
  cmake,
  python3,
  unstableGitUpdater,
}:

stdenv.mkDerivation rec {
  pname = "ripes";
  # Pulling unstable version as latest stable does not build against gcc-13.
  version = "2.2.6-unstable-2024-04-04";

  src = fetchFromGitHub {
    owner = "mortbopet";
    repo = "Ripes";
    rev = "878087332afa3558dc8ca657f80a16ecdcf82818";
    fetchSubmodules = true;
    hash = "sha256-aNJTM/s4GNhWVXQxK1R/rIN/NmeKglibQZMh8ENjIzo=";
  };

  postPatch = ''
    rm -r external/VSRTL/external/cereal
    substituteInPlace {src/serializers.h,src/io/iobase.h} \
      --replace-fail "VSRTL/external/cereal/include/cereal/cereal.hpp" "cereal/cereal.hpp"

    substituteInPlace external/libelfin/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.1)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    cereal
    qt6.qtbase
    qt6.qtsvg
    qt6.qtcharts
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    cp -r Ripes.app $out/Applications/
    makeBinaryWrapper $out/Applications/Ripes.app/Contents/MacOS/Ripes $out/bin/Ripes
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -D Ripes $out/bin/Ripes
  ''
  + ''
    cp -r ${src}/appdir/usr/share $out/share
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "Graphical processor simulator and assembly editor for the RISC-V ISA";
    homepage = "https://github.com/mortbopet/Ripes";
    license = licenses.mit;
    platforms = platforms.unix;
    mainProgram = "Ripes";
    maintainers = with maintainers; [ wineee ];
  };
}
