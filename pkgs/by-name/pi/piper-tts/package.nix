{
  lib,
  python3Packages,
  fetchFromGitHub,
  testers,
  callPackage,
  runCommand,

  # build time
  pkg-config,
  piperTtsVoices,

  # runtime
  espeak-ng,
  onnxruntime,
  ffmpeg,

  # check
  gtest,

  # extras
  withTrain ? true,
  withHTTP ? true,
  withAlignment ? true,
  withZh ? false,
  withFfplay ? false,
}@args:

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

  g2pwModel = callPackage ./g2pw-model { };
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
    # This is a strips out cmake file
    ./cmake-system-libs.patch

    # This is a stript out cmake file
    ./libpiper-cmake-system-libs.patch

    # This is a stript out cmake file
    ./libpiper-cmake-test.patch

    # Add --version/-V flag; remove once merged upstream.
    # https://github.com/OHF-Voice/piper1-gpl/pull/239
    ./add-version-flag.patch

    # Add extra models flag to give extra non-voice modesl like g2pW
    # https://github.com/OHF-Voice/piper1-gpl/pull/245
    ./add-extra-models-flag.patch

    # Add train, server, and alignment entry points
    # https://github.com/OHF-Voice/piper1-gpl/pull/246
    ./add-entry-points.patch
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
    onnxruntime.dev
  ];

  postBuild = ''
    # Build libpiper
    MODEL_DIR=$TMPDIR/piper-test-model
    mkdir -p $MODEL_DIR
    ln -s ${piperTtsVoices.voices.en_US-amy-medium}/en_US-amy-medium.onnx \
      $MODEL_DIR/model.onnx
    ln -s ${piperTtsVoices.voices.en_US-amy-medium}/en_US-amy-medium.onnx.json \
      $MODEL_DIR/model.onnx.json

    cmake -S libpiper -B libpiper-build \
      -DUCD_STATIC_LIB=${espeak-ng'.ucd-tools}/libucd.a \
      -DONNXRUNTIME_DIR=${onnxruntime} \
      -DPIPER_TEST_MODEL_DIR=$MODEL_DIR \
      -DPIPER_BUILD_TESTS=ON \
      -DCMAKE_BUILD_TYPE=Release
    cmake --build libpiper-build
  ''
  + lib.optionalString withTrain ''
    cythonize --inplace src/piper/train/vits/monotonic_align/core.pyx
  '';

  dependencies =
    with python3Packages;
    [
      python3Packages.onnxruntime
      pathvalidate
    ]
    ++ lib.optionals withTrain finalAttrs.passthru.optional-dependencies.train
    ++ lib.optionals withHTTP finalAttrs.passthru.optional-dependencies.http
    ++ lib.optionals withAlignment finalAttrs.passthru.optional-dependencies.alignment
    ++ lib.optionals withZh finalAttrs.passthru.optional-dependencies.zh;

  makeWrapperArgs = lib.optionals withFfplay [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ ffmpeg ])
  ];

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
    zh = with python3Packages; [
      g2pw
      sentence-stream
      unicode-rbnf
      torch
      requests
    ];
  };

  doCheck = true;

  checkInputs = [ gtest ];

  nativeCheckInputs = [
    python3Packages.pytest
  ];

  checkPhase = ''
    cmake --build libpiper-build --target piper_test
    ctest --test-dir libpiper-build/tests --output-on-failure
  '';

  outputs = [
    "out"
    "libpiper"
  ];

  postInstall = ''
    ln -s ${espeak-ng'}/share/espeak-ng-data $out/${python3Packages.python.sitePackages}/piper/
  ''
  + lib.optionalString withTrain ''
    train=$out/${python3Packages.python.sitePackages}/piper/train/vits
    rm -v src/piper/train/vits/monotonic_align/{Makefile,setup.py,core.c,core.pyx}
    cp -Rv src/piper/train/vits $train/
  ''
  + lib.optionalString (!withTrain) ''
    rm $out/bin/piper-train
  ''
  + lib.optionalString (!withHTTP) ''
    rm $out/bin/piper-server
  ''
  + lib.optionalString (!withAlignment) ''
    rm $out/bin/piper-alignment
  '';

  passthru = {
    inherit withTrain withHTTP withAlignment;

    tests = {
      version = testers.testVersion {
        package = finalAttrs.finalPackage;
      };

      all-flags-flipped = callPackage ./package.nix {
        withTrain = false;
        withHTTP = false;
        withAlignment = false;
        withZh = true;
        withFfplay = true;
      };

      wrapper = finalAttrs.finalPackage.withVoices (v: [ v.en_US-amy-medium ]);
      wrapper-all = finalAttrs.finalPackage.withVoices (v: builtins.attrValues v);
      voices = lib.recurseIntoAttrs piperTtsVoices.tests;

      synthesizes = lib.recurseIntoAttrs (
        lib.mapAttrs (
          key: _:
          runCommand "piper-tts-test-${key}"
            {
              nativeBuildInputs = [ (finalAttrs.finalPackage.withVoices (v: [ v.${key} ])) ];
            }
            ''
              tmpfile=$(mktemp)
              echo "Hello. world!" | piper -m ${lib.escapeShellArg key} -f "$tmpfile"

              size=$(stat -c%s "$tmpfile")
              test "$size" -gt 44 || (echo "No audio generated (only $size bytes)" && exit 1)

              mkdir $out
            ''
        ) piperTtsVoices.voices
      );
    };

    packages = piperTtsVoices;

    withVoices = callPackage ./wrapper.nix {
      piper-tts = finalAttrs.finalPackage;
      piper-tts-zh = callPackage ./package.nix (args // { withZh = true; });
      inherit g2pwModel;
    };

    updateScript = [ ./update-piper-tts.sh ];
  };

  postFixup = ''
    # Must run after fixupPhase's automatic dev-output mover
    # (multiple-outputs.sh _moveToOutput), which otherwise sweeps any
    # include/ directory it finds into $outputDev (= $out),
    # regardless of which output we placed it in.
    install -Dm755 libpiper-build/libpiper.so $libpiper/lib/libpiper.so
    cp -r libpiper/include $libpiper/include
  '';

  meta = {
    changelog = "https://github.com/OHF-Voice/piper1-gpl/releases/tag/v${finalAttrs.version}";
    description = "Fast, local neural text to speech system";
    homepage = "https://github.com/OHF-Voice/piper1-gpl";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      hexa
      WiredMic
    ];
    mainProgram = "piper";
    outputsToInstall = [ "out" ];
  };
})
