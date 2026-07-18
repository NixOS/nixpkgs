{
  lib,
  python3Packages,
  fetchFromGitHub,
  testers,
  nix-update-script,

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

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "piper-tts";
  version = "1.6.0";
  pyproject = true;

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "OHF-Voice";
    repo = "piper1-gpl";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QY9/KDLtamGMbAp8FXvN8emreL8leXJiL0PbgOTNjCU=";
  };

  patches = [
    # https://github.com/OHF-Voice/piper1-gpl/pull/17
    ./cmake-system-libs.patch

    # Add --version/-V flag; remove once merged upstream.
    # https://github.com/OHF-Voice/piper1-gpl/pull/239
    ./add-version-flag.patch
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
    ++ lib.optionals withTrain finalAttrs.passthru.optional-dependencies.train
    ++ lib.optionals withHTTP finalAttrs.passthru.optional-dependencies.http
    ++ lib.optionals withAlignment finalAttrs.passthru.optional-dependencies.alignment;

  optional-dependencies = {
    train =
      with python3Packages;
      [
        jsonargparse
        librosa
        lightning
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

  doCheck = true;

  nativeCheckInputs = [
    python3Packages.pytest
  ];

  checkPhase = ''
    export NUMBA_CACHE_DIR=$(mktemp -d)/numba-cache
    pytest tests
  '';

  postInstall = ''
    ln -s ${espeak-ng'}/share/espeak-ng-data $out/${python3Packages.python.sitePackages}/piper/
  ''
  + lib.optionalString withTrain ''
    train=$out/${python3Packages.python.sitePackages}/piper/train/vits
    rm -v src/piper/train/vits/monotonic_align/{Makefile,setup.py,core.c,core.pyx}
    cp -Rv src/piper/train/vits $train/
  '';

  passthru = {
    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://github.com/OHF-Voice/piper1-gpl/releases/tag/v${finalAttrs.version}";
    description = "Fast, local neural text to speech system";
    homepage = "https://github.com/OHF-Voice/piper1-gpl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ hexa ];
    mainProgram = "piper";
  };
})
