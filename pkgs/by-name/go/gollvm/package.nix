{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchgit,
  llvmPackages_20,
  bash,
  binutils,
  cmake,
  gawk,
  gmp,
  libmpc,
  m4,
  makeBinaryWrapper,
  mpfr,
  ninja,
  python3,
  runCommand,
  zlib,
}:

let
  llvmPackages = llvmPackages_20;
  llvm = llvmPackages.llvm;
  gccToolchain = toString stdenv.cc.cc;
  glibcLib = lib.getLib stdenv.cc.libc;
  gccLib = lib.getLib stdenv.cc.cc;
  gccInstallPath = "${stdenv.cc.cc}/lib/gcc/${stdenv.hostPlatform.config}/${stdenv.cc.cc.version}";
  compilerDriverFlags = [
    "--gcc-toolchain=${gccToolchain}"
    "-B${llvmPackages.lld}/bin/"
    "-B${glibcLib}/lib/"
    "-B${gccInstallPath}/"
    "-Wl,-dynamic-linker,${stdenv.cc.bintools.dynamicLinker}"
    "-L${glibcLib}/lib"
    "-L${gccLib}/lib"
  ];
  buildGocFlags = lib.concatStringsSep " " compilerDriverFlags;
  buildLibraryPath = lib.makeLibraryPath [
    zlib
    gmp
    mpfr
    libmpc
    (lib.getLib stdenv.cc.cc)
  ];
  canRunChecks = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  version = "unstable-2025-04-07";

  gollvmSrc = fetchgit {
    url = "https://go.googlesource.com/gollvm";
    rev = "605d1b6368b72e7bc15f66fac1f33f754537a090";
    hash = "sha256-c+RdtJ2Jh011yYnQWlUq53Hw2WyNzVFQGPIlzmWR4ys=";
  };

  gofrontendSrc = fetchgit {
    url = "https://go.googlesource.com/gofrontend";
    rev = "d7cb797c46170ea43381064745514fd597cb8d7d";
    hash = "sha256-J79S6iskZLj1g7sbHlPGzXZphe6Ov5WIt1esg34LTvs=";
  };

  libbacktraceSrc = fetchFromGitHub {
    owner = "ianlancetaylor";
    repo = "libbacktrace";
    rev = "b9e40069c0b47a722286b94eb5231f7f05c08713";
    hash = "sha256-vi33Bhg2LT5uWN63PHkD8CaOjTXBwZhBwFFhaezJ0e4=";
  };

  libffiSrc = fetchFromGitHub {
    owner = "libffi";
    repo = "libffi";
    rev = "v3.4.8";
    hash = "sha256-wnjpQPStzti7li5iyWEClhiTv/lRe95WSZNgQwx43o0=";
  };

  gollvmSource = runCommand "gollvm-source-${version}" { } ''
    mkdir -p "$out"
    cp -r ${gollvmSrc}/. "$out/"
    chmod -R u+w "$out"

    rm -rf "$out/gofrontend" "$out/libgo/libbacktrace" "$out/libgo/libffi"
    cp -r ${gofrontendSrc} "$out/gofrontend"
    cp -r ${libbacktraceSrc} "$out/libgo/libbacktrace"
    cp -r ${libffiSrc} "$out/libgo/libffi"
    chmod -R u+w "$out/gofrontend" "$out/libgo/libbacktrace" "$out/libgo/libffi"

    patch -d "$out" -p1 < ${./0001-use-nix-system-libs.patch}
    patch -d "$out" -p1 < ${./0002-find-tools-in-path.patch}
    patch -d "$out" -p1 < ${./0003-support-nix-dynamic-linker.patch}
    patch -d "$out" -p1 < ${./0004-relax-triple-match.patch}
    patch -d "$out" -p1 < ${./0005-pass-cmake-cflags-to-mkgensysinfo.patch}
    patch -d "$out" -p1 < ${./0006-gotools-shell-quote-extra-flags.patch}
    patch -d "$out" -p1 < ${./0007-gotools-tests-run-in-gopath-mode.patch}
    patch -d "$out" -p1 < ${./0008-gotools-check-go-tool-vendor-x-tools.patch}
    patch -d "$out" -p1 < ${./0009-cmd-go-tests-accept-lld-undefined-symbol.patch}
    patch -d "$out" -p1 < ${./0010-gotools-export-cpath-for-local-headers.patch}
  '';

  mathDeps = runCommand "gollvm-math-deps" { } ''
    mkdir -p "$out/include" "$out/lib"

    ln -s ${lib.getDev gmp}/include/gmp.h "$out/include/"
    ln -s ${lib.getDev gmp}/include/gmpxx.h "$out/include/"
    ln -s ${lib.getDev mpfr}/include/mpfr.h "$out/include/"
    ln -s ${lib.getDev libmpc}/include/mpc.h "$out/include/"

    ln -s ${lib.getLib gmp}/lib/libgmp.so* "$out/lib/"
    ln -s ${lib.getLib mpfr}/lib/libmpfr.so* "$out/lib/"
    ln -s ${lib.getLib libmpc}/lib/libmpc.so* "$out/lib/"
  '';

  binPath = lib.makeBinPath [
    binutils
    llvmPackages.lld
    stdenv.cc.cc
  ];
