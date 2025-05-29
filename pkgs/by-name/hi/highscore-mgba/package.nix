{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libhighscore,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "highscore-mgba";
  version = "0-unstable-2024-12-24";

  src = fetchFromGitHub {
    owner = "alice-mkh";
    repo = "mgba";
    rev = "dc524940d5439aa7efe13e7339abad5cb2b30df5";
    hash = "sha256-YA8TBrqIedij9W9XuS7NeRqdHHfcwzxR22XOPOFSNsI=";
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
    url = finalAttrs.src.gitRepoUrl;
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Port of mGBA to Highscore";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})
