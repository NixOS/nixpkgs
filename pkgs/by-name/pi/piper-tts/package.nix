{
  lib,
  python3Packages,
  fetchFromGitHub,

  # build time
  pkg-config,

  # runtime
  espeak-ng,

  # extras
  withAlignment ? true,
  withHTTP ? true,
  withJapanese ? true,
  withTrain ? true,
}:

let
  # https://github.com/OHF-Voice/piper1-gpl/blob/v1.7.0/CMakeLists.txt#L33-L40
  espeak-ng' = espeak-ng.override {
    asyncSupport = false;
    klattSupport = false;
    mbrolaSupport = false;
    pcaudiolibSupport = false;
    sonicSupport = false;
    speechPlayerSupport = false;
  };
in

python3Packages.buildPythonApplication rec {
  pname = "piper-tts";
  version = "1.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "piper1-gpl";
    tag = "v${version}";
    hash = "sha256-oQhDFhB2GXlAdxW1K7BM7RJkzihAwyoB6QbOpaMUVHM=";
  };

  patches = [
    # https://github.com/OHF-Voice/piper1-gpl/pull/17
    ./cmake-system-libs.patch
  ];

  build-system =
    with python3Packages;
    [
      cmake
      ninja
      scikit-build
      setuptools
    ]
    ++ lib.optionals withTrain [
      cython
      distutils
    ];

  nativeBuildInputs = [
    pkg-config
  ];

  dontUseCmakeConfigure = true;

  env.CMAKE_ARGS = toString [
    (lib.cmakeFeature "UCD_STATIC_LIB" "${espeak-ng'.ucd-tools}/libucd.a")
  ];

  buildInputs = [
    espeak-ng'
  ];

  postBuild = lib.optionalString withTrain ''
    cythonize --inplace src/piper/train/vits/monotonic_align/core.pyx
  '';

  dependencies =
    with python3Packages;
    [
      onnxruntime
      pathvalidate
    ]
    ++ lib.optionals withAlignment optional-dependencies.alignment
    ++ lib.optionals withHTTP optional-dependencies.http
    ++ lib.optionals withJapanese optional-dependencies.ja
    ++ lib.optionals withTrain optional-dependencies.train;

  optional-dependencies = {
    alignment = with python3Packages; [
      onnx
    ];
    http = with python3Packages; [
      flask
    ];
    ja = with python3Packages; [
      pyopenjtalk-plus
    ];
    train =
      with python3Packages;
      [
        jsonargparse
        librosa
        lightning
        onnx
        pysilero-vad
        tensorboard
        tensorboardx
        torch
      ]
      ++ jsonargparse.optional-dependencies.signatures;
    zh = with python3Packages; [
      # g2pw # not packaged
      transformers
      sentence-stream
      unicode-rbnf
    ];
  };

  postInstall = ''
    ln -s ${espeak-ng'}/share/espeak-ng-data $out/${python3Packages.python.sitePackages}/piper/
  ''
  + lib.optionalString withTrain ''
    train=$out/${python3Packages.python.sitePackages}/piper/train/vits
    rm -v src/piper/train/vits/monotonic_align/{Makefile,setup.py,core.c,core.pyx}
    cp -Rv src/piper/train/vits $train/
  '';

  pythonImportsCheck = [
    "piper"
    "piper.tashkeel"
    "piper.hebrew"
    "piper.train"
    "piper.train.vits"
  ];

  meta = {
    changelog = "https://github.com/OHF-Voice/piper1-gpl/releases/tag/v${version}";
    description = "Fast, local neural text to speech system";
    homepage = "https://github.com/OHF-Voice/piper1-gpl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "piper";
  };
}
