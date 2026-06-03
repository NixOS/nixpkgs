{
  lib,
  stdenv,
  cmake,
  zlib,
  zstd,
  fetchFromGitHub,
  re2,
  abseil-cpp,
  protobuf,
  capstone,
  gtest,
  pkg-config,
  lit,
  llvmPackages,
}:
let
  # Old vendored package which has no other use than here, so not packaged in nixpkgs.
  demumble = fetchFromGitHub {
    owner = "nico";
    repo = "demumble";
    rev = "10e00fb708a3d24c1bb16682cac76925ffb76af5";
    hash = "sha256-JNSSvYE5bh/9RVLQXVNmWRKAzidg4ktmqLI7pcUATDs=";
  };
in
stdenv.mkDerivation {
  pname = "bloaty";
  version = "1.1-unstable-2026-05-31";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bloaty";
    rev = "4a601b636e2347322d0371c8bf8ca5eaeaca4bac";
    hash = "sha256-16Ic2x5JctSCuHJZjK96xkgJw8qyy8GqFupwWuc2U/k=";
  };

  cmakeFlags = [
    "-DLIT_EXECUTABLE=${lit}/bin/lit"
    "-DFILECHECK_EXECUTABLE=${llvmPackages.libllvm}/bin/FileCheck"
    "-DYAML2OBJ_EXECUTABLE=${llvmPackages.libllvm}/bin/yaml2obj"
  ];

  postPatch = ''
    # Build system relies on some of those source files
    rm -rf third_party/googletest third_party/abseil-cpp third_party/demumble
    ln -s ${gtest.src} third_party/googletest
    ln -s ${demumble} third_party/demumble
    substituteInPlace CMakeLists.txt \
      --replace "find_package(Python COMPONENTS Interpreter)" "" \
      --replace "if(Python_FOUND AND LIT_EXECUTABLE" "if(LIT_EXECUTABLE" \
      --replace "COMMAND \''${Python_EXECUTABLE} \''${LIT_EXECUTABLE}" "COMMAND \''${LIT_EXECUTABLE}"
    # wasm test fail. Possibly due to LLVM version < 17. See https://github.com/google/bloaty/pull/354
    rm -rf tests/wasm
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    zlib
    zstd
    re2
    abseil-cpp
    protobuf
    capstone
    gtest
    lit
    llvmPackages.libllvm
  ];

  doCheck = true;

  postCheck = ''
    # These lit tests need to be build seperatly.
    # See https://github.com/google/bloaty/blob/main/tests/README.md
    cmake --build . --target check-bloaty
  '';
  installPhase = ''
    install -Dm755 {.,$out/bin}/bloaty
  '';

  meta = {
    description = "Size profiler for binaries";
    mainProgram = "bloaty";
    homepage = "https://github.com/google/bloaty";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
