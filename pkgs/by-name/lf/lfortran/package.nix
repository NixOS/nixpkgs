{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  python3,
  llvmPackages_19,
  pkg-config,
  wrapCCWith,
  wrapBintoolsWith,
  overrideCC,
  targetPackages,
  re2c,
  bison,
  bash,
  zlib,
  zstd,
  pandoc,
  ninja,
  nix-update-script,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lfortran";
  version = "0.65.0";

  src = fetchFromGitHub {
    owner = "lfortran";
    repo = "lfortran";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hm+i4z9LW6CKbbu+ymvrMORhp79WDS3lKVe3XzxrU3g=";
  };

  strictDeps = true;

  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    re2c
    bison
    bash
    pandoc
    ninja
  ];

  nativeCheckInputs = [
    python3.pkgs.toml
  ];

  buildInputs = with llvmPackages_19; [
    llvm
    libclang
    lld
    (zstd.override { enableStatic = true; })
    libunwind
    zlib
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "LFORTRAN_BUILD_ALL" true)
    "-DCMAKE_POLICY_DEFAULT_CMP0074=NEW"
    (lib.cmakeBool "WITH_ZLIB" false)
    (lib.cmakeBool "WITH_LLVM" true)
    (lib.cmakeBool "WITH_LSP" true)
    (lib.cmakeBool "WITH_STACKTRACE" false)
    (lib.cmakeBool "WITH_RUNTIME_STACKTRACE" true)
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "share/lfortran/lib")
    (lib.cmakeBool "CMAKE_EXPORT_COMPILE_COMMANDS" true)
  ];

  # LFortran needs LLVM libraries
  NIX_LDFLAGS = "-L${llvmPackages_19.llvm}/lib";
  NIX_CXXFLAGS = "-Wall -Wextra -O3 -funroll-loops -DNDEBUG";

  postPatch = ''
    # Fix shebang lines to use env from nix
    patchShebangs ci/version.sh build0.sh src/libasr/dwarf_convert.py

    # Skip version.sh and use fixed version directly
    substituteInPlace build0.sh --replace-fail "ci/version.sh" "echo ${finalAttrs.version} > version"

    # Use fixed version instead of calling git
    echo "${finalAttrs.version}" > version
  '';

  preCheck = ''
    export LFORTRAN_LINKER=cc
  '';

  doCheck = true;

  passthru = {
    # Add compiler wrapper support
    bintools-unwrapped = finalAttrs.finalPackage;
    bintools = wrapBintoolsWith { bintools = finalAttrs.passthru.bintools-unwrapped; };

    cc-unwrapped = finalAttrs.finalPackage;
    cc = wrapCCWith {
      cc = finalAttrs.passthru.cc-unwrapped;
      bintools = finalAttrs.passthru.bintools;
      extraPackages = [ ];
      nixSupport.cc-cflags = [
        "-target"
        "${stdenv.targetPlatform.system}-${stdenv.targetPlatform.parsed.abi.name}"
      ]
      ++ lib.optional (
        stdenv.targetPlatform.isLinux && !(stdenv.targetPlatform.isStatic or false)
      ) "-Wl,-dynamic-linker=${targetPackages.stdenv.cc.bintools.dynamicLinker}";
    };

    stdenv = overrideCC stdenv finalAttrs.passthru.cc;

    updateScript = nix-update-script { };

    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
  };

  meta = {
    description = "Modern interactive LLVM-based Fortran compiler";
    homepage = "https://lfortran.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ taranarmo ];
    mainProgram = "lfortran";
    # https://github.com/lfortran/lfortran/issues/8643
    broken = stdenv.hostPlatform.isAarch64 && stdenv.hostPlatform.isLinux;
    platforms = lib.platforms.unix;
  };
})
