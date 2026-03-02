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
  version = "0-unstable-2026-02-03";

  src = fetchFromGitHub {
    owner = "highscore-emu";
    repo = "mgba";
    rev = "178d7dbe3c2927f2fc52a6032bc7b6c805192e9b";
    hash = "sha256-AXOe2YoYQDeRpicYD9B9BR2l0rCJ+syYTwTnJUIcG1U=";
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
