{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "fetchtastic";
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jeremiah-k";
    repo = "fetchtastic";
    tag = finalAttrs.version;
    hash = "sha256-E8f0je4w4sTmf/EX9I8dZ4Ge4bsEvr8E6S5i02n5k+E=";
  };

  pythonRelaxDeps = [ "platformdirs" ];

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    packaging
    pick
    platformdirs
    pyyaml
    requests
    rich
    urllib3
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytest-cov-stub
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "fetchtastic" ];

  meta = {
    description = "Utility for downloading and managing the latest Meshtastic firmware releases";
    homepage = "https://github.com/jeremiah-k/fetchtastic";
    changelog = "https://github.com/jeremiah-k/fetchtastic/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "fetchtastic";
  };
})