in
stdenv.mkDerivation {
  pname = "gollvm";
  inherit version;
  __structuredAttrs = true;

  # Gollvm currently tracks a narrow LLVM compatibility window. Build against
  # the LLVM 20 monorepo used by nixpkgs, following the external-project
  # pattern used by cling.
  src = llvm.monorepoSrc;

  nativeBuildInputs = [
    binutils
    cmake
    gawk
    llvmPackages.lld
    m4
    makeBinaryWrapper
    ninja
    python3
  ];

  buildInputs = [ zlib ];

  strictDeps = true;
  enableParallelBuilding = true;
  doCheck = canRunChecks;
  requiredSystemFeatures = [ "big-parallel" ];

  buildTargets = [ "gollvm" ];
  installTargets = [ "install-gollvm" ];

  preConfigure = ''
    export SHELL=${bash}/bin/bash
    export LD_LIBRARY_PATH=${buildLibraryPath}
    cmakeFlagsArray+=("-DGOLLVM_EXTRA_GOCFLAGS=${buildGocFlags}")
    cd llvm
  '';

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_BUILD_TYPE" "Release")
    (lib.cmakeFeature "CMAKE_C_FLAGS" "-std=gnu17")
    (lib.cmakeFeature "CMAKE_CXX_FLAGS" "-std=gnu++17")
    (lib.cmakeFeature "LLVM_EXTERNAL_PROJECTS" "gollvm")
    (lib.cmakeFeature "LLVM_EXTERNAL_GOLLVM_SOURCE_DIR" (toString gollvmSource))
    (lib.cmakeFeature "LLVM_TARGETS_TO_BUILD" "X86")
    (lib.cmakeBool "LLVM_BUILD_TESTS" canRunChecks)
    (lib.cmakeBool "LLVM_INCLUDE_TESTS" canRunChecks)
    (lib.cmakeBool "LLVM_INCLUDE_EXAMPLES" false)
    (lib.cmakeBool "LLVM_INCLUDE_BENCHMARKS" false)
    (lib.cmakeBool "LLVM_ENABLE_TERMINFO" false)
    (lib.cmakeBool "LLVM_ENABLE_LIBXML2" false)
    (lib.cmakeFeature "LLVM_USE_LINKER" "lld")
    (lib.cmakeFeature "GOLLVM_DEFAULT_LINKER" "lld")
    (lib.cmakeFeature "GOLLVM_DEFAULT_DYNAMIC_LINKER" stdenv.cc.bintools.dynamicLinker)
    (lib.cmakeFeature "GOLLVM_SYSTEM_EXTINSTALLDIR" (toString mathDeps))
  ];

  checkPhase = ''
    runHook preCheck

    if [ -f CMakeCache.txt ]; then
      checkBuildDir="$PWD"
    elif [ -n "''${cmakeBuildDir:-}" ] && [ -f "''${cmakeBuildDir}/CMakeCache.txt" ]; then
      checkBuildDir="$PWD/''${cmakeBuildDir}"
    elif [ -n "''${sourceRoot:-}" ] && [ -f "''${sourceRoot}/llvm/''${cmakeBuildDir:-build}/CMakeCache.txt" ]; then
      checkBuildDir="''${sourceRoot}/llvm/''${cmakeBuildDir:-build}"
    else
      cacheFile="$(find "''${sourceRoot:-$PWD}" -path '*/llvm/build/CMakeCache.txt' | head -n1)"
      if [ -z "$cacheFile" ]; then
        echo "could not find CMake build directory" >&2
        exit 1
      fi
      checkBuildDir="$(dirname "$cacheFile")"
    fi
    cd "$checkBuildDir"

    cmake --build . --target GoBackendUnitTests --parallel "''${NIX_BUILD_CORES:-1}"
    ./tools/gollvm/unittests/BackendCore/GoBackendCoreTests
    ./tools/gollvm/unittests/Driver/DriverTests
    ./tools/gollvm/unittests/DriverUtils/DriverUtilsTests
    ./tools/gollvm/unittests/GoDumpSpec/GoDumpSpecTests

    export GO111MODULE=off
    cmake --build . --target check_go_tool --parallel 1
    cmake --build . --target check_vet_tool --parallel 1
    cmake --build . --target check_cgo_tool --parallel 1
    cmake --build . --target check_carchive_tool --parallel 1

    runHook postCheck
  '';

  postInstall = ''
    runtimePath="$out/bin:$out/tools:${binPath}"
    runtimeLibPath="${buildLibraryPath}:$out/lib64"

    compilerFlags=(
      ${lib.concatMapStringsSep "\n      " (flag: "\"${flag}\"") compilerDriverFlags}
    )

    commonCompilerArgs=(
      --prefix PATH : "$runtimePath"
      --prefix LD_LIBRARY_PATH : "$runtimeLibPath"
      --add-flags "-Wl,-rpath,$out/lib64"
    )

    for flag in "''${compilerFlags[@]}"; do
      commonCompilerArgs+=(--add-flags "$flag")
    done

    mv "$out/bin/llvm-goc" "$out/bin/.llvm-goc-wrapped"
    makeBinaryWrapper "$out/bin/.llvm-goc-wrapped" "$out/bin/llvm-goc" \
      "''${commonCompilerArgs[@]}" \
      --argv0 llvm-goc

    rm -f "$out/bin/gccgo"
    makeBinaryWrapper "$out/bin/.llvm-goc-wrapped" "$out/bin/gccgo" \
      "''${commonCompilerArgs[@]}" \
      --argv0 gccgo

    mv "$out/bin/go" "$out/bin/.go-wrapped"
    makeBinaryWrapper "$out/bin/.go-wrapped" "$out/bin/go" \
      --prefix PATH : "$runtimePath" \
      --prefix LD_LIBRARY_PATH : "$runtimeLibPath"

    if [ -d "$out/tools" ]; then
      while IFS= read -r -d "" tool; do
        toolName="$(basename "$tool")"
        mv "$tool" "$tool.orig"
        makeBinaryWrapper "$tool.orig" "$tool" \
          --prefix PATH : "$runtimePath" \
          --prefix LD_LIBRARY_PATH : "$runtimeLibPath" \
          --argv0 "$toolName"
      done < <(find "$out/tools" -mindepth 1 -maxdepth 1 -type f -perm -0100 -print0)
    fi
  '';

  meta = {
    description = "LLVM-based Go compiler";
    homepage = "https://go.googlesource.com/gollvm";
    license = with lib.licenses; [
      # llvm-project: legacy LLVM files are still under the UIUC/NCSA license.
      ncsa
      # llvm-project: current LLVM 20 sources are Apache-2.0 with LLVM exception.
      asl20
      llvm-exception
      # gollvm, gofrontend, and libbacktrace use BSD-style terms.
      bsd3
      # libffi is MIT-licensed.
      mit
    ];
    mainProgram = "go";
    maintainers = with lib.maintainers; [ starius ];
    platforms = [ "x86_64-linux" ];
    badPlatforms = lib.systems.inspect.patterns.isMusl;
  };
}
