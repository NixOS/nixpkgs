{
  lib,
  llvmPackages,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  python3,
  nix-update-script,
  xxHash,
  fmt,
  catch2,
  nasm,
  withQt ? true,
  qt6,
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "fex";
  version = "2508.1";

  src = fetchFromGitHub {
    owner = "FEX-Emu";
    repo = "FEX";
    tag = "FEX-${finalAttrs.version}";
    hash = "sha256-yWUZF/Chgi9bd5gF9qU1jiiIvHOHBUw7tLWxyNUZy9g=";

    leaveDotGit = true;
    postFetch = ''
      cd $out
      git reset

      # Only fetch required submodules
      git submodule update --init --depth 1 \
        External/Vulkan-Headers \
        External/drm-headers \
        External/jemalloc \
        External/jemalloc_glibc \
        External/robin-map \
        External/vixl \
        Source/Common/cpp-optparse

      find . -name .git -print0 | xargs -0 rm -rf

      # Remove some more unnecessary directories
      rm -r \
        External/vixl/src/aarch32 \
        External/vixl/test
    '';
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    llvmPackages.bintools
    (python3.withPackages (
      pythonPackages: with pythonPackages; [
        setuptools
        libclang
      ]
    ))
  ]
  ++ lib.optional withQt qt6.wrapQtAppsHook;

  buildInputs = [
    xxHash
    fmt
  ]
  ++ lib.optionals withQt [
    qt6.qtbase
    qt6.qtdeclarative
  ];

  cmakeFlags = [
    (lib.cmakeFeature "USE_LINKER" "lld")
    (lib.cmakeFeature "OVERRIDE_VERSION" finalAttrs.version)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
    (lib.cmakeBool "BUILD_FEXCONFIG" withQt)
  ];

  strictDeps = true;

  # Unsupported on non-4K page size kernels (e.g. Apple Silicon)
  doCheck = true;

  nativeCheckInputs = [ nasm ];
  checkInputs = [ catch2 ];

  # List not exhaustive, e.g. because they depend on an x86 compiler or some
  # other difficult-to-build test binaries.
  checkTarget = lib.concatStringsSep " " [
    "asm_tests"
    "api_tests"
    "fexcore_apitests"
    "emitter_tests"
  ];

  # Avoid wrapping anything other than FEXConfig, since the wrapped executables
  # don't seem to work when registered as binfmts.
  dontWrapQtApps = true;
  preFixup = lib.optionalString withQt ''
    wrapQtApp $out/bin/FEXConfig
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fast usermode x86 and x86-64 emulator for Arm64 Linux";
    homepage = "https://fex-emu.com/";
    changelog = "https://github.com/FEX-Emu/FEX/releases/tag/FEX-${finalAttrs.version}";
    platforms = [ "aarch64-linux" ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "FEXBash";
  };
})
