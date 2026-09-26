{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  clang-tools,
  cmake,
  ninja,
  pkg-config,
  python3,

  # buildInputs
  openssl,
  zlib,
  fmt,
  boost,
  tomlplusplus,

  # tests
  versionCheckHook,

  # passthru
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "slang-server";
  version = "0.2.10";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hudson-trading";
    repo = "slang-server";
    tag = "v${finalAttrs.version}";
    # slang-server vendors its dependencies via submodules
    fetchSubmodules = true;
    hash = "sha256-hyKiEtUpLkXYbwh9KKDc26EgZbC1bvf0hV5tM8p5vVU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
  ]
  ++ lib.optionals stdenv.cc.isClang [
    # Pick up the `clang-scan-deps` wrapper for CMake; see:
    # https://github.com/NixOS/nixpkgs/issues/452260
    clang-tools
  ];

  buildInputs = [
    boost
    fmt
    openssl
    tomlplusplus
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "SLANG_SERVER_INCLUDE_TESTS" false)
    (lib.cmakeBool "SLANG_INCLUDE_TESTS" false)
    (lib.cmakeBool "SLANG_USE_MIMALLOC" false)
    (lib.cmakeBool "SLANG_USE_SYSTEM_BOOST" true)
    (lib.cmakeBool "SLANG_SERVER_USE_SYSTEM_FMT" true)
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "SystemVerilog language server";
    homepage = "https://github.com/hudson-trading/slang-server";
    changelog = "https://github.com/hudson-trading/slang-server/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.evanwporter ];
    platforms = lib.platforms.unix;
    mainProgram = "slang-server";
  };
})
