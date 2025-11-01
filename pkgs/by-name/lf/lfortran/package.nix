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
  ccache,
  zstd,
  pandoc,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lfortran";
  version = "0.57.0";

  src = fetchFromGitHub {
    owner = "lfortran";
    repo = "lfortran";
    rev = "v${finalAttrs.version}";
    hash = "sha256-aQqURmR6wYL7NPdLoYeDjmD8Mg10zxxkLBPn4U4et5k=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
    re2c
    bison
    bash
    ccache
    pandoc
    ninja
  ];

  buildInputs = with llvmPackages_19; [
    llvm
    libclang
    lld
    (zstd.override { enableStatic = true; })
    libunwind
  ];

  propagatedBuildInputs = [
    zlib
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DBUILD_SHARED_LIBS=ON"
    "-DLFORTRAN_BUILD_ALL=ON"
    "-DCMAKE_POLICY_DEFAULT_CMP0074=NEW"
    "-DWITH_ZLIB=no"
    "-DWITH_LLVM=yes"
    "-DWITH_LSP=yes"
    "-DWITH_STACKTRACE=no"
    "-DWITH_RUNTIME_STACKTRACE=yes"
    "-DCMAKE_INSTALL_LIBDIR=share/lfortran/lib"
    "-DCMAKE_EXPORT_COMPILE_COMMANDS=yes"
    "-G Ninja"
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
  };

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Modern interactive LLVM-based Fortran compiler";
    homepage = "https://lfortran.org/";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ taranarmo ];
    mainProgram = "lfortran";
    platforms = lib.platforms.unix;
    # https://github.com/lfortran/lfortran/issues/8643
    broken = stdenv.hostPlatform.system == "aarch64-linux";
  };
})
