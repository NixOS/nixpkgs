{
  lib,
  stdenv,
  callPackage,
  python312Packages,
  fetchFromGitHub,
  fetchurl,
  ffmpeg-headless,
  sqlite-vec,
  frigate,
  nixosTests,
}:
let
  version = "0.16.1";

  src = fetchFromGitHub {
    name = "frigate-${version}-source";
    owner = "blakeblackshear";
    repo = "frigate";
    tag = "v${version}";
    hash = "sha256-Uhqs9n4igP9+BtIHiEiurjvKfo2prIXnnVXqyPDbzQ8=";
  };

  frigate-web = callPackage ./web.nix {
    inherit version src;
  };

  python = python312Packages.python.override {
    packageOverrides = self: super: {
      joserfc = super.joserfc.overridePythonAttrs (oldAttrs: {
        version = "1.1.0";
        src = fetchFromGitHub {
          owner = "authlib";
          repo = "joserfc";
          tag = version;
          hash = "sha256-95xtUzzIxxvDtpHX/5uCHnTQTB8Fc08DZGUOR/SdKLs=";
        };
      });
    };
  };
  python3Packages = python.pkgs;

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

  # SSDLite MobileNetV2 model from TensorFlow
  ssdlite_mobilenet_v2_tensorflow = fetchurl {
    url = "http://download.tensorflow.org/models/object_detection/ssdlite_mobilenet_v2_coco_2018_05_09.tar.gz";
    hash = "sha256-VCRFzOg02/u33xmRQl1HXoWi1+xoxgpPJiuxiqwQyLI=";
  };

  # Convert SSDLite MobileNetV2 model from TensorFlow using modern OpenVINO API
  openvino_model = stdenv.mkDerivation {
    pname = "frigate-openvino-model";
    inherit version;

    src = ssdlite_mobilenet_v2_tensorflow;

    nativeBuildInputs = [
      python3Packages.python
      python3Packages.openvino
    ];

    buildPhase = ''
      # Extract TensorFlow model
      mkdir -p models
      cd models
      tar -xzf $src
      cd ..

      # Create conversion script using modern OpenVINO API (simplified)
      cat > convert_model.py << 'EOF'
      import openvino as ov
      import numpy as np
      from openvino import opset8 as ops
      from openvino import Model, Type

      model_path = "./models/ssdlite_mobilenet_v2_coco_2018_05_09/frozen_inference_graph.pb"

      # Convert TF model to OpenVINO IR
      ov_model = ov.convert_model(input_model=model_path, input=[1, 300, 300, 3])

      # Deterministic selection by shapes for this known model
      outs = list(ov_model.outputs)
      boxes = [o for o in outs if list(o.get_shape())[-1] == 4][0]
      twod = [o for o in outs if len(list(o.get_shape())) == 2][:2]
      scores, classes = twod[0], twod[1]

      # Fixed N for this model (TF SSDLite MobileNet V2 COCO uses max_total_detections=100)
      N = 100

      # Reshape to [1, N, X]
      pat_1n4 = ops.constant(np.array([1, N, 4], dtype=np.int64))
      pat_1n1 = ops.constant(np.array([1, N, 1], dtype=np.int64))

      boxes_1n4 = ops.reshape(boxes, pat_1n4, False)
      scores_1n1 = ops.reshape(scores, pat_1n1, False)
      classes_1n1 = ops.reshape(classes, pat_1n1, False)

      # Ensure f32 for concat
      boxes_1n4 = ops.convert(boxes_1n4, Type.f32)
      scores_1n1 = ops.convert(scores_1n1, Type.f32)
      classes_1n1 = ops.convert(classes_1n1, Type.f32)

      # Reorder TF boxes [ymin, xmin, ymax, xmax] -> [xmin, ymin, xmax, ymax]
      # Use Gather with explicit i64 indices and axis=2
      reorder_idx = ops.constant(np.array([1, 0, 3, 2], dtype=np.int64))
      axis2 = ops.constant(np.array(2, dtype=np.int64))
      boxes_xyxy = ops.gather(boxes_1n4, reorder_idx, axis2)

      # image_id = 0 for all detections
      image_ids = ops.constant(np.zeros((1, N, 1), dtype=np.float32))

      # Build [1, N, 7] => [image_id, label, confidence, x_min, y_min, x_max, y_max]
      det_1n7 = ops.concat([image_ids, classes_1n1, scores_1n1, boxes_xyxy], axis=2)

      # Reshape to [1, 1, N, 7] and expose as single output
      det_11n7 = ops.reshape(det_1n7, ops.constant(np.array([1, 1, N, 7], dtype=np.int64)), False)
      det_11n7.set_friendly_name("DetectionOutput")
      ov_model = Model([det_11n7], ov_model.get_parameters(), "ssd_mobilenet_v2_detection")

      # Validate Frigate SSD expectations: 1 output; shape [1,1,N,7]
      outs = list(ov_model.outputs)
      shape0 = list(outs[0].get_shape())
      if not (len(outs) == 1 and len(shape0) >= 4 and shape0[0] == 1 and shape0[1] == 1 and shape0[3] == 7):
        raise RuntimeError(f"Frigate SSD validation failed. outputs={len(outs)}, shape={shape0}")

      # Save model (FP16 weights)
      ov.save_model(ov_model, "./models/ssdlite_mobilenet_v2.xml", compress_to_fp16=True)

      # Note: runtime smoke test omitted in build sandbox to avoid plugin/CPU env issues
      EOF

      # Run the conversion
      python3 convert_model.py
    '';

    installPhase = ''
      mkdir -p $out
      cp models/ssdlite_mobilenet_v2.xml $out/
      cp models/ssdlite_mobilenet_v2.bin $out/
    '';

    meta = {
      description = "OpenVINO model files for Frigate object detection (SSD MobileNet v2)";
    };
  };

  coco_91cl_bkgr = fetchurl {
    url = "https://github.com/openvinotoolkit/open_model_zoo/raw/master/data/dataset_classes/coco_91cl_bkgr.txt";
    hash = "sha256-5Cj2vEiWR8Z9d2xBmVoLZuNRv4UOuxHSGZQWTJorXUQ=";
  };
