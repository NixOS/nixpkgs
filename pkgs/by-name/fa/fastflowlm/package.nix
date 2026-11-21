{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  patchelf,
  pkg-config,
  perl,
  boost,
  curl,
  cargo,
  rustc,
  ffmpeg,
  fftw,
  fftwFloat,
  fftwLongDouble,
  libdrm,
  libuuid,
  readline,
  rustPlatform,
  callPackage,
}:

let
  tokenizer-rust = rustPlatform.buildRustPackage {
    name = "tokenizer-rust";

    src = fastflowlm.src + "/third_party/tokenizers-cpp/rust";

    cargoLock = {
      lockFile = ./Cargo.lock;
    };

    postPatch = ''
      ln -s ${./Cargo.lock} Cargo.lock
    '';
  };

  fastflowlm = stdenv.mkDerivation (finalAttrs: {
    pname = "fastflowlm";
    version = "1.0.1";

    strictDeps = true;
    __structuredAttrs = true;

    src = fetchFromGitHub {
      owner = "ROCm";
      repo = "FastFlowLM";
      tag = "v${finalAttrs.version}";
      fetchSubmodules = true;
      hash = "sha256-Je9MVidDwVHdeT+U4gwVi1O6zFLXPpZK+onC/kaElUo=";
    };

    sourceRoot = "${finalAttrs.src.name}/src";

    nativeBuildInputs = [
      cmake
      ninja
      patchelf
      pkg-config
      perl
      cargo
      rustc
    ];

    buildInputs = [
      boost
      curl
      ffmpeg
      fftw
      fftwFloat
      fftwLongDouble
      libdrm
      libuuid
      readline
      stdenv.cc.cc.lib
      (callPackage ./xdna-driver-shim.nix { })
    ];

    postPatch = ''
      substituteInPlace ../third_party/tokenizers-cpp/CMakeLists.txt \
        --replace-fail \
          'add_library(tokenizers_c INTERFACE ''${TOKENIZERS_RUST_LIB}' \
          'add_library(tokenizers_c INTERFACE ${tokenizer-rust}/lib/libtokenizers_c.a' \
        --replace-fail \
          'target_link_libraries(tokenizers_c INTERFACE ''${TOKENIZERS_RUST_LIB}' \
          'target_link_libraries(tokenizers_c INTERFACE ${tokenizer-rust}/lib/libtokenizers_c.a'

      perl -0pi -e 's@if\(NOT WIN32 AND NOT CMAKE_INSTALL_PREFIX STREQUAL "/usr" AND NOT CMAKE_INSTALL_PREFIX STREQUAL "/usr/local"\)\s*install\(CODE ".*?"\s*\)\s*endif\(\)@@s' CMakeLists.txt
    '';

    cmakeFlags = [
      (lib.cmakeFeature "FLM_VERSION" finalAttrs.version)
      (lib.cmakeFeature "NPU_VERSION" finalAttrs.version)
      (lib.cmakeFeature "CMAKE_XCLBIN_PREFIX" "${placeholder "out"}/share/flm")
      (lib.cmakeBool "CMAKE_SKIP_BUILD_RPATH" true)
      "--preset"
      "linux-default"
    ];

    postFixup = ''
      libraryPath="${lib.makeLibraryPath finalAttrs.buildInputs}"

      while IFS= read -r -d "" sharedObject; do
        patchelf --add-rpath "$libraryPath" "$sharedObject"
      done < <(find "$out/lib" -type f -name '*.so*' -print0)
    '';

    meta = {
      description = "CLI and local server for running LLMs on AMD Ryzen AI NPUs";
      homepage = "https://fastflowlm.com/";
      license = [
        lib.licenses.mit
        lib.licenses.unfree
      ];
      mainProgram = "flm";
      maintainers = with lib.maintainers; [ schmitthenner ];
      platforms = [ "x86_64-linux" ];
      sourceProvenance = with lib.sourceTypes; [
        fromSource
        binaryNativeCode
      ];
    };
  });
in

fastflowlm
