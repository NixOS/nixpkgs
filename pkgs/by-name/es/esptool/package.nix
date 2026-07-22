{
  lib,
  addBinToPathHook,
  fetchFromGitHub,
  python3Packages,
  softhsm,
  installShellFiles,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "esptool";
  version = "5.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "espressif";
    repo = "esptool";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oHQ6rkMnzvjtP/dg+tyc7Dw+D/WuWDqRwqePKBBnjCw=";
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

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = ''
    rm -v $out/bin/*.py
  ''
  +
    lib.strings.concatMapStrings
      (
        cmd:
        # Unfortunately, espsecure and espefuse do not run in cross-compilation
        lib.optionalString
          (
            python3Packages.stdenv.buildPlatform.canExecute python3Packages.stdenv.hostPlatform
            || cmd == "esptool"
          )
          ''
            installShellCompletion --cmd ${cmd} \
              --bash <(_${lib.toUpper cmd}_COMPLETE=bash_source $out/bin/${cmd}) \
              --zsh <(_${lib.toUpper cmd}_COMPLETE=zsh_source $out/bin/${cmd}) \
              --fish <(_${lib.toUpper cmd}_COMPLETE=fish_source $out/bin/${cmd})
          ''
      )
      [
        "esptool"
        "espsecure"
        "espefuse"
      ];

  nativeCheckInputs =
    with python3Packages;
    [
      addBinToPathHook
      pyelftools
      pytestCheckHook
      requests
      softhsm
    ]
    ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

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

  preCheck = ''
    export SOFTHSM2_CONF=$(mktemp)
    echo "directories.tokendir = $(mktemp -d)" > "$SOFTHSM2_CONF"
    ./ci/setup_softhsm2.sh
  '';

  meta = {
    changelog = "https://github.com/espressif/esptool/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "ESP8266 and ESP32 serial bootloader utility";
    homepage = "https://github.com/espressif/esptool";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      dotlambda
    ];
    platforms = with lib.platforms; linux ++ darwin;
    mainProgram = "esptool";
  };
})
