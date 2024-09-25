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
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "supermariowar";
  version = "2023-unstable-2024-09-17";

  src = fetchFromGitHub {
    owner = "mmatyas";
    repo = "supermariowar";
    rev = "6b8ff8c669ca31a116754d23b6ff65e42ac50733";
    hash = "sha256-P0jV7G81thj0UJoYLd5+H5SjjaVu4goJxc9IkbzxJgs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    pkg-config
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
      chmod +x $out/games/$app

      cat << EOF > $out/bin/$app
      $out/games/$app --datadir $out/share/games/smw
    EOF
      chmod +x $out/bin/$app
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
