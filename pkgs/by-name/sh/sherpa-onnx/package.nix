{
  config,
  stdenv,
  lib,
  fetchFromGitHub,
  fetchFromGitLab,
  cmake,
  fetchpatch,
  mbrola,
  substituteAll,
  bash,
  pkg-config,
  python3Packages,
  re2,
  zlib,
  alsa-lib,
  espeak-ng,
  buildEnv,
  onnxruntime,
  cudaSupport ? onnxruntime.cudaSupport,
  cudaPackages ? { },
  buildNugets ? true,
  tree,
}@inputs:

let
  version = "1.10.27";

  stdenv = throw "Use effectiveStdenv instead";
  effectiveStdenv = if cudaSupport then cudaPackages.backendStdenv else inputs.stdenv;

  cudaCapabilities = cudaPackages.cudaFlags.cudaCapabilities;
  # E.g. [ "80" "86" "90" ]
  cudaArchitectures = (builtins.map cudaPackages.cudaFlags.dropDot cudaCapabilities);
  cudaArchitecturesString = lib.strings.concatStringsSep ";" cudaArchitectures;

  eigen = fetchFromGitLab {
    owner = "libeigen";
    repo = "eigen";
    rev = "3.4.0";
    hash = "sha256-1/4xMetKMDOgZgzz3WMxfHUEpmdAm52RqZvz6i0mLEw=";
  };

  kaldi-native-fbank = fetchFromGitHub {
    owner = "csukuangfj";
    repo = "kaldi-native-fbank";
    rev = "v1.20.0";
    sha256 = "sha256-AIbX/eDIpsBI3UA7YPZ2QoNhyyI/5az1XTRVHJxcwgA=";
  };

  kaldifst = fetchFromGitHub {
    owner = "k2-fsa";
    repo = "kaldifst";
    rev = "v1.7.11";
    sha256 = "sha256-0xsTj/iY4HX9COWGBvO5V7EU/j6S6LGlU3HQ9f2oOJc=";
  };

  kaldi-decoder = fetchFromGitHub {
    owner = "k2-fsa";
    repo = "kaldi-decoder";
    rev = "v0.2.7";
    sha256 = "sha256-5dbp7TxvXC1cLszniTSntTWIuWW/PkjnNRDgdvFwfP8=";
  };

  openfst = fetchFromGitHub {
    owner = "csukuangfj";
    repo = "openfst";
    rev = "sherpa-onnx-2024-06-13";
    sha256 = "sha256-tFdt7jVV9UJUVVywHWVgSC5RtfoFABnmks8zec0vpdo=";
  };

  espeak-ng-patched = espeak-ng.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "csukuangfj";
      repo = "espeak-ng";
      rev = "f6fed6c58b5e0998b8e68c6610125e2d07d595a7";
      sha256 = "sha256-+3JHColf/g/T7zDIGIUmj8hig+uZMN0KqlTVzIXsNTw=";
    };
    patches = [ ];
  });

  piper-phonemize = fetchFromGitHub {
    owner = "csukuangfj";
    repo = "piper-phonemize";
    rev = "dc6b5f4441bffe521047086930b0fc12686acd56";
    sha256 = "sha256-48Kgjb3FLOtm0CwzeCK4/f9gSrayu2ApFpMkreyCjkA=";
  };

  cppjieba = fetchFromGitHub {
    owner = "csukuangfj";
    repo = "cppjieba";
    rev = "sherpa-onnx-2024-04-19";
    sha256 = "sha256-HVStYzzQMoOa20kbgRlIaNrES8N2LEJdCtwbQl713wc=";
  };

  cargs = fetchFromGitHub {
    owner = "likle";
    repo = "cargs";
    rev = "v1.0.3";
    sha256 = "sha256-iQHZRYcCzdW+Jlkv0tmPRF05HnJ/7LrEdkoR6vJk6iM=";
  };
  simple-sentencepiece = fetchFromGitHub {
    owner = "pkufool";
    repo = "simple-sentencepiece";
    rev = "v0.7";
    sha256 = "sha256-HRi8XsMWD6Tkf1nojzzbafSKTIEhQCRSki/IQrfOB4w=";
  };
  sources = [
    {
      name = "espeak_ng";
      src = espeak-ng-patched.src;
    }
    {
      name = "kaldi_native_fbank";
      src = kaldi-native-fbank;
    }
    {
      name = "pybind11";
      src = python3Packages.pybind11.src;
    }
    {
      name = "simple-sentencepiece";
      src = simple-sentencepiece;
    }
    {
      name = "kaldifst";
      src = kaldifst;
    }
    {
      name = "kaldi_decoder";
      src = kaldi-decoder;
    }
    {
      name = "cargs";
      src = cargs;
    }
    {
      name = "cppjieba";
      src = cppjieba;
    }
    {
      name = "piper_phonemize";
      src = piper-phonemize;
    }
    {
      name = "eigen";
      src = eigen;
    }
    {
      name = "openfst";
      src = openfst;
    }
  ];

  ort = buildEnv {
    name = "ort";
    paths = [
      onnxruntime
      onnxruntime.dev
    ];
  };

