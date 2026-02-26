{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  enet,
  yaml-cpp,
  SDL2,
  SDL2_image,
  SDL2_mixer,
  zlib,
  unstableGitUpdater,
  makeWrapper,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "supermariowar";
  version = "2025-unstable-2026-02-23";

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "supermariowar";
    rev = "7252b2c81804d0ca54da322314da95d5a7652535";
    hash = "sha256-57HoR/bG5z4+2WKbvmiJM3nCd1s3n/5yXAiLwin5lgE=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
  ];

  buildInputs = [
    enet
    yaml-cpp
    SDL2
    SDL2_image
    SDL2_mixer
    zlib
  ];

  cmakeFlags = [ "-DBUILD_STATIC_LIBS=OFF" ];

  postInstall = ''
    mkdir -p $out/bin

    for app in smw smw-leveledit smw-worldedit; do
      makeWrapper $out/games/$app $out/bin/$app \
        --add-flags "--datadir $out/share/games/smw"
    done

    ln -s $out/games/smw-server $out/bin/smw-server
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Fan-made multiplayer Super Mario Bros. style deathmatch game";
    homepage = "https://github.com/mmatyas/supermariowar";
    changelog = "https://github.com/mmatyas/supermariowar/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "smw";
    platforms = lib.platforms.linux;
  };
})
