{
  lib,
  stdenv,
  fetchFromCodeberg,
  meson,
  ninja,
  pkg-config,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  SDL2_net,
  SDL2_gfx,
  libgit2,
  curl,
  physfs,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "brux-gdk";
  version = "0.2.11-unstable-2026-08-18";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromCodeberg {
    owner = "KelvinShadewing";
    repo = "brux-gdk";
    rev = "d8e73aa44d39029421738a1606ac78c79b98d2c1";
    hash = "sha256-/7EZ8DLpwEEqx7Nxu/Td35fBYqH42rYtGz4PH/aeaRE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    SDL2
    SDL2_image
    SDL2_mixer
    SDL2_net
    SDL2_gfx
    libgit2
    curl
    physfs
  ];

  dontUseCmakeConfigure = true;
  dontUseMesonConfigure = true;

  buildPhase = ''
    runHook preBuild
    patchShebangs rte

    meson setup rte/build rte --prefix "$out"
    meson compile -C rte/build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    meson install -C rte/build
    mkdir -p "$out/bin"
    mv "$out/brux" "$out/bin/brux"

    runHook postInstall
  '';

  meta = {
    description = "2D game engine used by SuperTux Advance and other games written in Squirrel";
    homepage = "https://codeberg.org/KelvinShadewing/brux-gdk";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ philocalyst ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "brux";
  };
})
