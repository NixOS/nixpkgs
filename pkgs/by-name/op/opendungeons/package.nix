{
  lib,
  stdenv,
  ogre_13,
  cegui,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # buildInputs
  boost183,
  ois,
  openal,
  sfml_2,

  # passthru
  unstableGitUpdater,
}:

let
  ogre' = ogre_13.overrideAttrs (old: {
    cmakeFlags = old.cmakeFlags ++ [
      "-DOGRE_RESOURCEMANAGER_STRICT=0"
    ];
  });
  cegui' = cegui.override {
    ogre = ogre';
  };
in
stdenv.mkDerivation {
  pname = "opendungeons";
  version = "0-unstable-2024-07-27";

  src = fetchFromGitHub {
    owner = "paroj";
    repo = "OpenDungeons";
    rev = "2574db9fbe99aeb6a058b7a27bc191da37978c95";
    hash = "sha256-EeyLwZmaVzzbxPA4PIooVbw12wYb131x+rnIB8n4fgg=";
  };

  patches = [
    ./cmakepaths.patch
    ./fix_link_date_time.patch
  ];

  # source/utils/StackTraceUnix.cpp:122:2: error: #error Unsupported architecture.
  postPatch =
    lib.optionalString (!stdenv.hostPlatform.isx86_64) ''
      cp source/utils/StackTrace{Stub,Unix}.cpp
    ''
    + ''
      substituteInPlace CMakeLists.txt \
        --replace-fail "cmake_minimum_required(VERSION 2.8)" "cmake_minimum_required(VERSION 3.10)"
    '';

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost183
    cegui'
    ogre'
    ois
    openal
    sfml_2
  ];

  cmakeFlags = [
    (lib.cmakeBool "OD_TREAT_WARNINGS_AS_ERRORS" false)
  ];

  passthru = {
    updateScript = unstableGitUpdater { };
  };

  meta = {
    description = "Open source, real time strategy game sharing game elements with the Dungeon Keeper series and Evil Genius";
    mainProgram = "opendungeons";
    homepage = "https://opendungeons.github.io";
    license = with lib.licenses; [
      gpl3Plus
      zlib
      mit
      cc-by-sa-30
      cc0
      ofl
      cc-by-30
    ];
    platforms = lib.platforms.linux;
  };
}