in
effectiveStdenv.mkDerivation rec {
  pname = "sherpa-onnx";
  inherit version;

  src = fetchFromGitHub {
    owner = "k2-fsa";
    repo = "sherpa-onnx";
    rev = "refs/tags/v${version}";
    hash = "sha256-WlGbOJ5q307IJ9Y9TjQ/WPgm1s8g+pQNpYxcSSEvT8s=";
    fetchSubmodules = true;
  };
  separateDebugInfo = true;
  patches = [
    ./espeak.patch
  ];
  nativeBuildInputs =
    [
      cmake
      pkg-config
      python3Packages.python

    ]
    ++ (with python3Packages; [
      pip
      python
      setuptools
      wheel
      onnx
      onnxruntime
      pybind11
      jinja2
    ])
    ++ lib.optionals cudaSupport [
      cudaPackages.cuda_nvcc
    ];

  buildInputs =
    [
      onnxruntime
      alsa-lib
      espeak-ng-patched
    ]
    ++ (with python3Packages; [
      numpy
      pybind11
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
  outputs = [ "out" ];

  enableParallelBuilding = true;

  cmakeDir = "cmake";
  # populate dependencies for cmake
  preConfigure = ''
    original_ifs="$IFS"
    for i in ${lib.concatStringsSep " " (map (s: ''${s.name},${s.src}'') sources)}; do
      IFS=","
      set -- $i
      dst="/build/source/build/_deps/''${1}-src"
      mkdir -p $dst
      cp -r ''${2}/* $dst/
      echo "Copied ''${2}/* to ''${dst}"
    done
    IFS="$original_ifs"
    unset original_ifs
    chmod -R +w /build/source/build/_deps/

  '';
  cmakeFlags =
    [
      "-S .."
      "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
      "-DFETCHCONTENT_QUIET=OFF"
      "-DBUILD_SHARED_LIBS=ON"
      "-DSHERPA_ONNX_ENABLE_WEBSOCKET=OFF"
      "-DSHERPA_ONNX_ENABLE_PORTAUDIO=OFF"
      "-DSHERPA_ONNX_ENABLE_PYTHON=ON"
      "-DSHERPA_ONNX_BUILD_C_API_EXAMPLES=OFF"
      "-DSHERPA_ONNX_ENABLE_EPSEAK_NG_EXE=OFF"
      "-Donnxruntime_SOURCE_DIR=${onnxruntime.dev}"
      "-DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS"
      "-DCMAKE_INSTALL_PREFIX=./install"
      "-DSHERPA_ONNX_ENABLE_GPU=${if cudaSupport then "ON" else "OFF"}"
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

  doCheck = !cudaSupport;

  requiredSystemFeatures = lib.optionals cudaSupport [ "big-parallel" ];

  postInstall = ''
    cp -r install/bin $out
    cp -r install/include $out
    cp -r install/lib $out
    ${tree}/bin/tree $out

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
    maintainers = with maintainers; [ anpin ];
  };
}
