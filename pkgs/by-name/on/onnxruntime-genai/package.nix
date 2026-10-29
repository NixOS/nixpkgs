{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  onnxruntime,
  patch,
}:

let
  # TODO: update the following dependencies according to:
  # https://github.com/microsoft/onnxruntime-genai/blob/v<VERSION>/cmake/deps.txt
  # https://github.com/microsoft/onnxruntime-extensions/tree/<REV>/cmake/externals

  onnxruntime-extensions-src = fetchFromGitHub {
    name = "onnxruntime-extensions-src";
    owner = "microsoft";
    repo = "onnxruntime-extensions";
    rev = "0353c93d966d74706724e41ddab63f580eebbbf0";
    hash = "sha256-2Pk4h7k4bMJGqazbwq+wpXalPIgVPl3ZJEKiLcdaAPM=";
  };

  blingfire-src = fetchFromGitHub {
    name = "blingfire-src";
    owner = "microsoft";
    repo = "BlingFire";
    rev = "0831265c1aca95ca02eca5bf1155e4251e545328";
    hash = "sha256-NNS+ggDx3NYLYqyWWwP8dAtV/fTJgp4EHTJwRMgOmzQ=";
  };

  # SentencePiece needs this exact protobuf version's sources
  protobuf-src = fetchFromGitHub {
    name = "protobuf-src";
    owner = "protocolbuffers";
    repo = "protobuf";
    tag = "v21.12";
    hash = "sha256-VZQEFHq17UsTH5CZZOcJBKiScGV2xPJ/e6gkkVliRCU=";
  };

  sentencepiece-src = fetchFromGitHub {
    name = "sentencepiece-src";
    owner = "google";
    repo = "sentencepiece";
    tag = "v0.1.96";
    hash = "sha256-jo8XlQJsnWpeeezDjNNhh6T473XMqe8fsApUr82Y3BU=";
  };

  dlib-src = fetchFromGitHub {
    name = "dlib-src";
    owner = "davisking";
    repo = "dlib";
    tag = "v19.24.7";
    hash = "sha256-cDJtBdDCuAFD0I2Eg9VKryWuxSl0NvWCPBWiG77CoXc=";
  };

  dr-libs-src = fetchFromGitHub {
    name = "dr-libs-src";
    owner = "mackron";
    repo = "dr_libs";
    rev = "660795b2834aebb2217c9849d668b6e4bd4ef810";
    hash = "sha256-7OGsfigCTBsUElitjl1diDZTRPaRdIuvEerXkojxkFc=";
  };

  gsl-src = fetchFromGitHub {
    name = "gsl-src";
    owner = "microsoft";
    repo = "GSL";
    tag = "v4.0.0";
    hash = "sha256-cXDFqt2KgMFGfdh6NGE+JmP4R0Wm9LNHM0eIblYe6zU=";
  };

  nlohmann-json-src = fetchFromGitHub {
    name = "nlohmann-json-src";
    owner = "nlohmann";
    repo = "json";
    tag = "v3.11.3";
    hash = "sha256-7F0Jon+1oWL7uqet5i1IgHX0fUw/+z0QwEcA3zs5xHg=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "onnxruntime-genai";
  version = "0.17.0";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "onnxruntime-genai";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zxIoRI4yl8EFSl8ecepjR2wp6ijQ6cLHI1nrW317WSc=";
  };

  nativeBuildInputs = [
    cmake
    patch
  ];

  buildInputs = [
    onnxruntime
  ];

  # Upstream's CMake patches some dependencies as it downloads them, which
  # doesn't happen with FETCHCONTENT_SOURCE_DIR_*, so patch writable copies
  # here instead.
  postPatch = ''
    mkdir deps
    cp -r --no-preserve=mode ${protobuf-src} deps/protobuf
    cp -r --no-preserve=mode ${sentencepiece-src} deps/sentencepiece
    cp -r --no-preserve=mode ${blingfire-src} deps/blingfire
    patch -d deps/protobuf -p1 --ignore-whitespace \
      < ${onnxruntime-extensions-src}/cmake/externals/protobuf_cmake.patch
    patch -d deps/sentencepiece -p1 --ignore-whitespace \
      < ${onnxruntime-extensions-src}/cmake/externals/sentencepieceproject_cmake.patch
    patch -d deps/sentencepiece -p1 --ignore-whitespace \
      < ${onnxruntime-extensions-src}/cmake/externals/sentencepieceproject_pb.patch
    # Upstream's patch has LF line endings, but the file it patches has CRLF
    sed -i 's/\r$//' deps/blingfire/CMakeLists.txt
    patch -d deps/blingfire -p1 --ignore-whitespace \
      < ${onnxruntime-extensions-src}/cmake/externals/blingfire_cmake.patch

    # The layout upstream expects for ORT_HOME
    mkdir -p ort/lib
    ln -s ${lib.getInclude onnxruntime}/include ort/include
    ln -s ${lib.getLib onnxruntime}/lib/* ort/lib/
  '';

  preConfigure = ''
    cmakeFlagsArray+=(
      -DFETCHCONTENT_SOURCE_DIR_BLINGFIRE=$PWD/deps/blingfire
      -DFETCHCONTENT_SOURCE_DIR_PROTOBUF=$PWD/deps/protobuf
      -DFETCHCONTENT_SOURCE_DIR_SPM=$PWD/deps/sentencepiece
      -DORT_HOME=$PWD/ort
    )
  '';

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_ONNXRUNTIME_EXTENSIONS" "${onnxruntime-extensions-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DLIB" "${dlib-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_DR_LIBS" "${dr-libs-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GSL" "${gsl-src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_NLOHMANN_JSON" "${nlohmann-json-src}")
    (lib.cmakeBool "USE_CUDA" false)
    (lib.cmakeBool "USE_GUIDANCE" false)
    (lib.cmakeBool "ENABLE_PYTHON" false)
    (lib.cmakeBool "ENABLE_TESTS" false)
    (lib.cmakeBool "ENABLE_MODEL_BENCHMARK" false)
    (lib.cmakeBool "ENABLE_TELEMETRY" false)
  ];

  meta = {
    description = "Generative AI extensions for ONNX Runtime";
    homepage = "https://github.com/microsoft/onnxruntime-genai";
    changelog = "https://github.com/microsoft/onnxruntime-genai/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.unix;
  };
})
