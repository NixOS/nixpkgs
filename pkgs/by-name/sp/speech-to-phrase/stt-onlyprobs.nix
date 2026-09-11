{
  src,
  version,

  abseil-cpp,
  cmake,
  cpuinfo,
  eigen,
  fetchFromGitHub,
  fp16,
  lib,
  stdenv,
}:

let
  # https://github.com/coqui-ai/tensorflow/blob/f8242ebc005f6195b67d58349724e608d4fe45da/tensorflow/lite/tools/cmake/modules/farmhash.cmake#L22
  farmhash = fetchFromGitHub {
    name = "farmhash-source";
    owner = "google";
    repo = "farmhash";
    rev = "0d859a811870d10f53a594927d0d0b97573ad06d";
    hash = "sha256-J0AhHVOvPFT2SqvQ+evFiBoVfdHthZSBXzAhUepARfA=";
  };

  # https://github.com/coqui-ai/tensorflow/blob/f8242ebc005f6195b67d58349724e608d4fe45da/tensorflow/lite/tools/cmake/modules/fft2d.cmake#L22
  fft2d = fetchFromGitHub {
    name = "fft2d-source";
    owner = "petewarden";
    repo = "OouraFFT";
    tag = "v1.0";
    hash = "sha256-mkG6jWuMVzCB433qk2wW/HPA9vp/LivPTDa2c0hFir4=";
  };

  # https://github.com/coqui-ai/tensorflow/blob/f8242ebc005f6195b67d58349724e608d4fe45da/tensorflow/lite/tools/cmake/modules/flatbuffers.cmake#L22
  flatbuffers = fetchFromGitHub {
    name = "flatbuffers-source";
    owner = "google";
    repo = "flatbuffers";
    tag = "v1.12.0";
    hash = "sha256-L1B5Y/c897Jg9fGwT2J3+vaXsZ+lfXnskp8Gto1p/Tg=";
  };

  # https://github.com/google/XNNPACK/blob/11b2812d64e49bab9b6c489f79067fc94e69db9f/cmake/DownloadFXdiv.cmake#L14
  fxdiv = fetchFromGitHub {
    name = "fxdiv-source";
    owner = "Maratyszcza";
    repo = "FXdiv";
    rev = "b408327ac2a15ec3e43352421954f5b1967701d1";
    hash = "sha256-BEjscsejYVhRxDAmah5DT3+bglp8G5wUTTYL7+HjWds=";
  };

  # https://github.com/coqui-ai/tensorflow/blob/f8242ebc005f6195b67d58349724e608d4fe45da/tensorflow/lite/tools/cmake/modules/gemmlowp.cmake#L22
  gemmlowp = fetchFromGitHub {
    name = "gemmlowp-source";
    owner = "google";
    repo = "gemmlowp";
    rev = "fda83bdc38b118cc6b56753bd540caa49e570745";
    hash = "sha256-tE+w72sfudZXWyMxG6CGMqXYswve57/cpvwrketEd+k=";
  };

  # https://github.com/coqui-ai/tensorflow/blob/f8242ebc005f6195b67d58349724e608d4fe45da/tensorflow/lite/tools/cmake/modules/neon2sse.cmake#L22
  neon2sse = fetchFromGitHub {
    name = "neon2sse-source";
    owner = "intel";
    repo = "ARM_NEON_2_x86_SSE";
    rev = "6315d3c5007e6c209eb77abae4deece4978d8dbc";
    hash = "sha256-wlaraZ4Ga/J2pRo7yQmAI1Wfu57Jg1kWe2LFP4qB5uY=";
  };

  # https://github.com/google/XNNPACK/blob/11b2812d64e49bab9b6c489f79067fc94e69db9f/cmake/DownloadPThreadPool.cmake#L14
  pthreadpool = fetchFromGitHub {
    name = "pthreadpool-source";
    owner = "Maratyszcza";
    repo = "pthreadpool";
    rev = "545ebe9f225aec6dca49109516fac02e973a3de2";
    hash = "sha256-sBpMElc8kUYV6EfLD+OmrZZzeN6NDdu3U4/cInAny7M=";
  };

  # https://github.com/coqui-ai/tensorflow/blob/f8242ebc005f6195b67d58349724e608d4fe45da/tensorflow/lite/tools/cmake/modules/ruy.cmake#L22
  ruy = fetchFromGitHub {
    name = "ruy-source";
    owner = "google";
    repo = "ruy";
    rev = "e6c1b8dc8a8b00ee74e7268aac8b18d7260ab1ce";
    hash = "sha256-OF0Bp29ftiCpulc2n/SojamJZa4ufneWseD+Ib2GC84=";
  };

  # https://github.com/coqui-ai/tensorflow/blob/f8242ebc005f6195b67d58349724e608d4fe45da/tensorflow/lite/tools/cmake/modules/xnnpack.cmake#L22
  xnnpack = fetchFromGitHub {
    name = "xnnpack-source";
    owner = "google";
    repo = "XNNPACK";
    rev = "11b2812d64e49bab9b6c489f79067fc94e69db9f";
    hash = "sha256-YWP6YfwHBppfamz+aAs4rTMu6yvPifGYBsGNoWHoCOg=";
  };
in
stdenv.mkDerivation {
  pname = "stt_onlyprobs";
  inherit version src;

  sourceRoot = "${src.name}/coqui_stt/src";

  postPatch = ''
    # let tensorflow patch in the eigen source code
    cp -r ${eigen.src}/ ../../../eigen
    chmod -R +w ../../../eigen ../tensorflow

    sed -e '1i #include <cstdint>' -i alphabet.cc ../tensorflow/tensorflow/lite/kernels/internal/spectrogram.cc
  '';

  nativeBuildInputs = [ cmake ];

  cmakeFlags = [
    (lib.cmakeFeature "CMAKE_POLICY_VERSION_MINIMUM" "3.5") # would need to be patched in flatbuffers

    # Tensorflow
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ABSEIL-CPP" "${abseil-cpp.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CLOG" "${cpuinfo.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_CPUINFO" "${cpuinfo.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_EIGEN" "/build/eigen")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FARMHASH" "${farmhash}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FFT2D" "${fft2d}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_FLATBUFFERS" "${flatbuffers}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GEMMLOWP" "${gemmlowp}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NEON2SSE" "${neon2sse}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_RUY" "${ruy}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_XNNPACK" "${xnnpack}")

    # XNNPACK
    (lib.cmakeFeature "FP16_SOURCE_DIR" "${fp16.src}")
    (lib.cmakeFeature "FXDIV_SOURCE_DIR" "${fxdiv}")
    (lib.cmakeFeature "PTHREADPOOL_SOURCE_DIR" "${pthreadpool}")
  ];

  # Required for abseil-cpp, setting CMAKE_CXX_STANDARD to 17 did not work
  NIX_CFLAGS_COMPILE = "-std=c++17";

  installPhase = ''
    mkdir -p $out/bin
    cp stt_onlyprobs $out/bin
  '';

  meta = {
    mainProgram = "stt_onlyprobs";
    license = lib.licenses.mpl20;
    platforms = [ "x86_64-linux" ];
  };
}
