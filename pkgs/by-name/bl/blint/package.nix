{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  nixosTests,
}:

python3Packages.buildPythonApplication rec {
  pname = "blint";
  version = "2.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "owasp-dep-scan";
    repo = "blint";
    tag = "v${version}";
    hash = "sha256-mGeC7+YzQWSlT3sW2la/f21fN8V+YoFd4fwj/PBPCMI=";
  };

  build-system = [
    python3Packages.poetry-core
  ];

  dependencies = with python3Packages; [
    pyyaml
    appdirs
    apsw
    ar
    custom-json-diff
    defusedxml
    email-validator
    lief
    oras
    orjson
    packageurl-python
    pydantic
    rich
    symbolic
  ];

  pythonRelaxDeps = [
    "apsw"
    "symbolic"
  ];

  pythonImportsCheck = [
    "blint"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pytest-cov-stub
  ];

  # only runs on windows and fails, obviously
  disabledTests = [
    "test_demangle"
  ];

  passthru.tests = { inherit (nixosTests) blint; };

  meta = {
    description = "Binary Linter to check the security properties, and capabilities in executables";
    homepage = "https://github.com/owasp-dep-scan/blint";
    changelog = "https://github.com/owasp-dep-scan/blint/releases/tag/v${version}";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ ethancedwards8 ];
    teams = with lib.teams; [ ngi ];
    mainProgram = "blint";
  };
}
