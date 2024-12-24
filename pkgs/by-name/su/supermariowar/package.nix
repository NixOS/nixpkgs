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
  version = "2023-unstable-2024-10-17";

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "supermariowar";
    rev = "a04d6f4069d2ef90a76bf562d1fd937c9cf56140";
    hash = "sha256-4WsjSjT3uN5hBqUtH6UaTxHUYkwvjiYrWzRqY3vBpAE=";
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
    description = "A fan-made multiplayer Super Mario Bros. style deathmatch game";
    homepage = "https://github.com/mmatyas/supermariowar";
    changelog = "https://github.com/mmatyas/supermariowar/blob/${finalAttrs.src.rev}/CHANGELOG";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ theobori ];
    mainProgram = "smw";
    platforms = lib.platforms.linux;
  };
})
