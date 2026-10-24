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
  libx11,
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
  version = "0-unstable-2026-06-21";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "etfdevs";
    repo = "ETe";
    rev = "c769004c557e2afabf41f847b32cfb4762ae2521";
    hash = "sha256-VW7cJb7bRW/IUP2kg2N6cgX2KGo3nFp3NOH8rGFvQwk=";
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
    libx11
    minizip
    openal
    SDL2
    sqlite
    zlib
  ];

  cmakeDir = "../src";
  cmakeFlags = [
    (lib.cmakeBool "CROSS_COMPILE32" false)
    (lib.cmakeBool "BUILD_DEDSERVER" true)
    (lib.cmakeBool "BUILD_CLIENT" true)
    (lib.cmakeBool "BUILD_ETMAIN_MOD" true)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/lib/ete")
  ];

  postInstall = ''
    for f in ete-ded.${arch} ete.${arch}; do
      install -Dm755 \
        "$out/lib/ete/$f" \
        "$out/bin/$f"
      rm "$out/lib/ete/$f"
    done
  '';

  meta = {
    description = "Improved Wolfenstein: Enemy Territory Engine";
    homepage = "https://github.com/etfdevs/ETe";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      ashleyghooper
      drupol
    ];
  };
})
