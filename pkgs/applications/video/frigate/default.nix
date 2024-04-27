{ lib
, callPackage
, python3
, fetchFromGitHub
, fetchurl
, fetchpatch2
, frigate
, nixosTests
}:

let
  version = "0.13.2";

  src = fetchFromGitHub {
    #name = "frigate-${version}-source";
    owner = "blakeblackshear";
    repo = "frigate";
    rev = "refs/tags/v${version}";
    hash = "sha256-NVT7yaJkVA7b7GL0S0fHjNneBzhjCru56qY1Q4sTVcE=";
  };

  frigate-web = callPackage ./web.nix {
    inherit version src;
  };

  python = python3.override {
    packageOverrides = self: super: {
      pydantic = super.pydantic_1;

      versioningit = super.versioningit.overridePythonAttrs {
        # checkPhase requires pydantic>=2
        doCheck = false;
      };
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

  patches = [
    (fetchpatch2 {
      name = "frigate-flask3.0-compat.patch";
      url = "https://github.com/blakeblackshear/frigate/commit/56bdacc1c661eff8a323e033520e75e2ba0a3842.patch";
      hash = "sha256-s/goUJxIbjq/woCEOEZECdcZoJDoWc1eM63sd60cxeY=";
    })
    (fetchpatch2 {
      # https://github.com/blakeblackshear/frigate/pull/10967
      name = "frigate-wsdl-path.patch";
      url = "https://github.com/blakeblackshear/frigate/commit/b65656fa8733c1c2f3d944f716d2e9493ae7c99f.patch";
      hash = "sha256-taPWFV4PldBGUKAwFMKag4W/3TLMSGdKLYG8bj1Y5mU=";
    })
  ];

  postPatch = ''
    echo 'VERSION = "${version}"' > frigate/version.py

    substituteInPlace frigate/app.py \
      --replace "Router(migrate_db)" 'Router(migrate_db, "${placeholder "out"}/share/frigate/migrations")'

    substituteInPlace frigate/const.py \
      --replace "/media/frigate" "/var/lib/frigate" \
      --replace "/tmp/cache" "/var/cache/frigate" \
      --replace "/config" "/var/lib/frigate" \
      --replace "{CONFIG_DIR}/model_cache" "/var/cache/frigate/model_cache"

    substituteInPlace frigate/http.py \
      --replace "/opt/frigate" "${placeholder "out"}/${python.sitePackages}"

    substituteInPlace frigate/output.py \
      --replace "/opt/frigate" "${placeholder "out"}/${python.sitePackages}"

    substituteInPlace frigate/detectors/detector_config.py \
      --replace "/labelmap.txt" "${placeholder "out"}/share/frigate/labelmap.txt"

    substituteInPlace frigate/config.py \
      --replace "/cpu_model.tflite" "${tflite_cpu_model}" \
      --replace "/edgetpu_model.tflite" "${tflite_edgetpu_model}"

    substituteInPlace frigate/test/test_config.py \
      --replace "(MODEL_CACHE_DIR" "('/build/model_cache'" \
      --replace "/config/model_cache" "/build/model_cache"
  '';

  dontBuild = true;

  propagatedBuildInputs = with python.pkgs; [
    # docker/main/requirements.txt
    scikit-build
    # docker/main/requirements-wheel.txt
    click
    flask
    imutils
    markupsafe
    matplotlib
    norfair
    numpy
    onvif-zeep
    opencv4
    openvino
    paho-mqtt
    peewee
    peewee-migrate
    psutil
    py3nvml
    pydantic
    pytz
    pyyaml
    requests
    ruamel-yaml
    scipy
    setproctitle
    tensorflow
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
