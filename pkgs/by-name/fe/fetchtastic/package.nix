{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "fetchtastic";
  version = "0.11.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeremiah-k";
    repo = "fetchtastic";
    tag = finalAttrs.version;
    hash = "sha256-D/qCqjgG3weVV2hBnOTEmtlsmhHo869/FeeX/zG+mV4=";
  };

  pythonRelaxDeps = [ "platformdirs" ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    aiofiles
    aiohttp
    packaging
    pick
    platformdirs
    pyyaml
    requests
    rich
    urllib3
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-asyncio
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fetchtastic" ];

  disabledTests = [
    "test_cli_cold_import_in_fresh_interpreter"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_download_firmware_success"
    "test_get_target_path_for_release"
    "test_platform_functions"
  ];

  disabledTestPaths = [
    # Tests requires bash, pip, uv, etc.
    "tests/test_install_scripts.py"
  ];

  meta = {
    description = "Utility for downloading and managing the latest Meshtastic firmware releases";
    homepage = "https://github.com/jeremiah-k/fetchtastic";
    changelog = "https://github.com/jeremiah-k/fetchtastic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "fetchtastic";
  };
})
