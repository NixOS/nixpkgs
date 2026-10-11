{
  lib,
  clangStdenv,
  fetchFromGitHub,
  cmake,
  git,
  boost,
  openssl,
  zlib,
  readline,
  bzip2,
  mysql84,

  modules ? {
    mod-guildhouse = fetchFromGitHub {
      owner = "azerothcore";
      repo = "mod-guildhouse";
      rev = "23b86dcc78471c50c60b3fc27e07e4cda8a3e200";
      hash = "sha256-K1N9iYoQFmhK079JVOsD27xzFH1CmWxKk0DfVegZFJM=";
    };
    mod-autobalance = fetchFromGitHub {
      owner = "azerothcore";
      repo = "mod-autobalance";
      rev = "2bf60989fc2384d4f92be4e2804aeca0ac6ed077";
      hash = "sha256-kgkVlu1d9Dz5T3GD/e37QZHkCZKjut+PFkCo+PRkAUE=";
    };
    mod-ah-bot = fetchFromGitHub {
      owner = "azerothcore";
      repo = "mod-ah-bot";
      rev = "60d80b8673abb722178d9bd64349d0ff4765de98";
      hash = "sha256-EkQhR64/pAhYDjsSlwRs/4uN3WfbZNbu2czwht2u8x8=";
    };
  },
  buildTools ? "all",
  buildApps ? "all",
  buildScripts ? "static",
  buildModules ? "static",
}:

let
  linkModules = lib.concatMapAttrsStringSep "\n" (
    name: source: ''ln -s "${source}" "modules/${name}"''
  );
in
clangStdenv.mkDerivation (finalAttrs: {
  pname = "azerothcore";
  version = "4.0.0-unstable-20250322";

  src = fetchFromGitHub {
    owner = "azerothcore";
    repo = "azerothcore-wotlk";
    rev = "ae76703b755cbb73efc76c768a8859bf140f78e9";
    hash = "sha256-7Iu0Q3iau73KV1Sw7vo8OBJQjpshTd/dhx6C2SDteN0=";
    leaveDotGit = true;
  };

  # Darwin uses ld64 as linker, which does not understand this parameter
  postPatch = lib.optionalString clangStdenv.hostPlatform.isDarwin ''
    substituteInPlace src/cmake/compiler/clang/settings.cmake \
      --replace-fail "--no-undefined" ""
  '';

  preConfigure = linkModules modules;

  nativeBuildInputs = [
    cmake
    git
  ];

  buildInputs = [
    boost
    openssl
    zlib
    readline
    bzip2
    # Since https://github.com/azerothcore/azerothcore-wotlk/pull/19451, azerothcore
    # is not compatible with MariaDB and mariadb-connector-c anymore, which libmysqlclient
    # unfortunately is aliased to on nixpkgs.
    # However, the MySQL package itself contains the headers and libraries we need.
    mysql84
  ];

  cmakeFlags = [
    "-DTOOLS_BUILD=${buildTools}"
    "-DAPPS_BUILD=${buildApps}"
    "-DSCRIPTS=${buildScripts}"
    "-DMODULES=${buildModules}"
    # Required to make try_compile pass
    "-DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY"
  ];

  meta = {
    description = "Complete Open Source and Modular solution for MMO";
    homepage = "https://www.azerothcore.org/";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ niklaskorz ];
    mainProgram = "azerothcore-wotlk";
    platforms = lib.platforms.all;
  };
})
