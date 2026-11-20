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
  pname = "slang-format";
  version = "0.1.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "hudson-trading";
    repo = "slang-format";
    tag = "v${finalAttrs.version}";
    # slang-format vendors its dependencies via submodules
    fetchSubmodules = true;
    hash = "sha256-J8GVmzHbO5tDQG7qHLU9N6FhoqsZEUHU3x+TE3OMt7w=";
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
    (lib.cmakeBool "CMAKE_DISABLE_FIND_PACKAGE_fmt" false)
    (lib.cmakeBool "SLANG_FORMAT_INCLUDE_TESTS" false)
    (lib.cmakeBool "SLANG_INCLUDE_TESTS" false)
    (lib.cmakeBool "SLANG_USE_MIMALLOC" false)
    (lib.cmakeBool "SLANG_USE_SYSTEM_BOOST" true)
    (lib.cmakeBool "SLANG_USE_SYSTEM_FMT" true)
  ];

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "SystemVerilog formatter";
    homepage = "https://github.com/hudson-trading/slang-format";
    changelog = "https://github.com/hudson-trading/slang-format/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.evanwporter ];
    platforms = lib.platforms.unix;
    mainProgram = "slang-format";
  };
})
