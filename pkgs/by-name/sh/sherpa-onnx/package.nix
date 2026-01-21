{
  lib,
  fetchFromGitHub,
  fetchurl,
  cmake,
  pkg-config,
  python3Packages,
  alsa-lib,
  espeak-ng,
  onnxruntime,
  cudaSupport ? onnxruntime.cudaSupport,
  cudaPackages ? { },
  stdenv,
  alsa-plugins,
  clang-tools,
  tree,
}:

let
  version = "1.12.23";

  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else stdenv;

  cudaCapabilities = cudaPackages.cudaFlags.cudaCapabilities;
  # E.g. [ "80" "86" "90" ]
  cudaArchitectures = (map cudaPackages.cudaFlags.dropDot cudaCapabilities);
  cudaArchitecturesString = lib.strings.concatStringsSep ";" cudaArchitectures;

  espeak-ng-patched = (
    espeak-ng.overrideAttrs (old: {
      version = "f6fed6c58b5e0998b8e68c6610125e2d07d595a7";
      src = fetchFromGitHub {
        owner = "espeak-ng";
        repo = "espeak-ng";
        rev = "f6fed6c58b5e0998b8e68c6610125e2d07d595a7";
        hash = "sha256-+3JHColf/g/T7zDIGIUmj8hig+uZMN0KqlTVzIXsNTw=";
      };
      postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
        wrapProgram $out/bin/espeak-ng-bin \
          --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib
      '';
      patches = [ ];
    })
  );

  cache = [
    {
      name = "espeak-ng-f6fed6c58b5e0998b8e68c6610125e2d07d595a7.zip";
      src = fetchurl {
        url = "https://github.com/csukuangfj/espeak-ng/archive/f6fed6c58b5e0998b8e68c6610125e2d07d595a7.zip";
        hash = "sha256-cMv0BQ56AUquGRQLBeVySdpHIPVhKEWfvjqTvq+XGuY=";
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
      name = "pybind11-3.0.0.tar.gz";
      src = fetchurl {
        url = "https://github.com/pybind/pybind11/archive/refs/tags/v3.0.0.tar.gz";
        hash = "sha256-RTsaPismbDrp2ockEcrbbWk6wYBjvXMibZbPtwFaIAw=";
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
      name = "kaldifst-1.7.17.tar.gz";
      src = fetchurl {
        url = "https://github.com/k2-fsa/kaldifst/archive/refs/tags/v1.7.17.tar.gz";
        hash = "sha256-xLcBojpAC9qAMlhrAsfg1egTp2WDLfYMI+bfnmKwEPQ=";
      };
    }
    {
      name = "kaldi-decoder-0.2.10.tar.gz";
      src = fetchurl {
        url = "https://github.com/k2-fsa/kaldi-decoder/archive/refs/tags/v0.2.10.tar.gz";
        hash = "sha256-o9YC7cH0Iqz+ZjFT+vPwpxYwXsH5W4/PnSjTAdaCcwk=";
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
      name = "piper-phonemize-78a788e0b719013401572d70fef372e77bff8e43.zip";
      src = fetchurl {
        url = "https://github.com/csukuangfj/piper-phonemize/archive/78a788e0b719013401572d70fef372e77bff8e43.zip";
        hash = "sha256-iWQaRkiaSJh1RkPOV72pybVLTKRkhf3AK/DchLhmZF0=";
      };
    }
    {
      name = "eigen-3.4.0.tar.gz";
      src = fetchurl {
        url = "https://gitlab.com/libeigen/eigen/-/archive/3.4.0/eigen-3.4.0.tar.gz";
        hash = "sha256-hYYIT3H5veVF7n+m0AKIsmSit6w2B7l05U0T5xYsHHI=";
      };
    }
    {
      name = "openfst-sherpa-onnx-2024-06-19.tar.gz";
      src = fetchurl {
        url = "https://github.com/csukuangfj/openfst/archive/refs/tags/sherpa-onnx-2024-06-19.tar.gz";
        hash = "sha256-XJjoLMUJxWGFAt3khguOoE2EOFDtV+bWtZC2RLJohT0=";
      };
    }
    {
      name = "hclust-cpp-2024-09-29.tar.gz";
      src = fetchurl {
        url = "https://github.com/csukuangfj/hclust-cpp/archive/refs/tags/2024-09-29.tar.gz";
        hash = "sha256-q6tRRIo8tUJyquB1IpcDBuCyzGR51Z17Geeu5NbO3TM=";
      };
    }
    {
      name = "asio-asio-1-24-0.tar.gz";
      src = fetchurl {
        url = "https://github.com/chriskohlhoff/asio/archive/refs/tags/asio-1-24-0.tar.gz";
        hash = "sha256-y8qroPZnInh7Gnwzr+G++zoBK1rzrX2n/w9rjJt6ils=";
      };
    }
    {
      name = "googletest-1.13.0.tar.gz";
      src = fetchurl {
        url = "https://github.com/google/googletest/archive/refs/tags/v1.13.0.tar.gz";
        hash = "sha256-rX/boR6gEcHZJbMonPSvLGajUuGNTHJkOS/q116Rk2M=";
      };
    }
    {
      name = "pa_stable_v190700_20210406.tgz";
      src = fetchurl {
        url = "http://files.portaudio.com/archives/pa_stable_v190700_20210406.tgz";
        hash = "sha256-R++/Qsd8GaBdIuYn1Chz6ZHsDBNXIZwNdM5qKUjLLe8=";
      };
    }
    {
      name = "websocketpp-b9aeec6eaf3d5610503439b4fae3581d9aff08e8.zip";
      src = fetchurl {
        url = "https://github.com/zaphoyd/websocketpp/archive/b9aeec6eaf3d5610503439b4fae3581d9aff08e8.zip";
        hash = "sha256-E4UTXt6Bkaf7757ICZ48Wmc9SN8MFDlYIWzRaQVn9YM=";
      };
    }
    {
      name = "kissfft-febd4caeed32e33ad8b2e0bb5ea77542c40f18ec.zip";
      src = fetchurl {
        url = "https://github.com/mborgerding/kissfft/archive/febd4caeed32e33ad8b2e0bb5ea77542c40f18ec.zip";
        hash = "sha256-SXED5mQWjr45WAt1etvmFvbPhaFlcq9YHKe8QtCrE/0=";
      };
    }
  ];
in
effectiveStdenv.mkDerivation rec {
  pname = "sherpa-onnx";
  inherit version;

  src = fetchFromGitHub {
    owner = "k2-fsa";
    repo = "sherpa-onnx";
    rev = "v${version}";
    hash = "sha256-FZbFhePhQqUow2rXjGVjqo8nvvB43SUymmHR3TMdEas=";
    fetchSubmodules = true;
  };
  separateDebugInfo = true;
  patches = [
    ./espeak.patch
  ];
  nativeBuildInputs = [
    cmake
    pkg-config
    python3Packages.python
    espeak-ng-patched
  ]
  ++ (with python3Packages; [
    pip
    python
    build
    setuptools
    wheel
    onnxruntime
    pybind11
    numpy
  ])
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ];

  buildInputs = [
    alsa-lib
    clang-tools
  ]
  ++ (with python3Packages; [
    packaging
  ])
  ++ lib.optionals cudaSupport (
    with cudaPackages;
    [
      cuda_cccl # cub/cub.cuh
      libcublas # cublas_v2.h
      libcurand # curand.h
      libcusparse # cusparse.h
      libcufft # cufft.h
      cudnn # cudnn.h
      cuda_cudart
      nccl # cudnn.h
    ]
  );
  outputs = [
    "out"
    "python"
  ];

  enableParallelBuilding = true;

  cmakeDir = "cmake";

  # populate dependencies for cmake
  preConfigure = ''
    original_ifs="$IFS"
    for i in ${lib.concatStringsSep " " (map (s: "${s.name},${s.src}") cache)}; do
      IFS=","
      set -- $i
      echo "$1" "$2"
      cp -r $2 ./$1
    done
    IFS="$original_ifs"
    unset original_ifs
  '';

  cmakeFlags = [
    "-S .."
    "-DFETCHCONTENT_QUIET=OFF"
    "-DBUILD_SHARED_LIBS=ON"
    "-DSHERPA_ONNX_ENABLE_WEBSOCKET=OFF"
    "-DSHERPA_ONNX_ENABLE_PORTAUDIO=OFF"
    "-DSHERPA_ONNX_ENABLE_PYTHON=ON"
    "-DSHERPA_ONNX_BUILD_C_API_EXAMPLES=OFF"
    "-DSHERPA_ONNX_ENABLE_EPSEAK_NG_EXE=OFF"
    "-DSHERPA_ONNX_ENABLE_CHECK=OFF"
    "-DSHERPA_ONNX_ENABLE_C_API=ON"
    "-Donnxruntime_SOURCE_DIR=${onnxruntime.dev}"
    "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
    "-DCMAKE_INSTALL_PREFIX=./install"
    "-DSHERPA_ONNX_ENABLE_GPU=${if cudaSupport then "ON" else "OFF"}"
    "-Wno-dev"
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "onnxruntime_CUDNN_HOME" "${cudaPackages.cudnn}")
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaArchitecturesString)
  ];

  env = lib.optionalAttrs effectiveStdenv.cc.isClang {
    NIX_CFLAGS_COMPILE = toString [
      "-Wno-error=deprecated-declarations"
    ];
  };

  # doCheck = false;

  requiredSystemFeatures = lib.optionals cudaSupport [ "big-parallel" ];

  buildPhase = ''
    export CMAKE_ARGS="''${cmakeFlags[*]}"
    python -m build --wheel --no-isolation --skip-dependency-check --outdir "$python/" ..
  '';

  postInstall = ''
    ${tree}/bin/tree /build/source/build
    cp -R /build/source/build/install/bin $out
    cp -R /build/source/build/install/include $out
    cp -R /build/source/build/install/lib $out
  '';

  passthru = {
    inherit cudaSupport cudaPackages onnxruntime; # for the nugets, wheels etc
    espeak-ng = espeak-ng-patched;
  };

  meta = with lib; {
    description = "Speech-to-text, text-to-speech, and speaker recongition using next-gen Kaldi with onnxruntime without Internet connection.";
    longDescription = ''
      Speech-to-text, text-to-speech, and speaker recongition using next-gen Kaldi with onnxruntime without Internet connection.
    '';
    homepage = "https://github.com/k2-fsa/sherpa-onnx";
    changelog = "https://github.com/k2-fsa/sherpa-onnx/releases/tag/v${version}";
    platforms = platforms.unix;
    license = licenses.asl20;
    maintainers = [];
  };
}
