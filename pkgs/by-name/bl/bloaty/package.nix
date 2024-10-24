{
  lib,
  stdenv,
  cmake,
  zlib,
  fetchFromGitHub,
  re2,
  abseil-cpp,
  protobuf,
  capstone,
  gtest,
  pkg-config,
  lit,
  llvmPackages_16,
}:
let
  # Old vendored package which has no other use than here, so not packaged in nixpkgs.
  demumble = fetchFromGitHub {
    owner = "nico";
    repo = "demumble";
    rev = "01098eab821b33bd31b9778aea38565cd796aa85";
    hash = "sha256-605SsXd7TSdm3BH854ChHIZbOXcHI/n8RN+pFMz4Ex4=";
  };
in
stdenv.mkDerivation {
  pname = "bloaty";
  version = "1.1-unstable-2024-09-23";

  src = fetchFromGitHub {
    owner = "google";
    repo = "bloaty";
    rev = "0c89acd7e8b9d91fd1e9c8c129be627b4e47f1ea";
    hash = "sha256-txZDPytWnkjkiVkPL2SWLwCPEtVvqoI/MVRvbJ2kBGw=";
  };

  cmakeFlags = [
    "-DLIT_EXECUTABLE=${lit}/bin/lit"
    "-DFILECHECK_EXECUTABLE=${llvmPackages_16.libllvm}/bin/FileCheck"
    "-DYAML2OBJ_EXECUTABLE=${llvmPackages_16.libllvm}/bin/yaml2obj"
  ];

  postPatch = ''
    # Build system relies on some of those source files
    rm -rf third_party/googletest third_party/abseil-cpp third_party/demumble
    ln -s ${gtest.src} third_party/googletest
    ln -s ${abseil-cpp.src} third_party/abseil-cpp
    ln -s ${demumble} third_party/demumble
    substituteInPlace CMakeLists.txt \
      --replace "find_package(Python COMPONENTS Interpreter)" "" \
      --replace "if(Python_FOUND AND LIT_EXECUTABLE" "if(LIT_EXECUTABLE" \
      --replace "COMMAND \''\${Python_EXECUTABLE} \''\${LIT_EXECUTABLE}" "COMMAND \''\${LIT_EXECUTABLE}"
    # wasm test fail. Possibly due to LLVM version < 17. See https://github.com/google/bloaty/pull/354
    rm -rf tests/wasm
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    zlib
    re2
    abseil-cpp
    protobuf
    capstone
    gtest
    lit
    llvmPackages_16.libllvm
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
