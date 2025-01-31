{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "circup";
  version = "2.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "circup";
    rev = "refs/tags/${version}";
    hash = "sha256-Iid6IwPoj7F9X6Yb0ESsuvD9/tZdRQyCceGOVt2R1qw=";
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
