# https://github.com/esbmc/esbmc

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  bison,
  flex,
  pkg-config,
  python3,
  boost,
  fmt,
  nlohmann_json,
  yaml-cpp,
  immer,
  z3,
  llvmPackages_21,
  zlib,
  zstd,
  libxml2,
  curl,
  glibc,
  runCommand,
  nix-update-script,
}:

let
  llvm = llvmPackages_21;
  clangMajor = lib.versions.major llvm.release_version;

  # c2goto compiles the bundled libc operational models at build time and needs
  # the target C library headers. Expose the Nix glibc with a conventional
  # usr/include layout so Clang's <sysroot>/usr/include lookup finds them.
  c2gotoSysroot = runCommand "esbmc-c2goto-sysroot" { } ''
    mkdir -p $out/usr
    ln -s ${glibc.dev}/include $out/usr/include
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "esbmc";
  version = "8.5";
  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "esbmc";
    repo = "esbmc";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Xessx0NWXbYgzL+xOH4qooF6Ub7nayRNwaJ0ZuxkVfc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    bison
    flex
    pkg-config
    python3
  ];

  buildInputs = [
    boost
    fmt
    nlohmann_json
    yaml-cpp
    immer
    z3
    llvm.llvm
    llvm.clang-unwrapped
    zlib
    zstd
    libxml2
    curl
  ];

  # With nixpkgs' shared Clang the resource-dir probe joins an absolute
  # CLANG_RESOURCE_DIR onto CLANG_INSTALL_PREFIX/bin and cannot find the
  # builtin headers. Options.cmake hard-resets OVERRIDE_CLANG_HEADER_DIR, so
  # the path has to be baked into the CMake module rather than passed on the
  # command line.
  postPatch = ''
    substituteInPlace scripts/cmake/Options.cmake \
      --replace-fail 'set(OVERRIDE_CLANG_HEADER_DIR "")' \
                     'set(OVERRIDE_CLANG_HEADER_DIR "${llvm.clang-unwrapped.lib}/lib/clang/${clangMajor}/include")'
  '';

  # The build system defaults to fetching LLVM/Z3/solvers/libs over the
  # network (DOWNLOAD_DEPENDENCIES), which the sandbox forbids; use the
  # system packages instead. 32-bit libc models need i686 glibc headers that
  # are not present here, so only the 64-bit models are bundled. Tests and
  # regressions are not built.
  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" false)
    (lib.cmakeBool "ENABLE_BUNDLE_LIBC_32BIT" false)
    (lib.cmakeFeature "LLVM_DIR" "${llvm.llvm.dev}/lib/cmake/llvm")
    (lib.cmakeFeature "Clang_DIR" "${llvm.clang-unwrapped.dev}/lib/cmake/clang")
    (lib.cmakeFeature "Z3_DIR" "${z3}")
    (lib.cmakeFeature "Python_EXECUTABLE" "${python3}/bin/python3")
    (lib.cmakeFeature "C2GOTO_SYSROOT" "${c2gotoSysroot}")
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Efficient SMT-based context-bounded model checker";
    homepage = "https://github.com/esbmc/esbmc";
    changelog = "https://github.com/esbmc/esbmc/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "esbmc";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ligurio ];
  };
})
