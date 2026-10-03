{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  cmake,
  pkg-config,
  python3,
  zita-resampler,
  lv2,
  buildPackages,
}:

let
  flatbuffers_24 = buildPackages.flatbuffers.overrideAttrs (oldAttrs: rec {
    version = "24.3.25";
    src = fetchFromGitHub {
      owner = "google";
      repo = "flatbuffers";
      tag = "v${version}";
      hash = "sha256-uE9CQnhzVgOweYLhWPn2hvzXHyBbFiFVESJ1AEM3BmA=";
    };
  });
in

stdenv.mkDerivation (finalAttrs: {
  pname = "guitarmidi-lv2";
  version = "2.2";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "geraldmwangi";
    repo = "GuitarMidi-LV2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-eRBvlOuUsy3lmtwJuFpzmV6VHPBweX3PNGhCPde3VgE=";
  };

  # Pinned TensorFlow v2.20.0 commit required by GuitarMidi-LV2 (fetched as tarball to optimize size)
  tensorflow-src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "tensorflow";
    rev = "72fbba3d20f4616d7312b5e2b7f79daf6e82f2fa";
    hash = "sha256-nGWQ+T5FmL+hZucbjQlCRTJM1i//gSzua1QxcBFeqwM=";
  };

  # Pinned Abseil commit required by TensorFlow v2.20.0
  # Source: tensorflow/lite/tools/cmake/modules/abseil-cpp.cmake
  abseil-cpp-src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "d9e4955c65cd4367dd6bf46f4ccb8cd3d100540b";
    hash = "sha256-QTywqQCkyGFpdbtDBvUwz9bGXxbJs/qoFKF6zYAZUmQ=";
  };

  # Pinned Eigen commit required by TensorFlow v2.20.0
  # Source: tensorflow/lite/tools/cmake/modules/eigen.cmake
  eigen-src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    rev = "4c38131a16803130b66266a912029504f2cf23cd";
    hash = "sha256-dOq8RJ/V8kulSMK0OUWzHruiwJSP3f/86ih5gk2MMWQ=";
  };

  # Pinned Gemmlowp commit required by TensorFlow v2.20.0
  # Source: tensorflow/lite/tools/cmake/modules/gemmlowp.cmake
  gemmlowp-src = fetchFromGitHub {
    owner = "google";
    repo = "gemmlowp";
    rev = "16e8662c34917be0065110bfcd9cc27d30f52fdf";
    hash = "sha256-e6AeRhZioIiTG5R+IA9g2GBqI4o74wijJYmqINLOtQs=";
  };

  # Pinned Ruy commit required by TensorFlow v2.20.0
  # Source: tensorflow/lite/tools/cmake/modules/ruy.cmake
  ruy-src = fetchFromGitHub {
    owner = "google";
    repo = "ruy";
    rev = "3286a34cc8de6149ac6844107dfdffac91531e72";
    hash = "sha256-2l2RA/VHF9VgHzkPtFdtpVQJtgUw+iT7q4rUBT4R3GE=";
  };

  # Pinned Cpuinfo commit required by TensorFlow v2.20.0
  # Source: tensorflow/lite/tools/cmake/modules/cpuinfo.cmake
  cpuinfo-src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "de0ce7c7251372892e53ce9bc891750d2c9a4fd8";
    hash = "sha256-lWD8fLIMnvuWtp2hbReRHgF19+dTqSFGu3VmYUsjPt8=";
  };

  # Pinned XNNPACK commit required by TensorFlow v2.20.0
  # Source: tensorflow/lite/tools/cmake/modules/xnnpack.cmake
  xnnpack-src = fetchFromGitHub {
    owner = "google";
    repo = "XNNPACK";
    rev = "585e73e63cb35c8a416c83a48ca9ab79f7f7d45e";
    hash = "sha256-mqJMVjZ4rn5O3J/qI/N7HbnMdMSarPYHTIqNBmjZv0Q=";
  };

  # Pinned Farmhash commit required by TensorFlow v2.20.0
  # Source: tensorflow/lite/tools/cmake/modules/farmhash.cmake
  farmhash-src = fetchFromGitHub {
    owner = "google";
    repo = "farmhash";
    rev = "0d859a811870d10f53a594927d0d0b97573ad06d";
    hash = "sha256-J0AhHVOvPFT2SqvQ+evFiBoVfdHthZSBXzAhUepARfA=";
  };

  # Pinned Ml_dtypes commit required by TensorFlow v2.20.0
  # Source: tensorflow/lite/tools/cmake/modules/ml_dtypes.cmake
  ml_dtypes-src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "ml_dtypes";
    rev = "00d98cd92ade342fef589c0470379abb27baebe9";
    hash = "sha256-jY3g0+Uebdj+C2HLfXXq1fO/gnJMQQE/AE0RfxjI5f4=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    zita-resampler
    lv2
  ];

  postPatch = ''
    # 1. Setup TensorFlow source
    mkdir -p ext/tensorflow
    cp -r ${finalAttrs.tensorflow-src}/* ext/tensorflow/
    chmod -R +w ext/tensorflow

    # 2. Patch TensorFlow Lite CMake to disable profiling proto, core examples, benchmark tool and label_image example
    substituteInPlace ext/tensorflow/tensorflow/lite/CMakeLists.txt \
      --replace-fail 'add_subdirectory(''${TFLITE_SOURCE_DIR}/profiling/proto)' "" \
      --replace-fail 'add_subdirectory(''${TF_SOURCE_DIR}/core/example ''${CMAKE_BINARY_DIR}/example_proto_generated)' "" \
      --replace-fail 'add_subdirectory(''${TFLITE_SOURCE_DIR}/tools/benchmark)' "" \
      --replace-fail 'add_subdirectory(''${TFLITE_SOURCE_DIR}/examples/label_image)' ""

    # 3. Setup other fetched dependencies in writable paths
    mkdir -p build-deps
    for dep in abseil-cpp eigen gemmlowp ruy cpuinfo xnnpack farmhash ml_dtypes; do
      mkdir -p build-deps/$dep
    done

    cp -r ${finalAttrs.abseil-cpp-src}/* build-deps/abseil-cpp/
    cp -r ${finalAttrs.eigen-src}/* build-deps/eigen/
    cp -r ${finalAttrs.gemmlowp-src}/* build-deps/gemmlowp/
    cp -r ${finalAttrs.ruy-src}/* build-deps/ruy/
    cp -r ${finalAttrs.cpuinfo-src}/* build-deps/cpuinfo/
    cp -r ${finalAttrs.xnnpack-src}/* build-deps/xnnpack/
    cp -r ${finalAttrs.farmhash-src}/* build-deps/farmhash/
    cp -r ${finalAttrs.ml_dtypes-src}/* build-deps/ml_dtypes/

    chmod -R +w build-deps
  '';

  cmakeFlags = [
    "-DFETCHCONTENT_SOURCE_DIR_ABSEIL-CPP=/build/source/build-deps/abseil-cpp"
    "-DFETCHCONTENT_SOURCE_DIR_EIGEN=/build/source/build-deps/eigen"
    "-DFETCHCONTENT_SOURCE_DIR_GEMMLOWP=/build/source/build-deps/gemmlowp"
    "-DFETCHCONTENT_SOURCE_DIR_RUY=/build/source/build-deps/ruy"
    "-DFETCHCONTENT_SOURCE_DIR_CPUINFO=/build/source/build-deps/cpuinfo"
    "-DFETCHCONTENT_SOURCE_DIR_XNNPACK=/build/source/build-deps/xnnpack"
    "-DFETCHCONTENT_SOURCE_DIR_FARMHASH=/build/source/build-deps/farmhash"
    "-DFETCHCONTENT_SOURCE_DIR_ML_DTYPES=/build/source/build-deps/ml_dtypes"

    "-DFETCHCONTENT_SOURCE_DIR_FFT2D=/build/source/ext/fft2d/OouraFFT-1.0"
    "-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS=/build/source/ext/flatbuffers/flatbuffers-24.3.25"
    "-DFETCHCONTENT_SOURCE_DIR_NEON2SSE=/build/source/ext/neon2sse/ARM_NEON_2_x86_SSE-a15b489e1222b2087007546b4912e21293ea86ff"
    "-DFETCHCONTENT_SOURCE_DIR_PTHREADPOOL=/build/source/ext/pthreadpool/pthreadpool-c2ba5c50bb58d1397b693740cf75fad836a0d1bf"
    "-DFETCHCONTENT_SOURCE_DIR_FP16=/build/source/ext/fp16/FP16-0a92994d729ff76a58f692d3028ca1b64b145d91"
    "-DFETCHCONTENT_SOURCE_DIR_FXDIV=/build/source/ext/fxdiv/FXdiv-b408327ac2a15ec3e43352421954f5b1967701d1"
    "-DFETCHCONTENT_SOURCE_DIR_KLEIDIAI=/build/source/ext/kleidiai/kleidiai-dc69e899945c412a8ce39ccafd25139f743c60b1"

    "-DPTHREADPOOL_SOURCE_DIR=/build/source/ext/pthreadpool/pthreadpool-c2ba5c50bb58d1397b693740cf75fad836a0d1bf"
    "-DFP16_SOURCE_DIR=/build/source/ext/fp16/FP16-0a92994d729ff76a58f692d3028ca1b64b145d91"
    "-DFXDIV_SOURCE_DIR=/build/source/ext/fxdiv/FXdiv-b408327ac2a15ec3e43352421954f5b1967701d1"
    "-DKLEIDIAI_SOURCE_DIR=/build/source/ext/kleidiai/kleidiai-dc69e899945c412a8ce39ccafd25139f743c60b1"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DTFLITE_HOST_TOOLS_DIR=${flatbuffers_24}/bin"
  ];

  postInstall = ''
    mkdir -p $out/lib/lv2
    mv $out/guitarmidi.lv2 $out/lib/lv2/
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "A concept for guitar to midi as an lv2 plugin";
    homepage = "https://github.com/geraldmwangi/GuitarMidi-LV2";
    license = lib.licenses.lgpl2Plus;
    maintainers = with lib.maintainers; [ eymeric ];
    platforms = lib.platforms.linux;
  };
})
