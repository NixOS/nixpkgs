{
  addDriverRunpath,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  ffmpeg-headless,
  frigate,
  lib,
  nixosTests,
  python313Packages,
  replaceVars,
  sqlite-vec,
  stdenv,
}:

let
  python3Packages = python313Packages.overrideScope (
    self: super: {
      # transformers 4.* is not compatible with the latest tokenizers
      tokenizers = super.tokenizers.overridePythonAttrs (
        oldAttrs:
        let
          version = "0.22.1";
          src = fetchFromGitHub {
            owner = "huggingface";
            repo = "tokenizers";
            tag = "v${version}";
            hash = "sha256-1ijP16Fw/dRgNXXX9qEymXNaamZmlNFqbfZee82Qz6c=";
          };
          sourceRoot = "${src.name}/bindings/python";
        in
        {
          inherit version src sourceRoot;

          cargoDeps = rustPlatform.fetchCargoVendor {
            inherit (oldAttrs) pname;
            inherit version src sourceRoot;
            hash = "sha256-CKbnFtwsEtJ11Wnn8JFpHd7lnUzQMTwJ1DmmB44qciM=";
          };
        }
      );

      huggingface-hub = super.huggingface-hub_0;
      transformers = super.transformers_4;
    }
  );

  inherit (python3Packages) python;
