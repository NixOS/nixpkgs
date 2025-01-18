{
  fetchFromGitHub,
  lib,
  llvmPackages,
  stdenv,
  cmake,
  ninja,
  pkg-config,
  qt5,
  python3,
  xxHash,
  fmt,
  nasm,
}:

llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "fex";
  version = "2503";

  src = fetchFromGitHub {
    owner = "FEX-Emu";
    repo = "FEX";
    tag = "FEX-${finalAttrs.version}";

    hash = "sha256-yjxwwqnI0jartl97zGfqP9GJSQ6HRwZ6ZJUWPsFsvUw=";

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
        Source/Common/cpp-optparse \
        External/Catch2 \
        External/xbyak

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
    qt5.wrapQtAppsHook
    llvmPackages.bintools

    (python3.withPackages (
      pythonPackages: with pythonPackages; [
        setuptools
        libclang
      ]
    ))
  ] ++ lib.optionals finalAttrs.doCheck [ nasm ];

  buildInputs =
    [
      xxHash
      fmt
    ]
    ++ (with qt5; [
      qtbase
      qtdeclarative
      qtquickcontrols
      qtquickcontrols2
    ]);

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DUSE_LINKER=lld"
    "-DENABLE_LTO=True"
    "-DENABLE_ASSERTIONS=False"
    (lib.cmakeFeature "OVERRIDE_VERSION" finalAttrs.version)
    (lib.cmakeBool "BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  strictDeps = true;

  # Unsupported on non-4K page size kernels (e.g. Apple Silicon)
  doCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  checkTarget = lib.concatStringsSep " " [
    "asm_tests"
    "api_tests"
    "fexcore_apitests"
    "emitter_tests"

    # Needs x86 libc headers
    # "struct_verifier"

    # Needs x86 compiler
    # "fex_linux_tests_all"

    # Needs thunks to be enabled
    # "thunkgen_tests"

    # Needs prebuilt binaries
    # "gcc_target_tests_64"
    # "gcc_target_tests_32"
    # "posix_tests"
    # "gvisor_tests"
  ];

  # Avoid wrapping anything other than FEXConfig, since the wrapped executables
  # don't seem to work when registered as binfmts.
  dontWrapQtApps = true;
  preFixup = ''
    wrapQtApp $out/bin/FEXConfig
  '';

  meta = {
    description = "Fast usermode x86 and x86-64 emulator for Arm64 Linux";
    homepage = "https://fex-emu.com/";
    platforms = [ "aarch64-linux" ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ andre4ik3 ];
    mainProgram = "FEXBash";
  };
})
