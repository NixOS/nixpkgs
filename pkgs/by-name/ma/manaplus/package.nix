{
  stdenv,
  lib,
  fetchFromGitLab,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  SDL2_mixer,
  SDL2_net,
  SDL2_gfx,
  zlib,
  physfs,
  curl,
  libxml2,
  libpng,
  pkg-config,
  libGL,
  autoreconfHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "manaplus";
  version = "2.1.3.17-unstable-2024-08-15";

  src = fetchFromGitLab {
    owner = "manaplus";
    repo = "manaplus";
    rev = "40ebe02e81b34f5b02ea682d2d470a20e7e63cfc";
    sha256 = "sha256-OVmCqK8undrBKgY5bB2spezmYwWXnmrPlSpV5euortc=";
  };

  # The unstable version has this commit that fixes missing <cstdint> include:
  # https://gitlab.com/manaplus/manaplus/-/commit/63912a8a6bfaecdb6b40d2a89191a2fb5af32906
  patches = [
    # https://gitlab.com/manaplus/manaplus/-/issues/33
    ./0001-libxml2-const-ptr-and-missing-include.patch
    # https://gitlab.com/manaplus/manaplus/-/issues/32
    ./0002-missing-ctime-include.patch
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_gfx
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_ttf
    curl
    libGL
    libpng
    libxml2
    physfs
    zlib
  ];

  strictDeps = true;

  configureFlags = [
    (lib.withFeature true "sdl2")
    (lib.withFeature false "dyecmd")
    (lib.withFeature false "internalsdlgfx")
  ];

  enableParallelBuilding = true;

  meta = {
    maintainers = [ ];
    description = "Free OpenSource 2D MMORPG client";
    homepage = "https://manaplus.org/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    badPlatforms = [ lib.systems.inspect.patterns.isDarwin ];
  };
})