in
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "frigate";
  version = "0.18.0-rc1";
  pyproject = false;

  src = fetchFromGitHub {
    name = "frigate-${finalAttrs.version}-source";
    owner = "blakeblackshear";
    repo = "frigate";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nMlaExkofbUmzRy3nr42Wy8r+yHcgHiyAsdfq/XdF0Q=";
  };

  patches = [
    # Always lookup ffmpeg from config setting
    ./ffmpeg.patch

    # Adjust libteflon.so location
    (replaceVars ./libteflon-driverlink-path.patch {
      inherit (addDriverRunpath) driverLink;
    })

    # Disable failing optimization in onnxruntime
    # https://github.com/microsoft/onnxruntime/issues/26717
    # https://github.com/microsoft/onnxruntime/pull/29196
    ./onnxruntime-compat.patch

    # Reuse EXPORT_DIR in tests
    ./fix-tests-media-auth-paths.patch

    # Fix more granular dtype resolution in Pandas 3.0
    ./pandas3-compat.patch

    # Various fixes for newer library packages, migrates to
    # - FastAPI lifespan,
    # - native tz-aware objects,
    # - Pydantic TypeAdapter
    # https://github.com/blakeblackshear/frigate/pull/23641
    ./pr23641.patch
  ];

  postPatch = ''
    echo 'VERSION = "${finalAttrs.version}"' > frigate/version.py

    substituteInPlace \
      frigate/app.py \
      frigate/test/test_storage.py \
      frigate/test/http_api/base_http_test.py \
      --replace-fail "Router(migrate_db)" 'Router(migrate_db, "${placeholder "out"}/share/frigate/migrations")'

    substituteInPlace frigate/const.py \
      --replace-fail "/opt/frigate" "${placeholder "out"}/${python.sitePackages}" \
      --replace-fail "/media/frigate" "/var/lib/frigate" \
      --replace-fail "/tmp/cache" "/var/cache/frigate" \
      --replace-fail "/config" "/var/lib/frigate" \
      --replace-fail "{CONFIG_DIR}/model_cache" "/var/cache/frigate/model_cache"

    substituteInPlace \
      frigate/comms/config_updater.py \
      frigate/comms/embeddings_updater.py \
      frigate/comms/inter_process.py \
      frigate/comms/object_detector_signaler.py \
      frigate/comms/zmq_proxy.py \
      frigate/detectors/plugins/zmq_ipc.py \
      --replace-fail "ipc:///tmp/cache" "ipc:///run/frigate"

    substituteInPlace frigate/db/sqlitevecq.py \
      --replace-fail "/usr/local/lib/vec0" "${lib.getLib sqlite-vec}/lib/vec0${stdenv.hostPlatform.extensions.sharedLibrary}"

    # hardcoded default models shipped with Frigate
    substituteInPlace frigate/config/config.py \
      --replace-fail "/cpu_model.tflite" "${frigate.models.tflite.ssdlite_mobiledet_coco_qat_postprocess}" \
      --replace-fail "/edgetpu_model.tflite" "${frigate.models.edgetpu.ssdlite_mobiledet_coco_qat_postprocess}" \
      --replace-fail "/openvino-model/ssdlite_mobilenet_v2.xml" "${frigate.models.openvino.ssdlite_mobilenet_v2_coco.model}" \
      --replace-fail "/openvino-model/coco_91cl_bkgr.txt" "${frigate.models.openvino.ssdlite_mobilenet_v2_coco.labelmap}"

    substituteInPlace frigate/detectors/detector_config.py \
      --replace-fail "/labelmap.txt" "${placeholder "out"}/share/frigate/labelmap.txt"

    substituteInPlace frigate/events/audio.py \
      --replace-fail "/cpu_audio_model.tflite" "${frigate.models.tflite.yamnet_classification_v1.model}" \
      --replace-fail "/audio-labelmap.txt" "${placeholder "out"}/share/frigate/audio-labelmap.txt"
  '';

  dontBuild = true;

  dependencies =
    with python3Packages;
    [
      # docker/main/requirements-wheel.txt
      ai-edge-litert
      aiofiles
      aiohttp
      appdirs
      argcomplete
      click
      contextlib2
      cryptography
      distlib
      fastapi
      faster-whisper
      filelock
      google-genai
      httpx
      importlib-metadata
      importlib-resources
      joserfc
      keras # via tensorflow.keras
      librosa
      markupsafe
      memray
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
      py-vapid
      pywebpush
      pyzmq
      rapidfuzz
      requests
      ruamel-yaml
      scipy
      setproctitle
      shapely
      sherpa-onnx
      slowapi
      soundfile
      starlette
      starlette-context
      tensorflow
      titlecase
      transformers
      tzlocal
      unidecode
      uvicorn
      verboselogs
      virtualenv
      ws4py
    ]
    ++ httpx.optional-dependencies.http2;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}/frigate
    cp -R frigate/* $out/${python.sitePackages}/frigate/

    mkdir -p $out/share/frigate
    cp -R {migrations,labelmap.txt,audio-labelmap.txt} $out/share/frigate/

    ln -s ${frigate.models.tflite.yamnet_classification_v1.model} $out/share/frigate/cpu_audio_model.tflite

    runHook postInstall
  '';

  nativeCheckInputs = with python3Packages; [
    ffmpeg-headless
    pytestCheckHook
  ];

  preCheck = ''
    # FHS paths are unreachable in the build sandbox
    substituteInPlace frigate/const.py \
      --replace-fail "/var/lib/frigate" "$TMPDIR" \
      --replace-fail "/var/cache/frigate" "$TMPDIR"
  '';

  disabledTests = [
    # Test needs network access
    "test_plus_labelmap"
    # Expects go2rtc on :1984
    "test_admin_can_access_any_stream"
    "test_restricted_role_can_access_allowed_camera"
    "test_stream_alias_allowed_for_owning_camera"
    "test_unconfigured_role_can_access_any_stream"
  ];

  passthru = {
    inherit python python3Packages;
    pythonPath =
      (python3Packages.makePythonPath finalAttrs.finalPackage.dependencies)
      + ":${frigate}/${python.sitePackages}";
    web = callPackage ./web.nix {
      inherit (finalAttrs) version src;
    };
    models = {
      # Google Coral Accelerators as Tensorflow Delegate
      # https://docs.frigate.video/configuration/object_detectors/#edge-tpu-detector
      edgetpu = lib.recurseIntoAttrs (
        lib.packagesFromDirectoryRecursive {
          inherit callPackage;
          directory = ./models/edgetpu;
        }
      );
      # Intel OpenVINO for CPU/GPU/NPU
      # https://docs.frigate.video/configuration/object_detectors/#openvino-detector
      openvino = lib.recurseIntoAttrs (
        lib.packagesFromDirectoryRecursive {
          inherit callPackage;
          directory = ./models/openvino;
        }
      );
      # Tensorflow Lite CPU models
      # https://docs.frigate.video/configuration/object_detectors/#cpu-detector-not-recommended
      # https://docs.frigate.video/configuration/audio_detectors/
      tflite = lib.recurseIntoAttrs (
        lib.packagesFromDirectoryRecursive {
          inherit callPackage;
          directory = ./models/tflite;
        }
      );
    };
    tests = {
      inherit (nixosTests) frigate;
    };
  };

  meta = {
    changelog = "https://github.com/blakeblackshear/frigate/releases/tag/${finalAttrs.src.tag}";
    description = "NVR with realtime local object detection for IP cameras";
    longDescription = ''
      A complete and local NVR designed for Home Assistant with AI
      object detection. Uses OpenCV and Tensorflow to perform realtime
      object detection locally for IP cameras.
    '';
    homepage = "https://github.com/blakeblackshear/frigate";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hexa ];
  };
})
