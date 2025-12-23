{
  lib,
  python3Packages,
  fetchFromGitHub,

  # build time
  pkg-config,

  # runtime
  espeak-ng,

  # extras
  withTrain ? true,
  withHTTP ? true,
  withAlignment ? true,
}:

let
  # https://github.com/OHF-Voice/piper1-gpl/blob/v1.3.0/CMakeLists.txt#L33-L40
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
  version = "1.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "piper1-gpl";
    tag = "v${version}";
    hash = "sha256-WDMIXsbUzJ5XnA/KUVUPQKZzkqrXagzAOrhFtLR4fGk=";
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

  dependencies = [
    python3Packages.onnxruntime
  ]
  ++ lib.optionals withTrain optional-dependencies.train
  ++ lib.optionals withHTTP optional-dependencies.http
  ++ lib.optionals withAlignment optional-dependencies.alignment;

  optional-dependencies = {
    train =
      with python3Packages;
      [
        jsonargparse
        librosa
        lightning
        pathvalidate
        pysilero-vad
        tensorboard
        tensorboardx
        torch
      ]
      ++ jsonargparse.optional-dependencies.signatures;
    http = with python3Packages; [
      flask
    ];
    alignment = with python3Packages; [
      onnx
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

  meta = {
    changelog = "https://github.com/OHF-Voice/piper1-gpl/releases/tag/v${version}";
    description = "Fast, local neural text to speech system";
    homepage = "https://github.com/OHF-Voice/piper1-gpl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "piper";
  };
}
