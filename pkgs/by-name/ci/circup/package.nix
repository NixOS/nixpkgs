{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "circup";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "circup";
    tag = version;
    hash = "sha256-4jmqS/XMB8t7aMfHriipi+VnCbZqrqjt21K5ktes2ec=";
  };

  pythonRelaxDeps = [ "semver" ];

  build-system = with python3.pkgs; [ setuptools-scm ];

  dependencies = with python3.pkgs; [
    appdirs
    click
    findimports
    requests
    semver
    setuptools
    toml
    update-checker
  ];

  nativeCheckInputs = with python3.pkgs; [ pytestCheckHook ];

  postBuild = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [ "circup" ];

  disabledTests = [
    # Test requires network access
    "test_libraries_from_imports_bad"
  ];

  meta = with lib; {
    description = "CircuitPython library updater";
    homepage = "https://github.com/adafruit/circup";
    changelog = "https://github.com/adafruit/circup/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "circup";
  };
}
