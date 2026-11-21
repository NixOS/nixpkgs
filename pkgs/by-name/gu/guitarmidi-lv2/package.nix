{
  stdenv,
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  fetchzip,
  cmake,
  pkg-config,
  python3,
  zita-resampler,
  lv2,
  libx11,
  cairo,
  buildPackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guitarmidi-lv2";
  version = "3.1";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "geraldmwangi";
    repo = "GuitarMidi-LV2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6QPQHFNAh7rn8bzFnQB9vo2fpcigLrYaOGsEd/jRjoY=";
  };

  # Pinned TensorFlow commit required by GuitarMidi-LV2 v3.1
  tensorflow-src = fetchFromGitHub {
    owner = "tensorflow";
    repo = "tensorflow";
    rev = "a481b10260dfdf833a1b16007eead49c1d7febf3";
    hash = "sha256-Hs3g80wSHex1ejz7H8eu6MJMzwthx58sPGDh/dG66FQ=";
  };

  # Source: tensorflow/lite/tools/cmake/modules/abseil-cpp.cmake
  abseil-cpp-src = fetchFromGitHub {
    owner = "abseil";
    repo = "abseil-cpp";
    rev = "d38452e1ee03523a208362186fd42248ff2609f6";
    hash = "sha256-SCQDORhmJmTb0CYm15zjEa7dkwc+lpW2s1d4DsMRovI=";
  };

  # Source: tensorflow/lite/tools/cmake/modules/eigen.cmake
  eigen-src = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    rev = "dcbaf2d608f306450f1e74949eb87e9a22a7ef4b";
    hash = "sha256-RQUrjh9hlWS+3Nf43mkohTfS5642DKkLBfbMOHPZbnk=";
  };

  # Source: tensorflow/lite/tools/cmake/modules/gemmlowp.cmake
  gemmlowp-src = fetchFromGitHub {
    owner = "google";
    repo = "gemmlowp";
    rev = "16e8662c34917be0065110bfcd9cc27d30f52fdf";
    hash = "sha256-e6AeRhZioIiTG5R+IA9g2GBqI4o74wijJYmqINLOtQs=";
  };

  # Source: tensorflow/lite/tools/cmake/modules/ruy.cmake
  ruy-src = fetchFromGitHub {
    owner = "google";
    repo = "ruy";
    rev = "3286a34cc8de6149ac6844107dfdffac91531e72";
    hash = "sha256-2l2RA/VHF9VgHzkPtFdtpVQJtgUw+iT7q4rUBT4R3GE=";
  };

  # Source: tensorflow/lite/tools/cmake/modules/cpuinfo.cmake
  cpuinfo-src = fetchFromGitHub {
    owner = "pytorch";
    repo = "cpuinfo";
    rev = "8a9210069b5a37dd89ed118a783945502a30a4ae";
    hash = "sha256-zEhgihmzfuTJkbIqtHuYv/d7F7j6QRJqU9ZHdIwW7bI=";
  };

  # Source: tensorflow/lite/tools/cmake/modules/xnnpack.cmake
  xnnpack-src = fetchFromGitHub {
    owner = "google";
    repo = "XNNPACK";
    rev = "25b42dfddb0ee22170d73ff0d4b333ea1e6edfeb";
    hash = "sha256-b9pGgen4TsbaJu6iJGZjA38GOBUXDS3ktg4bZ3kfpmg=";
  };

  # Source: tensorflow/lite/tools/cmake/modules/farmhash.cmake
  farmhash-src = fetchFromGitHub {
    owner = "google";
    repo = "farmhash";
    rev = "0d859a811870d10f53a594927d0d0b97573ad06d";
    hash = "sha256-J0AhHVOvPFT2SqvQ+evFiBoVfdHthZSBXzAhUepARfA=";
  };

  # Source: tensorflow/lite/tools/cmake/modules/ml_dtypes.cmake
  ml_dtypes-src = fetchFromGitHub {
    owner = "jax-ml";
    repo = "ml_dtypes";
    rev = "00d98cd92ade342fef589c0470379abb27baebe9";
    hash = "sha256-jY3g0+Uebdj+C2HLfXXq1fO/gnJMQQE/AE0RfxjI5f4=";
  };

  # Source: tensorflow/lite/tools/cmake/modules/flatbuffers.cmake
  flatbuffers-src = fetchFromGitHub {
    owner = "google";
    repo = "flatbuffers";
    rev = "v25.9.23";
    hash = "sha256-A9nWfgcuVW3x9MDFeviCUK/oGcWJQwadI8LqNR8BlQw=";
  };

  # Source: tensorflow/lite/tools/cmake/modules/protobuf.cmake
  protobuf-src = fetchFromGitHub {
    owner = "protocolbuffers";
    repo = "protobuf";
    rev = "90b73ac3f0b10320315c2ca0d03a5a9b095d2f66";
    hash = "sha256-17WAhwUvxIQD/QCyQglPVElQ38D/J1FA32hZ8Q8kID0=";
  };

  # Source: tensorflow/lite/cmake/DownloadPThreadPool.cmake
  pthreadpool-src = fetchzip {
    url = "https://github.com/google/pthreadpool/archive/0e6ca13779b57d397a5ba6bfdcaa8a275bc8ea2e.zip";
    hash = "sha256-FPUKjWARY4TdUq7ni48tnszEdmVYxPXIgtddPBHn/U0=";
  };

  # Source: tensorflow/third_party/xla/workspace2.bzl (only used on aarch64)
  kleidiai-src = fetchzip {
    url = "https://github.com/ARM-software/kleidiai/archive/63205aa90afa6803d8f58bc3081b69288e9f1906.zip";
    hash = "sha256-//o0/geqeGum6blRpMwDIcCRsYnm2/2illT0+FKxkZ0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    python3
  ];

  buildInputs = [
    zita-resampler
    lv2
    libx11
    cairo
  ];

  postPatch = ''
    # 1. Setup TensorFlow source
    mkdir -p ext/tensorflow
    cp -r ${finalAttrs.tensorflow-src}/* ext/tensorflow/
    chmod -R +w ext/tensorflow

    # 2. Patch TensorFlow Lite CMake to disable the profiling proto, core examples,
    #    benchmark tool and label_image example
    substituteInPlace ext/tensorflow/tensorflow/lite/CMakeLists.txt \
      --replace-fail 'add_subdirectory(''${TFLITE_SOURCE_DIR}/profiling/proto)' "" \
      --replace-fail 'add_subdirectory(''${TF_SOURCE_DIR}/core/example ''${CMAKE_BINARY_DIR}/example_proto_generated)' "" \
      --replace-fail 'add_subdirectory(''${TFLITE_SOURCE_DIR}/tools/benchmark)' "" \
      --replace-fail 'add_subdirectory(''${TFLITE_SOURCE_DIR}/examples/label_image)' ""

    # 3. Setup other fetched dependencies in writable paths
    mkdir -p build-deps
    for dep in abseil-cpp eigen gemmlowp ruy cpuinfo xnnpack farmhash ml_dtypes flatbuffers protobuf pthreadpool kleidiai; do
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
    cp -r ${finalAttrs.flatbuffers-src}/* build-deps/flatbuffers/
    cp -r ${finalAttrs.protobuf-src}/* build-deps/protobuf/
    cp -r ${finalAttrs.pthreadpool-src}/* build-deps/pthreadpool/
    cp -r ${finalAttrs.kleidiai-src}/* build-deps/kleidiai/

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
    "-DFETCHCONTENT_SOURCE_DIR_FLATBUFFERS=/build/source/build-deps/flatbuffers"
    "-DFETCHCONTENT_SOURCE_DIR_PROTOBUF=/build/source/build-deps/protobuf"
    "-DFETCHCONTENT_SOURCE_DIR_PTHREADPOOL=/build/source/build-deps/pthreadpool"
    "-DFETCHCONTENT_SOURCE_DIR_KLEIDIAI=/build/source/build-deps/kleidiai"

    # Committed under the project's ext/ directory, matching the pinned TF versions
    "-DFETCHCONTENT_SOURCE_DIR_FFT2D=/build/source/ext/fft2d/OouraFFT-1.0"
    "-DFETCHCONTENT_SOURCE_DIR_NEON2SSE=/build/source/ext/neon2sse/ARM_NEON_2_x86_SSE-a15b489e1222b2087007546b4912e21293ea86ff"
    "-DFETCHCONTENT_SOURCE_DIR_FP16=/build/source/ext/fp16/FP16-0a92994d729ff76a58f692d3028ca1b64b145d91"
    "-DFETCHCONTENT_SOURCE_DIR_FXDIV=/build/source/ext/fxdiv/FXdiv-b408327ac2a15ec3e43352421954f5b1967701d1"

    "-DPTHREADPOOL_SOURCE_DIR=/build/source/build-deps/pthreadpool"
    "-DKLEIDIAI_SOURCE_DIR=/build/source/build-deps/kleidiai"
    "-DFP16_SOURCE_DIR=/build/source/ext/fp16/FP16-0a92994d729ff76a58f692d3028ca1b64b145d91"
    "-DFXDIV_SOURCE_DIR=/build/source/ext/fxdiv/FXdiv-b408327ac2a15ec3e43352421954f5b1967701d1"
  ]
  ++ lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
    "-DTFLITE_HOST_TOOLS_DIR=${
      buildPackages.flatbuffers.overrideAttrs (oldAttrs: {
        version = "25.9.23";
        src = finalAttrs.flatbuffers-src;
      })
    }/bin"
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
