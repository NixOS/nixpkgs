{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  ninja,
  luajit,
  SDL2,
  SDL2_image,
  SDL2_ttf,
  physfs,
  glm,
  openal,
  libmodplug,
  libvorbis,

  # tests
  solarus-quest-editor,
  solarus-launcher,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "solarus";
  version = "2.0.0";

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = "solarus";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Kfg4pFZrEhsIU4RQlOox3hMpk2PXbOzrkwDElPGnDjA=";
  };

  patches = [
    # https://gitlab.com/solarus-games/solarus/-/merge_requests/1570
    (fetchpatch {
      url = "https://gitlab.com/solarus-games/solarus/-/commit/8e1eee51cbfa5acf2511b059739153065b0ba21d.patch";
      hash = "sha256-KevGavtUhpHRt85WLh9ApmZ8a+NeWB1zDDHKGT08yhQ=";
    })
  ];

  outputs = [
    "out"
    "lib"
    "dev"
  ];

  strictDeps = true;
  nativeBuildInputs = [
    cmake
    ninja
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
    glm
  ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-DGLM_ENABLE_EXPERIMENTAL")
    (lib.cmakeFeature "CMAKE_INSTALL_DATADIR" "${placeholder "lib"}/share")
  ];

  passthru.tests = {
    inherit solarus-quest-editor solarus-launcher;
  };

  meta = {
    description = "Zelda-like ARPG game engine";
    longDescription = ''
      Solarus is a game engine for Zelda-like ARPG games written in lua.
      Many full-fledged games have been writen for the engine.
    '';
    homepage = "https://www.solarus-games.org";
    mainProgram = "solarus-run";
    license = with lib.licenses; [
      # code
      gpl3Plus
      # assets
      cc-by-sa-30
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ marcin-serwin ];
    platforms = lib.platforms.linux;
  };
})
