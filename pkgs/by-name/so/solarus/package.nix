{
  lib,
  stdenv,
  fetchFromGitLab,
<<<<<<< HEAD
  nix-update-script,
=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
<<<<<<< HEAD
  version = "2.0.2";
=======
  version = "2.0.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitLab {
    owner = "solarus-games";
    repo = "solarus";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-KkklmukX4qDni1SY002YvIB/LR03b9zSIBSIWVaMC5U=";
=======
    rev = "e70e3df7369d690615fc4c9b3f8dfa00066c5e87";
    hash = "sha256-NOHv4b+r2WnyHEVLtcox+8+3Q3TtSDHB7vpKSTDHVKM=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

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

<<<<<<< HEAD
  passthru.updateScript = nix-update-script { };

=======
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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
