{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  llvmPackages,
  pkg-config,
  re2c,
  bison,
  zlib,
  zstd,
  pandoc,
  ninja,
  makeBinaryWrapper,
  callPackage,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lfortran";
  version = "0.68.0";

  src = fetchFromGitHub {
    owner = "lfortran";
    repo = "lfortran";
    tag = "v${finalAttrs.version}";
    hash = "sha256-hwHN/80plK72l3K+C4uI+q8gnu0OAnMLESU3HA4I8VQ=";
  };

  strictDeps = true;

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    re2c
    bison
    pandoc
    ninja
    makeBinaryWrapper
  ];

  nativeCheckInputs = [
    python3.pkgs.tomli
  ];

  buildInputs = [
    llvmPackages.llvm
    llvmPackages.libunwind
    zstd
    zlib
    # For the shebangs of the DWARF scripts that `lfortran -g` runs.
    python3
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "LFORTRAN_BUILD_ALL" true)
    (lib.cmakeFeature "CMAKE_POLICY_DEFAULT_CMP0074" "NEW")
    (lib.cmakeBool "WITH_ZLIB" true)
    (lib.cmakeBool "USE_DYNAMIC_ZLIB" true)
    (lib.cmakeBool "WITH_ZSTD" true)
    (lib.cmakeBool "USE_DYNAMIC_ZSTD" true)
    (lib.cmakeBool "WITH_LLVM" true)
    (lib.cmakeBool "WITH_LSP" true)
    (lib.cmakeBool "WITH_STACKTRACE" false)
    (lib.cmakeBool "WITH_RUNTIME_STACKTRACE" true)
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "share/lfortran/lib")
    # Since v0.68.0 CMake runs build0.sh via a POSIX shell found as an
    # executable named `shell` (LFortran's cross-platform Pixi env). Instead of
    # packaging that, reuse the build platform's bash via the same variable.
    (lib.cmakeFeature "LFORTRAN_SHELL" stdenv.shell)
  ];

  postPatch = ''
    patchShebangs build0.sh
    substituteInPlace build0.sh \
      --replace-fail "source ci/version.sh" "echo \"${finalAttrs.version}\" > version"
  '';

  preCheck = ''
    export LFORTRAN_LINKER=cc
  '';

  doCheck = true;

  # clang links executables; `-g` runs llvm-dwarfdump (and dsymutil on Darwin).
  postInstall = ''
    wrapProgram $out/bin/lfortran \
      --prefix PATH : ${
        lib.makeBinPath [
          llvmPackages.clang
          llvmPackages.llvm
        ]
      }
  '';

  setupHook = ./setup-hook.sh;

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };

      compile-and-run = callPackage ./tests/compile-and-run.nix {
        lfortran = finalAttrs.finalPackage;
      };

      debug-info = callPackage ./tests/debug-info.nix {
        lfortran = finalAttrs.finalPackage;
      };

      fpm = callPackage ./tests/fpm.nix {
        lfortran = finalAttrs.finalPackage;
      };

      integration = callPackage ./tests/integration.nix {
        lfortran = finalAttrs.finalPackage;
      };

      toml-f = callPackage ./tests/toml-f.nix {
        lfortran = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description = "Modern interactive LLVM-based Fortran compiler";
    homepage = "https://lfortran.org/";
    changelog = "https://github.com/lfortran/lfortran/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ taranarmo ];
    mainProgram = "lfortran";
    platforms = lib.platforms.unix;
  };
})
