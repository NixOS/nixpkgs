{ lib
, callPackage
, python312
, fetchFromGitHub
, fetchurl
, frigate
, nixosTests
}:

let
  version = "0.14.1";

  src = fetchFromGitHub {
    name = "frigate-${version}-source";
    owner = "blakeblackshear";
    repo = "frigate";
    rev = "refs/tags/v${version}";
    hash = "sha256-PfUlo9ua4SVcQJTfmSVoEXHH1MUJ8A/w3kJHFpEzll8=";
  };

  frigate-web = callPackage ./web.nix {
    inherit version src;
  };

  python = python312.override {
    self = python;
    packageOverrides = self: super: {
      paho-mqtt = super.paho-mqtt_2;
    };
  };

  # Tensorflow Lite models
  # https://github.com/blakeblackshear/frigate/blob/v0.13.0/docker/main/Dockerfile#L96-L97
  tflite_cpu_model = fetchurl {
    url = "https://github.com/google-coral/test_data/raw/release-frogfish/ssdlite_mobiledet_coco_qat_postprocess.tflite";
    hash = "sha256-kLszpjTgQZFMwYGapd+ZgY5sOWxNLblSwP16nP/Eck8=";
  };
  tflite_edgetpu_model = fetchurl {
    url = "https://github.com/google-coral/test_data/raw/release-frogfish/ssdlite_mobiledet_coco_qat_postprocess_edgetpu.tflite";
    hash = "sha256-Siviu7YU5XbVbcuRT6UnUr8PE0EVEnENNV2X+qGzVkE=";
  };

  # OpenVino models
  # https://github.com/blakeblackshear/frigate/blob/v0.13.0/docker/main/Dockerfile#L101
  openvino_model = fetchurl {
    url = "https://github.com/openvinotoolkit/open_model_zoo/raw/master/data/dataset_classes/coco_91cl_bkgr.txt";
    hash = "sha256-5Cj2vEiWR8Z9d2xBmVoLZuNRv4UOuxHSGZQWTJorXUQ=";
  };
in
python.pkgs.buildPythonApplication rec {
  pname = "frigate";
  inherit version;
  format = "other";

  inherit src;

  postPatch = ''
    echo 'VERSION = "${version}"' > frigate/version.py

    substituteInPlace frigate/app.py \
      --replace-fail "Router(migrate_db)" 'Router(migrate_db, "${placeholder "out"}/share/frigate/migrations")'

    substituteInPlace frigate/const.py \
      --replace-fail "/media/frigate" "/var/lib/frigate" \
      --replace-fail "/tmp/cache" "/var/cache/frigate" \
      --replace-fail "/config" "/var/lib/frigate" \
      --replace-fail "{CONFIG_DIR}/model_cache" "/var/cache/frigate/model_cache"

    substituteInPlace frigate/comms/{config,detections,events}_updater.py frigate/comms/inter_process.py \
      --replace-fail "ipc:///tmp/cache" "ipc:///run/frigate"

    substituteInPlace frigate/detectors/detector_config.py \
      --replace-fail "/labelmap.txt" "${placeholder "out"}/share/frigate/labelmap.txt"

    # work around onvif-zeep idiosyncrasy
    substituteInPlace frigate/ptz/onvif.py \
      --replace-fail dist-packages site-packages

    substituteInPlace frigate/config.py \
      --replace-fail "/cpu_model.tflite" "${tflite_cpu_model}" \
      --replace-fail "/edgetpu_model.tflite" "${tflite_edgetpu_model}"

    substituteInPlace frigate/test/test_config.py \
      --replace-fail "(MODEL_CACHE_DIR" "('/build/model_cache'" \
      --replace-fail "/config/model_cache" "/build/model_cache"
  '';

  dontBuild = true;

  propagatedBuildInputs = with python.pkgs; [
    # docker/main/requirements.txt
    scikit-build
    # docker/main/requirements-wheel.txt
    click
    distutils
    flask
    flask-limiter
    imutils
    joserfc
    markupsafe
    matplotlib
    norfair
    numpy
    onvif-zeep
    opencv4
    openvino
    pandas
    paho-mqtt
    peewee
    peewee-migrate
    psutil
    py3nvml
    pydantic
    pytz
    pyyaml
    pyzmq
    requests
    ruamel-yaml
    scipy
    setproctitle
    tensorflow-bin
    tzlocal
    unidecode
    ws4py
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/${python.sitePackages}/frigate
    cp -R frigate/* $out/${python.sitePackages}/frigate/

    mkdir -p $out/share/frigate
    cp -R {migrations,labelmap.txt} $out/share/frigate/

    cp --no-preserve=mode ${openvino_model} $out/share/frigate/coco_91cl_bkgr.txt
    sed -i 's/truck/car/g' $out/share/frigate/coco_91cl_bkgr.txt

    runHook postInstall
  '';

  nativeCheckInputs = with python.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    # Test needs network access
    "test_plus_labelmap"
  ];

  passthru = {
    web = frigate-web;
    inherit python;
    pythonPath =(python.pkgs.makePythonPath propagatedBuildInputs) + ":${frigate}/${python.sitePackages}";
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
