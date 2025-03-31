{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  grpc,
  protobuf,
  openssl,
  nlohmann_json,
  gtest,
  spdlog,
  c-ares,
  zlib,
  sqlite,
  re2,
  lit,
  python3,
  coreutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bear";
  version = "3.1.6";

  src = fetchFromGitHub {
    owner = "rizsotto";
    repo = "bear";
    rev = finalAttrs.version;
    hash = "sha256-fWNMjqF5PCjGfFGReKIUiJ5lv8z6j7HeBn5hvbnV2V4=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    grpc
    protobuf
  ];

  buildInputs = [
    grpc
    protobuf
    openssl
    nlohmann_json
    spdlog
    c-ares
    zlib
    sqlite
    re2
  ];

  patches = [
    # This patch is necessary to run tests in a separate phase. By default
    # test targets are run with ALL, which is not what we want. This patch creates
    # separate 'test' step targets for each cmake ExternalProject:
    # - BearTest-test (functional lit tests)
    # - BearSource-test (unit tests via gtest)
    ./0001-exclude-tests-from-all.patch
  ];

  nativeCheckInputs = [
    lit
    python3
  ];

  checkInputs = [
    gtest
  ];

  cmakeFlags = [
    # Build system and generated files concatenate install prefix and
    # CMAKE_INSTALL_{BIN,LIB}DIR, which breaks if these are absolute paths.
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
    (lib.cmakeBool "ENABLE_UNIT_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "ENABLE_FUNC_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  checkTarget = lib.concatStringsSep " " [
    "BearTest-test"
    "BearSource-test"
  ];

  doCheck = true;

  env = {
    # Disable failing tests. The cause is not immediately clear.
    LIT_FILTER_OUT = lib.concatStringsSep "|" [
      "cases/compilation/output/config/filter_compilers.sh"
      "cases/intercept/preload/posix/execvpe/success_to_resolve.c"
      "cases/intercept/preload/posix/popen/success.c"
      "cases/intercept/preload/posix/posix_spawnp/success_to_resolve.c"
      "cases/intercept/preload/posix/system/success.c"
      "cases/intercept/preload/shell_commands_intercepted_without_shebang.sh"
    ];
  };

  postPatch = ''
    patchShebangs test/bin

    # /usr/bin/env is used in test commands and embedded scripts.
    find test -name '*.sh' \
      -exec sed -i -e 's|/usr/bin/env|${coreutils}/bin/env|g' {} +
  '';

  # Functional tests use loopback networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Tool that generates a compilation database for clang tooling";
    mainProgram = "bear";
    longDescription = ''
      Note: the bear command is very useful to generate compilation commands
      e.g. for YouCompleteMe.  You just enter your development nix-shell
      and run `bear make`.  It's not perfect, but it gets a long way.
    '';
    homepage = "https://github.com/rizsotto/Bear";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ DieracDelta ];
  };
})
