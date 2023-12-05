{ lib
, callPackage
, python3
, fetchFromGitHub
, fetchurl
, fetchpatch
, frigate
, nixosTests
}:

let
  version = "0.12.1";

  src = fetchFromGitHub {
    #name = "frigate-${version}-source";
    owner = "blakeblackshear";
    repo = "frigate";
    rev = "refs/tags/v${version}";
    hash = "sha256-kNvYsHoObi6b9KT/LYhTGK4uJ/uAHnYhyoQkiXIA/s8=";
  };

  frigate-web = callPackage ./web.nix {
    inherit version src;
  };

  python = python3.override {
    packageOverrides = self: super: {
    };
  };

  # Tensorflow Lite models
  # https://github.com/blakeblackshear/frigate/blob/v0.12.0/Dockerfile#L88-L91
  tflite_cpu_model = fetchurl {
    url = "https://github.com/google-coral/test_data/raw/release-frogfish/ssdlite_mobiledet_coco_qat_postprocess.tflite";
    hash = "sha256-kLszpjTgQZFMwYGapd+ZgY5sOWxNLblSwP16nP/Eck8=";
  };
  tflite_edgetpu_model = fetchurl {
    url = "https://github.com/google-coral/test_data/raw/release-frogfish/ssdlite_mobiledet_coco_qat_postprocess_edgetpu.tflite";
    hash = "sha256-Siviu7YU5XbVbcuRT6UnUr8PE0EVEnENNV2X+qGzVkE=";
  };

  # OpenVino models
  # https://github.com/blakeblackshear/frigate/blob/v0.12.0/Dockerfile#L92-L95
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
    (fetchpatch {
      # numpy 1.24 compat
      url = "https://github.com/blakeblackshear/frigate/commit/cb73d0cd392990448811c7212bc5f09be411fc69.patch";
      hash = "sha256-Spt7eRosmTN8zyJ2uVme5HPVy2TKgBtvbQ6tp6PaNac=";
    })
  ];

  postPatch = ''
    echo 'VERSION = "${version}"' > frigate/version.py

    substituteInPlace frigate/app.py \
      --replace "Router(migrate_db)" 'Router(migrate_db, "${placeholder "out"}/share/frigate/migrations")'

    substituteInPlace frigate/const.py \
      --replace "/media/frigate" "/var/lib/frigate" \
      --replace "/tmp/cache" "/var/cache/frigate/"

    substituteInPlace frigate/http.py \
      --replace "/opt/frigate" "${placeholder "out"}/${python.sitePackages}" \
      --replace "/tmp/cache/" "/var/cache/frigate/"

    substituteInPlace frigate/output.py \
      --replace "/opt/frigate" "${placeholder "out"}/${python.sitePackages}"

    substituteInPlace frigate/record.py \
      --replace "/tmp/cache" "/var/cache/frigate"

    substituteInPlace frigate/detectors/detector_config.py \
      --replace "/labelmap.txt" "${placeholder "out"}/share/frigate/labelmap.txt"

    substituteInPlace frigate/detectors/plugins/edgetpu_tfl.py \
      --replace "/edgetpu_model.tflite" "${tflite_edgetpu_model}"

    substituteInPlace frigate/detectors/plugins/cpu_tfl.py \
      --replace "/cpu_model.tflite" "${tflite_cpu_model}"

    substituteInPlace frigate/ffmpeg_presets.py --replace \
       '"-timeout" if os.path.exists(BTBN_PATH) else "-stimeout"' \
       '"-timeout"'
  '';

  dontBuild = true;

  propagatedBuildInputs = with python.pkgs; [
    # requirements.txt
    scikit-build
    # requirements-wheel.txt
    click
    flask
    imutils
    matplotlib
    numpy
    opencv4
    openvino
    paho-mqtt
    peewee
    peewee-migrate
    psutil
    pydantic
    pyyaml
    requests
    scipy
    setproctitle
    tensorflow
    tzlocal
    ws4py
    zeroconf
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

  checkInputs = with python.pkgs; [
    pytestCheckHook
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
