{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "circup";
  version = "3.2.1";
  pyproject = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "adafruit";
    repo = "circup";
    tag = finalAttrs.version;
    hash = "sha256-oe5I6Lgwjux5vzVWY4REuphDcZuVUCnOA/5wD08lesI=";
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

  nativeBuildInputs = [ writableTmpDirAsHomeHook ];

  pythonImportsCheck = [ "circup" ];

  disabledTests = [
    # Test requires network access
    "test_libraries_from_imports_bad"
    "test_install_auto_file_bad"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    "test_show_command"
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
