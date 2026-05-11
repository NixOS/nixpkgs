{
  lib,
  stdenv,
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
      Many full-fledged games have been writen for the engine.
      Games can be created easily using the editor.
    '';
    homepage = "https://www.solarus-games.org";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ marcin-serwin ];
    platforms = lib.platforms.linux;
  };
})
