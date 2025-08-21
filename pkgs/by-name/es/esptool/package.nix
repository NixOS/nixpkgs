{
  lib,
  fetchFromGitHub,
  python3Packages,
  softhsm,
}:

python3Packages.buildPythonApplication rec {
  pname = "esptool";
  version = "5.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    tag = "v${version}";
    hash = "sha256-oRvtEBp88tmgjjIuoQS5ySm4I0aD/Zs8VLRUZo0sh/I=";
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
    bitstring
    click
    cryptography
    intelhex
    pyserial
    pyyaml
    reedsolo
    rich-click
  ];

  optional-dependencies = with python3Packages; {
    hsm = [ python-pkcs11 ];
  };

  postInstall = ''
    rm -v $out/bin/*.py
  '';

  nativeCheckInputs =
    with python3Packages;
    [
      pyelftools
      pytestCheckHook
      requests
      softhsm
    ]
    ++ lib.flatten (lib.attrValues optional-dependencies);

  preCheck = ''
    export PATH="$out/bin:$PATH"
  '';

  pytestFlags = [
    "-m"
    "host_test"
  ];

  disabledTests = [
    # remove the deprecated .py entrypoints, because our wrapper tries to
    # import esptool and finds esptool.py in $out/bin, which breaks.
    "test_esptool_py"
    "test_espefuse_py"
    "test_espsecure_py"
    "test_esp_rfc2217_server_py"
  ];

  postCheck = ''
    export SOFTHSM2_CONF=$(mktemp)
    echo "directories.tokendir = $(mktemp -d)" > "$SOFTHSM2_CONF"
    ./ci/setup_softhsm2.sh

    pytest test/test_espsecure_hsm.py
  '';

  meta = {
    changelog = "https://github.com/espressif/esptool/blob/${src.tag}/CHANGELOG.md";
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = "https://github.com/espressif/esptool";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      dezgeg
      dotlambda
    ];
    teams = [ lib.teams.lumiguide ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "esptool";
  };
}
