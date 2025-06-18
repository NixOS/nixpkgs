{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchFromGitHub,
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
  qt6Packages,
  kdePackages,
}:

let
  qlementine-icons-src = fetchFromGitHub {
    owner = "oclero";
    repo = "qlementine-icons";
    tag = "v1.8.0";
    hash = "sha256-FPndzMEOQvYNYUbT2V6iDlwoYqOww38GW/T3zUID3g0=";
  };

  qlementine-src = fetchFromGitHub {
    owner = "oclero";
    repo = "qlementine";
    tag = "v1.2.1";
    hash = "sha256-CPQMmTXyUW+CyLjHYx+IdXY4I2mVPudOmAksjd+izPA=";
  };

  qtappinstancemanager-src = fetchFromGitHub {
    owner = "oclero";
    repo = "qtappinstancemanager";
    tag = "v1.3.0";
    hash = "sha256-/zvNR/RHNV19ZI8d+58sotWxY16q2a7wWIBuKO52H5M=";
  };

  inherit (qt6Packages)
    qtbase
    qttools
    wrapQtAppsHook
    ;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "solarus-launcher";
  version = "2.0.0";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = "solarus-launcher";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zBJnHzYJyhfzP1m6TgMkDLRA3EXC1oG8PC0Jq/fC2+Q=";
  };

  patches = [
    (replaceVars ./github-fetches.patch {
      inherit qlementine-src qlementine-icons-src qtappinstancemanager-src;
    })
  ];

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
    qttools
    wrapQtAppsHook
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
    qtbase
    kdePackages.qtsvg
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
