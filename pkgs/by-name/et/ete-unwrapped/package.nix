{
  lib,
  stdenv,
  fetchFromGitHub,
  cjson,
  cmake,
  curl,
  freetype,
  glew,
  libjpeg,
  libogg,
  libpng,
  libtheora,
  libX11,
  lua5_4,
  minizip,
  openal,
  SDL2,
  sqlite,
  zlib,
}:
let
  arch = if stdenv.hostPlatform.isi686 then "x86" else "x86_64";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "ete-unwrapped";
  version = "0-unstable-2025-08-17";

  src = fetchFromGitHub {
    owner = "etfdevs";
    repo = "ETe";
    rev = "f6a9fda3b82c1ca8fd4536ae928571e93ff91fcc";
    hash = "sha256-oTFtUAgkDYtbcw66EFBBFMMUEYWSHYpTAFAv1izqsuo=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    cjson
    curl
    freetype
    glew
    libjpeg
    libogg
    libpng
    libtheora
    libX11
    lua5_4
    minizip
    openal
    SDL2
    sqlite
    zlib
  ];

  cmakeDir = "../src";
  cmakeFlags = [
    (lib.cmakeBool "CROSS_COMPILE32" false)
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeBool "BUILD_DEDSERVER" true)
    (lib.cmakeBool "BUILD_CLIENT" true)
    (lib.cmakeBool "BUILD_ETMAIN_MOD" true)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/lib/ete")
  ];

  postInstall = ''
    mkdir -p $out/bin
    for f in ete-ded.${arch} ete.${arch}; do
      mv $out/lib/ete/''${f} $out/bin/''${f}
    done
  '';

  meta = {
    description = "Improved Wolfenstein: Enemy Territory Engine";
    homepage = "https://github.com/etfdevs/ETe";
    license = with lib.licenses; [ gpl3Plus ];
    maintainers = with lib.maintainers; [
      ashleyghooper
      drupol
    ];
  };
})
