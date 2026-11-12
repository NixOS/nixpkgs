{
  lib,
  config,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  cmake,
  python3Packages ? { },
  nix-update-script,
  runCommand,

  # dependencies
  alsa-lib,
  eigen_5,
  gtest,
  kissfft,
  nlohmann_json,
  onnxruntime,

  # optional features
  cudaSupport ? config.cudaSupport,
  websocketSupport ? true,
  pythonSupport ? true,

}:

let
  # Pre-fetched dependencies for cmake FetchContent.
  # These are copied into the source tree so cmake finds them locally
  # instead of trying to download them (which fails in the sandbox).
  cache = [
    {
      name = "espeak-ng-ed530aa113046142eb5115cf2fc9157854d0ffe1.zip";
      src = fetchurl {
        url = "https://github.com/csukuangfj/espeak-ng/archive/ed530aa113046142eb5115cf2fc9157854d0ffe1.zip";
        hash = "sha256-5OJiy+NPf+IfkfG6M5fyco4fMOr7rnhT8rdTqe0T8N0=";
      };
    }
    {
      name = "kaldi-native-fbank-1.22.3.tar.gz";
      src = fetchurl {
        url = "https://github.com/csukuangfj/kaldi-native-fbank/archive/refs/tags/v1.22.3.tar.gz";
        hash = "sha256-kXbMZvx84e34XPNVsG4yDFfbYpffdCd/V1GDRoiTz2E=";
      };
    }
    {
      name = "simple-sentencepiece-0.7.tar.gz";
      src = fetchurl {
        url = "https://github.com/pkufool/simple-sentencepiece/archive/refs/tags/v0.7.tar.gz";
        hash = "sha256-F0ioIgYKNbqp9mCfhO/I61TcDnS57OPYI2e3EZ/cda8=";
      };
    }
    {
      name = "kaldifst-1.8.0.tar.gz";
      src = fetchurl {
        url = "https://github.com/k2-fsa/kaldifst/archive/refs/tags/v1.8.0.tar.gz";
        hash = "sha256-PyR7flokCQcSAvXivGIABg9mcowKNEPAOSOtJyPgQLM=";
      };
    }
    {
      name = "kaldi-decoder-0.3.0.tar.gz";
      src = fetchurl {
        url = "https://github.com/k2-fsa/kaldi-decoder/archive/refs/tags/v0.3.0.tar.gz";
        hash = "sha256-ufNM+0/TsTRBAO6tee9NN6oVliJ0ueMFbeNFAh92obA=";
      };
    }
    {
      name = "cargs-1.0.3.tar.gz";
      src = fetchurl {
        url = "https://github.com/likle/cargs/archive/refs/tags/v1.0.3.tar.gz";
        hash = "sha256-3bolvTXpxsdbxwbBJgAbjOjghNQO83BQ5qppY+g264s=";
      };
    }
    {
      name = "piper-phonemize-f3ff95afc03640bc1399e113e83361192a2fafb4.zip";
      src = fetchurl {
        url = "https://github.com/csukuangfj/piper-phonemize/archive/f3ff95afc03640bc1399e113e83361192a2fafb4.zip";
        hash = "sha256-2cyk4r3H1t2N/7lqRmgoPb0/d6nBlKPlMMHo66lAal0=";
      };
    }
    {
      name = "openfst-1.8.5-2026-07-09.tar.gz";
      src = fetchurl {
        url = "https://github.com/csukuangfj/openfst/archive/refs/tags/v1.8.5-2026-07-09.tar.gz";
        hash = "sha256-L/cSoylS/LAdNREhpryMz0/cayqgbOjfKzCV3t1RjA4=";
      };
    }
    {
      name = "hclust-cpp-2026-02-25.tar.gz";
      src = fetchurl {
        url = "https://github.com/csukuangfj/hclust-cpp/archive/refs/tags/2026-02-25.tar.gz";
        hash = "sha256-jxTgJMcJ1zr7QK5pyyLeS3Pbpny85A8uUYgT2oE5q1Y=";
      };
    }
  ]
  ++ lib.optionals websocketSupport [
    {
      name = "asio-asio-1-24-0.tar.gz";
      src = fetchurl {
        url = "https://github.com/chriskohlhoff/asio/archive/refs/tags/asio-1-24-0.tar.gz";
        hash = "sha256-y8qroPZnInh7Gnwzr+G++zoBK1rzrX2n/w9rjJt6ils=";
      };
    }
    {
      name = "websocketpp-b9aeec6eaf3d5610503439b4fae3581d9aff08e8.zip";
      src = fetchurl {
        url = "https://github.com/zaphoyd/websocketpp/archive/b9aeec6eaf3d5610503439b4fae3581d9aff08e8.zip";
        hash = "sha256-E4UTXt6Bkaf7757ICZ48Wmc9SN8MFDlYIWzRaQVn9YM=";
      };
    }
  ];

  # Use the same yesno TDNN model and audio sample as upstream's offline CTC test,
  # pinned to a Hugging Face repository commit:
  # https://github.com/k2-fsa/sherpa-onnx/blob/v1.13.8/.github/scripts/test-offline-ctc.sh
  yesnoModelRev = "93a6f1d8f477397fc607a6cb151bff7a68c28589";
  yesnoModelUrl = "https://huggingface.co/csukuangfj/sherpa-onnx-tdnn-yesno/resolve/${yesnoModelRev}";
  yesnoModel = fetchurl {
    url = "${yesnoModelUrl}/model-epoch-14-avg-2.onnx";
    hash = "sha256-xFIeHlyCwxH5A64skF1Nj53ccKCqjy/+ePRcTWclKsA=";
  };
  yesnoTokens = fetchurl {
    url = "${yesnoModelUrl}/tokens.txt";
    hash = "sha256-Zai7QPb5kTkd0WnmRjfYZk3ZEn6qeoioyOaUMXK8yMA=";
  };
  yesnoWav = fetchurl {
    url = "${yesnoModelUrl}/test_wavs/0_0_1_1_0_1_1_0.wav";
    hash = "sha256-04LPuot4IYNfYsfIHYtQnj46WXzeYqGQ1pC8R3IBy5k=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "sherpa-onnx";
  version = "1.13.8";

  src = fetchFromGitHub {
    owner = "k2-fsa";
    repo = "sherpa-onnx";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yAkjeRJXSiGW7Pr6cmHKUeYiWZyd88raEMdaJvYhQLM=";
  };

  outputs = [ "out" ] ++ lib.optionals pythonSupport [ "python" ];

  separateDebugInfo = true;

  patches = [
    ./espeak.patch
  ];

  nativeBuildInputs = [
    cmake
  ]
  ++ lib.optionals pythonSupport (
    with python3Packages;
    [
      python
    ]
  );

  buildInputs = [
    onnxruntime
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
  ];

  nativeCheckInputs = lib.optionals pythonSupport (
    with python3Packages;
    [
      numpy
      soundfile
    ]
  );

  # Populate pre-fetched dependencies so cmake FetchContent finds them
  # locally instead of attempting network downloads.
  preConfigure = ''
    ${lib.concatMapStringsSep "\n" (s: "cp ${s.src} ./${s.name}") cache}
  '';

  cmakeFlags = [
    (lib.cmakeBool "FETCHCONTENT_QUIET" false)
    (lib.cmakeBool "BUILD_SHARED_LIBS" true)
    (lib.cmakeBool "SHERPA_ONNX_ENABLE_WEBSOCKET" websocketSupport)
    (lib.cmakeBool "SHERPA_ONNX_ENABLE_PORTAUDIO" false)
    (lib.cmakeBool "SHERPA_ONNX_ENABLE_PYTHON" pythonSupport)
    (lib.cmakeBool "SHERPA_ONNX_BUILD_C_API_EXAMPLES" false)
    (lib.cmakeBool "SHERPA_ONNX_ENABLE_TESTS" true)
    (lib.cmakeFeature "onnxruntime_SOURCE_DIR" "${onnxruntime.dev}")
    (lib.cmakeBool "SHERPA_ONNX_ENABLE_GPU" cudaSupport)
    # Use nixpkgs sources instead of vendored downloads where possible.
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_JSON" "${nlohmann_json.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_EIGEN" "${eigen_5.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_GOOGLETEST" "${gtest.src}")
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_KISSFFT" "${kissfft.src}")
    "-Wno-dev"
  ]
  ++ lib.optionals pythonSupport [
    (lib.cmakeFeature "PYTHON_EXECUTABLE" (lib.getExe python3Packages.python))
    (lib.cmakeFeature "FETCHCONTENT_SOURCE_DIR_PYBIND11" "${python3Packages.pybind11.src}")
  ];

  # Place the native extension alongside the Python source so that both
  # checkPhase and postInstall can find a complete sherpa_onnx package.
  # Upstream's __init__.py imports from sherpa_onnx.lib._sherpa_onnx.
  postBuild = lib.optionalString pythonSupport ''
    mkdir -p ../sherpa-onnx/python/sherpa_onnx/lib
    cp lib/_sherpa_onnx*.so ../sherpa-onnx/python/sherpa_onnx/lib/
  '';

  doCheck = true;

  # Use ctest directly because the default `make check` target includes clang-tidy.
  checkPhase = ''
    runHook preCheck
    ctest --output-on-failure
    runHook postCheck
  '';

  postInstall = lib.optionalString pythonSupport ''
    mkdir -p $python
    cp -r ../sherpa-onnx/python/sherpa_onnx $python/
    rm $out/lib/_sherpa_onnx*.so
  '';

  passthru = {
    updateScript = nix-update-script { };

    # Exercise the installed CLI, ONNX Runtime, model loading, and transcription.
    # Upstream's yesno model test and expected transcripts:
    # https://k2-fsa.github.io/sherpa/onnx/pretrained_models/offline-ctc/yesno/
    tests.offlineRecognition =
      runCommand "${finalAttrs.pname}-offline-recognition-test"
        {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        }
        ''
          sherpa-onnx-offline \
            --sample-rate=8000 \
            --feat-dim=23 \
            --num-threads=1 \
            --tokens=${yesnoTokens} \
            --tdnn-model=${yesnoModel} \
            ${yesnoWav} > result.txt 2>&1

          grep -Fq '"text": "NNYYNYYN"' result.txt
          touch $out
        '';
  };

  meta = {
    description = "Speech-to-text, text-to-speech, and speaker recognition using next-gen Kaldi with onnxruntime";
    homepage = "https://github.com/k2-fsa/sherpa-onnx";
    changelog = "https://github.com/k2-fsa/sherpa-onnx/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [
      jaredmontoya
      ryan4yin
    ];
    mainProgram = "sherpa-onnx";
  };
})
