{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  python3,
  libffi,
  libxml2,
  autoPatchelfHook,
  pkg-config,
  zlib,
  SDL2,
  zmusic,
  libvpx,
  libbacktrace,
  ncurses,
}:
stdenv.mkDerivation {
  pname = "llvm-mos";
  version = "0-unstable-2026-04-23";

  src = fetchFromGitHub {
    owner = "llvm-mos";
    repo = "llvm-mos";
    rev = "9142aebae87d0bf6fc7c55b05a415f2c188b19f3";
    fetchSubmodules = true;
    hash = "sha256-nfd1m7FAIzTX+0Fgjv2bhN+YBv0a/6yo2Gm9m9g51qU=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    python3
    autoPatchelfHook
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    zlib
    libxml2
    libffi
    SDL2
    zmusic
    libvpx
    libbacktrace
    ncurses
  ];

  configurePhase = ''
    runHook preConfigure

    cmake \
      -G Ninja \
      -S llvm \
      -B build \
      -C clang/cmake/caches/MOS.cmake \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_ENABLE_PROJECTS="clang;lld" \
      -DLLVM_ENABLE_RUNTIMES="" \
      -DLLVM_BUILD_RUNTIME=OFF \
      -DLLVM_INCLUDE_TESTS=OFF \
      -DLLVM_INCLUDE_BENCHMARKS=OFF \
      -DLLVM_INCLUDE_EXAMPLES=OFF \
      -DLLVM_INCLUDE_DOCS=OFF \
      -DLLVM_ENABLE_ASSERTIONS=OFF \
      -DLLVM_ENABLE_DISTRIBUTION=OFF \
      -DLLVM_DISTRIBUTION_COMPONENTS="" \
      -DLLVM_INSTALL_TOOLCHAIN_ONLY=ON

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    cmake --build build \
      --target \
        clang \
        lld \
        llvm-ar \
        llvm-ranlib \
        llvm-objcopy \
        llvm-objdump \
        llvm-strip \
      --parallel $NIX_BUILD_CORES

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    install -Dm755 build/bin/clang \
      $out/bin/mos-clang

    install -Dm755 build/bin/clang++ \
      $out/bin/mos-clang++

    install -Dm755 build/bin/ld.lld \
      $out/bin/mos-ld.lld

    install -Dm755 build/bin/llvm-ar \
      $out/bin/mos-ar

    install -Dm755 build/bin/llvm-ranlib \
      $out/bin/mos-ranlib

    install -Dm755 build/bin/llvm-objcopy \
      $out/bin/mos-objcopy

    install -Dm755 build/bin/llvm-objdump \
      $out/bin/mos-objdump

    install -Dm755 build/bin/llvm-strip \
      $out/bin/mos-strip

    runHook postInstall
  '';

  meta = {
    description = "LLVM-MOS C compiler for 6502-based systems";
    homepage = "https://llvm-mos.org";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ llamato ];
  };
}
