{
  lib,
  stdenv,
  fetchFromGitLab,
  replaceVars,
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
  version = "2.0.0";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = "solarus-quest-editor";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GTslxValldReWGb3x67zRPrvQUuCO/HQSXOEQlJfAmw=";
  };

  patches = [
    (replaceVars ./qlementine-src.patch { qlementine-src = qlementine.src; })
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
