{
  lib,
  stdenv,
  fetchpatch,
  qlementine,
  cmake,
  ninja,
  luajit,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  physfs,
  openal,
  libmodplug,
  libvorbis,
  solarus,
  glm,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solarus-quest-editor";
  inherit (solarus) version;

  src = solarus.src + "/editor";

  patches = [
    # Fix build with Qt 6.12, remove with the next release
    # https://gitlab.com/solarus-games/solarus/-/merge_requests/1758
    (fetchpatch {
      url = "https://gitlab.com/solarus-games/solarus/-/commit/e0eca6af65f7a96951d23fb3108489d08aed5825.patch";
      relative = "editor";
      excludes = [ "changelog.md" ];
      hash = "sha256-fQqTTbieccS0CgSfq3Vh8j8JwDN9zaWC9YjmxcyE3AY=";
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    luajit
    SDL2
    SDL2_image
    SDL2_ttf
    physfs
    openal
    libmodplug
    libvorbis
    solarus
    qt6.qtbase
    qt6.qtsvg
    glm
  ];

  cmakeFlags = [
    (lib.cmakeBool "SOLARUS_USE_LOCAL_QLEMENTINE" true)
    (lib.cmakeFeature "SOLARUS_QLEMENTINE_LOCAL_PATH" "${qlementine.src}")
  ];

  meta = {
    description = "Editor for the Zelda-like ARPG game engine, Solarus";
    mainProgram = "solarus-editor";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been written for the engine.
      Games can be created easily using the editor.
    '';
    homepage = "https://www.solarus-games.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marcin-serwin ];
    platforms = lib.platforms.linux;
  };
})
