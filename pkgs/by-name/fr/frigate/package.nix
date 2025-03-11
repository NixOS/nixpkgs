{
  lib,
  stdenv,
  callPackage,
  python312,
  fetchFromGitHub,
  fetchurl,
  rocmPackages,
  sqlite-vec,
  frigate,
  nixosTests,
}:

let
  version = "0.15.0";

  src = fetchFromGitHub {
    name = "frigate-${version}-source";
    owner = "blakeblackshear";
    repo = "frigate";
    tag = "v${version}";
    hash = "sha256-qgiVE5UUjxRLya0mD2vfKdzdTdy5ThYOrHAGoFQ9PWA=";
  };

  frigate-web = callPackage ./web.nix {
    inherit version src;
  };

  python = python312;

  # Tensorflow audio model
  # https://github.com/blakeblackshear/frigate/blob/v0.15.0/docker/main/Dockerfile#L125
  tflite_audio_model = fetchurl {
    url = "https://www.kaggle.com/api/v1/models/google/yamnet/tfLite/classification-tflite/1/download";
    hash = "sha256-G5cbITJ2AnOl+49dxQToZ4OyeFO7MTXVVa4G8eHjZfM=";
  };

  # Tensorflow Lite models
  # https://github.com/blakeblackshear/frigate/blob/v0.15.0/docker/main/Dockerfile#L115-L117
  tflite_cpu_model = fetchurl {
    url = "https://github.com/google-coral/test_data/raw/release-frogfish/ssdlite_mobiledet_coco_qat_postprocess.tflite";
    hash = "sha256-kLszpjTgQZFMwYGapd+ZgY5sOWxNLblSwP16nP/Eck8=";
  };
  tflite_edgetpu_model = fetchurl {
    url = "https://github.com/google-coral/test_data/raw/release-frogfish/ssdlite_mobiledet_coco_qat_postprocess_edgetpu.tflite";
    hash = "sha256-Siviu7YU5XbVbcuRT6UnUr8PE0EVEnENNV2X+qGzVkE=";
  };

  # TODO: OpenVino model
  # https://github.com/blakeblackshear/frigate/blob/v0.15.0/docker/main/Dockerfile#L64-L77
  # https://github.com/blakeblackshear/frigate/blob/v0.15.0/docker/main/Dockerfile#L120-L123
  # Convert https://www.kaggle.com/models/tensorflow/ssdlite-mobilenet-v2 with https://github.com/blakeblackshear/frigate/blob/v0.15.0/docker/main/build_ov_model.py into OpenVino IR format
  coco_91cl_bkgr = fetchurl {
    url = "https://github.com/openvinotoolkit/open_model_zoo/raw/master/data/dataset_classes/coco_91cl_bkgr.txt";
    hash = "sha256-5Cj2vEiWR8Z9d2xBmVoLZuNRv4UOuxHSGZQWTJorXUQ=";
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "frigate";
  inherit version;
  format = "other";

  inherit src;

  patches = [ ./constants.patch ];

  postPatch =
    ''
      echo 'VERSION = "${version}"' > frigate/version.py

      substituteInPlace \
        frigate/app.py \
        frigate/test/test_{http,storage}.py \
        frigate/test/http_api/base_http_test.py \
        --replace-fail "Router(migrate_db)" 'Router(migrate_db, "${placeholder "out"}/share/frigate/migrations")'

      substituteInPlace frigate/const.py \
        --replace-fail "/opt/frigate" "${placeholder "out"}/${python.sitePackages}" \
        --replace-fail "/media/frigate" "/var/lib/frigate" \
        --replace-fail "/tmp/cache" "/var/cache/frigate" \
        --replace-fail "/config" "/var/lib/frigate" \
        --replace-fail "{CONFIG_DIR}/model_cache" "/var/cache/frigate/model_cache"

      substituteInPlace frigate/comms/{config,embeddings}_updater.py frigate/comms/{zmq_proxy,inter_process}.py \
        --replace-fail "ipc:///tmp/cache" "ipc:///run/frigate"

      substituteInPlace frigate/db/sqlitevecq.py \
        --replace-fail "/usr/local/lib/vec0" "${lib.getLib sqlite-vec}/lib/vec0${stdenv.hostPlatform.extensions.sharedLibrary}"

    ''
    + lib.optionalString (stdenv.hostPlatform == "x86_64-linux") ''
      substituteInPlace frigate/detectors/plugins/rocm.py \
        --replace-fail "/opt/rocm/bin/rocminfo" "rocminfo" \
        --replace-fail "/opt/rocm/lib" "${rocmPackages.clr}/lib"

    ''
    + ''
      # provide default paths for models and maps that are shipped with frigate
      substituteInPlace frigate/config/config.py \
        --replace-fail "/cpu_model.tflite" "${tflite_cpu_model}" \
        --replace-fail "/edgetpu_model.tflite" "${tflite_edgetpu_model}"

      substituteInPlace frigate/detectors/detector_config.py \
        --replace-fail "/labelmap.txt" "${placeholder "out"}/share/frigate/labelmap.txt"

      substituteInPlace frigate/events/audio.py \
        --replace-fail "/cpu_audio_model.tflite" "${placeholder "out"}/share/frigate/cpu_audio_model.tflite" \
        --replace-fail "/audio-labelmap.txt" "${placeholder "out"}/share/frigate/audio-labelmap.txt"

      # work around onvif-zeep idiosyncrasy
      substituteInPlace frigate/ptz/onvif.py \
        --replace-fail dist-packages site-packages
    '';

  dontBuild = true;

  dependencies = with python.pkgs; [
    # docker/main/requirements.txt
    scikit-build
    # docker/main/requirements-wheel.txt
    aiohttp
    click
    fastapi
    google-generativeai
    imutils
    joserfc
    markupsafe
    norfair
    numpy
    ollama
    onnxruntime
    onvif-zeep
    openai
    opencv4
    openvino
    paho-mqtt
    pandas
    pathvalidate
    peewee
    peewee-migrate
    psutil
    py3nvml
    pydantic
    pytz
    py-vapid
    pywebpush
    pyzmq
    requests
    ruamel-yaml
    scipy
    setproctitle
    slowapi
    starlette
    starlette-context
    tensorflow-bin
    transformers
    tzlocal
    unidecode
    uvicorn
    ws4py
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}/frigate
    cp -R frigate/* $out/${python.sitePackages}/frigate/

    mkdir -p $out/share/frigate
    cp -R {migrations,labelmap.txt,audio-labelmap.txt} $out/share/frigate/

    tar --extract --gzip --file ${tflite_audio_model}
    cp --no-preserve=mode ./1.tflite $out/share/frigate/cpu_audio_model.tflite

    cp --no-preserve=mode ${coco_91cl_bkgr} $out/share/frigate/coco_91cl_bkgr.txt
    sed -i 's/truck/car/g' $out/share/frigate/coco_91cl_bkgr.txt

    runHook postInstall
  '';

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
  ];

  # interpreter crash in onnxruntime on aarch64-linux
  doCheck = !(stdenv.hostPlatform.system == "aarch64-linux");

  preCheck = ''
    # Unavailable in the build sandbox
    substituteInPlace frigate/const.py \
      --replace-fail "/var/lib/frigate" "$TMPDIR/" \
      --replace-fail "/var/cache/frigate" "$TMPDIR"
  '';

  disabledTests = [
    # Test needs network access
    "test_plus_labelmap"
  ];

  passthru = {
    web = frigate-web;
    inherit python;
    pythonPath = (python.pkgs.makePythonPath dependencies) + ":${frigate}/${python.sitePackages}";
    tests = {
      inherit (nixosTests) frigate;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/blakeblackshear/frigate/releases/tag/v${version}";
    description = "NVR with realtime local object detection for IP cameras";
    longDescription = ''
      A complete and local NVR designed for Home Assistant with AI
      object detection. Uses OpenCV and Tensorflow to perform realtime
      object detection locally for IP cameras.
    '';
    homepage = "https://github.com/blakeblackshear/frigate";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
