{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "circup";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "circup";
    tag = finalAttrs.version;
    hash = "sha256-vxgMdH9Tz1VOA3ccey5/arw3zeqvgCJJu7IlVoi1OIQ=";
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
    "test_install_auto_file_bad"
  ];

  meta = {
    description = "CircuitPython library updater";
    homepage = "https://github.com/adafruit/circup";
    changelog = "https://github.com/adafruit/circup/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "circup";
  };
})