in
python3Packages.buildPythonApplication rec {
  pname = "frigate";
  inherit version;
  format = "other";

  inherit src;

  patches = [
    ./constants.patch
    ./ffmpeg.patch
  ];

  postPatch = ''
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

    # provide default paths for models and maps that are shipped with frigate
    substituteInPlace frigate/config/config.py \
      --replace-fail "/cpu_model.tflite" "${tflite_cpu_model}" \
      --replace-fail "/edgetpu_model.tflite" "${tflite_edgetpu_model}"

    substituteInPlace frigate/detectors/detector_config.py \
      --replace-fail "/labelmap.txt" "${placeholder "out"}/share/frigate/labelmap.txt"

    substituteInPlace frigate/events/audio.py \
      --replace-fail "/cpu_audio_model.tflite" "${placeholder "out"}/share/frigate/cpu_audio_model.tflite" \
      --replace-fail "/audio-labelmap.txt" "${placeholder "out"}/share/frigate/audio-labelmap.txt"
  '';

  dontBuild = true;

  dependencies = with python3Packages; [
    # docker/main/requirements.txt
    scikit-build
    # docker/main/requirements-wheel.txt
    aiofiles
    aiohttp
    appdirs
    argcomplete
    contextlib2
    click
    distlib
    fastapi
    filelock
    future
    importlib-metadata
    importlib-resources
    google-generativeai
    joserfc
    levenshtein
    markupsafe
    netaddr
    netifaces
    norfair
    numpy
    ollama
    onnxruntime
    onvif-zeep-async
    openai
    opencv4
    openvino
    paho-mqtt
    pandas
    pathvalidate
    peewee
    peewee-migrate
    prometheus-client
    psutil
    py3nvml
    pyclipper
    pydantic
    python-multipart
    pytz
    py-vapid
    pywebpush
    pyzmq
    requests
    ruamel-yaml
    scipy
    setproctitle
    shapely
    slowapi
    starlette
    starlette-context
    tensorflow-bin
    titlecase
    transformers
    tzlocal
    unidecode
    uvicorn
    verboselogs
    virtualenv
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

    cp --no-preserve=mode ${openvino_model}/ssdlite_mobilenet_v2.xml $out/share/frigate/
    cp --no-preserve=mode ${openvino_model}/ssdlite_mobilenet_v2.bin $out/share/frigate/

    runHook postInstall
  '';

  nativeCheckInputs = with python3Packages; [
    ffmpeg-headless
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
    pythonPath = (python3Packages.makePythonPath dependencies) + ":${frigate}/${python.sitePackages}";
    tests = {
      inherit (nixosTests) frigate;
    };
  };

  meta = with lib; {
    changelog = "https://github.com/blakeblackshear/frigate/releases/tag/${src.tag}";
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
