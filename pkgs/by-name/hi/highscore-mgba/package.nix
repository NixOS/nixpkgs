{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libhighscore,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "highscore-mgba";
  version = "0-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "mgba";
    rev = "eeb3cf0f34af549d9224dd75a1e6cb6361d09aeb";
    hash = "sha256-yGUAnG8LnZ+hCV+uE1tGX2Zmp5Hriu7LQaWfXZTJqXk=";
  };

  outputs = [
    "out"
    "dev"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libhighscore
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_DEBUGGERS" false)
    (lib.cmakeBool "USE_EDITLINE" false)
    (lib.cmakeBool "ENABLE_GDB_STUB" false)
    (lib.cmakeBool "USE_ZLIB" false)
    (lib.cmakeBool "USE_MINIZIP" false)
    (lib.cmakeBool "USE_PNG" false)
    (lib.cmakeBool "USE_LIBZIP" false)
    (lib.cmakeBool "USE_SQLITE3" false)
    (lib.cmakeBool "USE_ELF" false)
    (lib.cmakeBool "USE_LUA" false)
    (lib.cmakeBool "USE_JSON_C" false)
    (lib.cmakeBool "USE_LZMA" false)
    (lib.cmakeBool "USE_DISCORD_RPC" false)
    (lib.cmakeBool "ENABLE_SCRIPTING" false)
    (lib.cmakeBool "BUILD_QT" false)
    (lib.cmakeBool "BUILD_SDL" false)
    (lib.cmakeBool "BUILD_HIGHSCORE" true)
    (lib.cmakeBool "SKIP_LIBRARY" true)
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of mGBA to Highscore";
    homepage = "https://github.com/highscore-emu/mednafen-highscore";
    license = lib.licenses.mpl20;
    inherit (libhighscore.meta) maintainers platforms;
  };
}
