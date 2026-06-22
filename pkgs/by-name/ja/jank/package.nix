{
  lib,
  fetchFromGitHub,
  llvmPackages_22,
  cmake,
  ninja,
  git,
  bzip2,
  openssl,
  zstd,
  zlib,
  libedit,
  libxml2,
  boost,
  glibcLocales,
}:

let
  llvmPackages = llvmPackages_22;

  libdwarf-lite-src = fetchFromGitHub {
    owner = "jeremy-rifkin";
    repo = "libdwarf-lite";
    rev = "5e71a74491dddc231664bbcd6a8cf8a8643918e9";
    hash = "sha256-qHikjAG5xuuHquqqKGuiDHXVZSlg/MbNp9JNSAKM/Hs=";
  };

  zstd-src = fetchFromGitHub {
    owner = "facebook";
    repo = "zstd";
    rev = "v1.5.7";
    hash = "sha256-tNFWIT9ydfozB8dWcmTMuZLCQmQudTFJIkSr0aG7S44=";
  };
in
llvmPackages.stdenv.mkDerivation (finalAttrs: {
  pname = "jank";
  version = "unstable-0.1-alpha-2026-05-22";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jank-lang";
    repo = "jank";
    rev = "86cd33b8edb7504209719f43391a185b84211a0c";
    hash = "sha256-+AN13Njo7SRynfYuskkS5QSvnRCsjq/DWl3XG4fXit0=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    llvmPackages.clang
    llvmPackages.libclang.dev
    cmake
    git
    ninja
    glibcLocales
  ];

  buildInputs = [
    llvmPackages.libllvm.dev
    bzip2
    openssl
    zstd
    libedit
    libxml2
    boost
  ];

  postPatch = ''
    patchShebangs ./compiler+runtime/bin/ar-merge
  '';

  hardeningDisable = [ "fortify" ];

  cmakeBuildDir = "compiler+runtime/build";
  cmakeDir = "..";

  cmakeFlags = [
    "-DCMAKE_SKIP_RPATH=ON"
    "-DFETCHCONTENT_SOURCE_DIR_LIBDWARF=${libdwarf-lite-src}"
    "-DFETCHCONTENT_SOURCE_DIR_ZSTD=${zstd-src}"
    (lib.cmakeBool "jank_unity_build" true)
    (lib.cmakeBool "jank_test" finalAttrs.doCheck)
    (lib.cmakeBool "jank_force_phase_2" true)
  ];

  # This runs as a bash script just before CMake configures the project
  preConfigure = ''
    local cxxFlags="$(cat ${llvmPackages.clang}/nix-support/cc-cflags) $(cat ${llvmPackages.clang}/nix-support/libc-crt1-cflags)"

    local linkerFlags="$(cat ${llvmPackages.clang}/nix-support/cc-ldflags) -Wl,-rpath,${llvmPackages.stdenv.cc.libc}/lib -L${lib.getLib llvmPackages.libllvm}/lib -L${lib.getLib bzip2}/lib -L${lib.getLib openssl}/lib -L${lib.getLib zlib}/lib -L${lib.getLib zstd}/lib -L${lib.getLib libedit}/lib -L${lib.getLib libxml2}/lib"

    # Append to the array created by structuredAttrs
    cmakeFlags+=(
      "-DCMAKE_CXX_FLAGS=$cxxFlags"
      "-DCMAKE_EXE_LINKER_FLAGS=$linkerFlags"
      "-DCMAKE_SHARED_LINKER_FLAGS=$linkerFlags"
      "-DCMAKE_MODULE_LINKER_FLAGS=$linkerFlags"
    )
  '';

  env = {
    LC_ALL = "C.UTF-8";
  };

  doCheck = true;
  checkPhase = ''
    pushd ..
    ./build/jank-test
    popd
  '';

  meta = with lib; {
    description = "The native Clojure dialect hosted on LLVM with seamless C++ interop";
    homepage = "https://jank-lang.org";
    license = licenses.mpl20;
    maintainers = [ ];
    platforms = platforms.linux ++ platforms.darwin;
    mainProgram = "jank";
  };
})
