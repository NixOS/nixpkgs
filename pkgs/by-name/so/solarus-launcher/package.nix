{
  lib,
  stdenv,
  replaceVars,
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
  qlementine,
  qlementine-icons,
  qtappinstancemanager,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solarus-launcher";
  inherit (solarus) version;

  src = solarus.src + "/launcher";

  patches = [
    (replaceVars ./github-fetches.patch {
      qlementine-src = qlementine.src;
      qlementine-icons-src = qlementine-icons.src;
      qtappinstancemanager-src = qtappinstancemanager.src;
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

  meta = {
    description = "Launcher for the Zelda-like ARPG game engine, Solarus";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been writen for the engine.
      Games can be created easily using the editor.
    '';
    homepage = "https://www.solarus-games.org";
    mainProgram = "solarus-launcher";
    license = with lib.licenses; [
      # code
      gpl3Plus
      # assets
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ marcin-serwin ];
    platforms = lib.platforms.linux;
  };
})
