{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  curl,
  gd,
  libX11,
  libxml2,
  libzip,
  SDL,
  SDL_image,
  SDL_mixer,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "openlierox";
  version = "0.58_rc5";

  src = fetchFromGitHub {
    owner = "albertz";
    repo = "openlierox";
    rev = finalAttrs.version;
    hash = "sha256-4ofjroEHlfrQitc7M+YTNWut0LGgntgQoOeBWU8nscY=";
  };

  postPatch = ''
    sed 1i'#include <cstdint>' -i src/common/s*x.cpp
    sed 1i'#include <libxml/parser.h>' -i include/XMLutils.h
    substituteInPlace src/common/StringUtils.cpp \
        --replace-fail "xmlErrorPtr" "const xmlError*"

    substituteInPlace CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 2.4)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace CMakeOlxCommon.cmake \
      --replace-fail "cmake_minimum_required(VERSION 2.4)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "cmake_policy(VERSION 2.4)" "cmake_policy(VERSION 3.10)" \
      --replace-fail "cmake_policy(SET CMP0005 OLD)" "" \
      --replace-fail "cmake_policy(SET CMP0003 OLD)" "" \
      --replace-fail "cmake_policy(SET CMP0011 OLD)" ""
  '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    SDL
  ];

  buildInputs = [
    curl
    gd
    libX11
    libxml2
    libzip
    SDL
    SDL_image
    SDL_mixer
    zlib
  ];

  cmakeFlags = [ "-DSYSTEM_DATA_DIR=${placeholder "out"}/share" ];

  env.NIX_CFLAGS_COMPILE = "-I${lib.getDev libxml2}/include/libxml2";

  installPhase = ''
    runHook preInstall

    install -Dm755 bin/* -t $out/bin

    mkdir -p $out/share/OpenLieroX
    cp -r ../share/gamedir/* $out/share/OpenLieroX

    runHook postInstall
  '';

  meta = {
    description = "Real-time game with Worms-like shooting";
    homepage = "http://openlierox.net";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "openlierox";
    maintainers = with lib.maintainers; [ tomasajt ];
    platforms = lib.platforms.linux;
  };
})
