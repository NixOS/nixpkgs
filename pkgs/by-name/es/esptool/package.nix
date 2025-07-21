{
  lib,
  fetchFromGitHub,
  python3Packages,
  softhsm,
}:

python3Packages.buildPythonApplication rec {
  pname = "esptool";
  version = "4.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    tag = "v${version}";
    hash = "sha256-iIFjInqiqjeqiDYL7BU3vT99pCVnu8OhU7u9uKwe/SI=";
  };

  postPatch = ''
    patchShebangs ci

    substituteInPlace test/test_espsecure_hsm.py \
      --replace-fail "/usr/lib/softhsm" "${lib.getLib softhsm}/lib/softhsm"
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    argcomplete
    bitstring
    cryptography
    ecdsa
    intelhex
    pyserial
    reedsolo
    pyyaml
  ];

  optional-dependencies = with python3Packages; {
    hsm = [ python-pkcs11 ];
  };

  nativeCheckInputs =
    with python3Packages;
    [
      pyelftools
      pytestCheckHook
      softhsm
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies);

  # tests mentioned in `.github/workflows/test_esptool.yml`
  checkPhase = ''
    runHook preCheck

    export SOFTHSM2_CONF=$(mktemp)
    echo "directories.tokendir = $(mktemp -d)" > "$SOFTHSM2_CONF"
    ./ci/setup_softhsm2.sh

    pytest test/test_imagegen.py
    pytest test/test_espsecure.py
    pytest test/test_espsecure_hsm.py
    pytest test/test_merge_bin.py
    pytest test/test_image_info.py
    pytest test/test_modules.py

    runHook postCheck
  '';

  meta = with lib; {
    changelog = "https://github.com/espressif/esptool/blob/${src.tag}/CHANGELOG.md";
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = "https://github.com/espressif/esptool";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [
      dezgeg
      dotlambda
    ];
    teams = [ lib.teams.lumiguide ];
    platforms = with platforms; linux ++ darwin;
    mainProgram = "esptool.py";
  };
}
