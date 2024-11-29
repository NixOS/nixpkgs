{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  jinja2,
  pdoc-pyo3-sample-library,
  pygments,
  markupsafe,
  pytestCheckHook,
  hypothesis,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "pdoc";
  version = "15.0.0";
  disabled = pythonOlder "3.9";

  pyproject = true;

  src = fetchFromGitHub {
    owner = "mitmproxy";
    repo = "pdoc";
    rev = "v${version}";
    hash = "sha256-6XEcHhaKkxY/FU748f+OsTcSgrM4iQTmJAL8rJ3EqnY=";
  };

  nativeBuildInputs = [ setuptools ];

  dependencies = [
    jinja2
    pygments
    markupsafe
  ];

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
    pdoc-pyo3-sample-library
  ];
  disabledTestPaths = [
    # "test_snapshots" tries to match generated output against stored snapshots,
    # which are highly sensitive to dep versions.
    "test/test_snapshot.py"
  ];

  pytestFlagsArray = [
    ''-m "not slow"'' # skip slow tests
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "pdoc" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    changelog = "https://github.com/mitmproxy/pdoc/blob/${src.rev}/CHANGELOG.md";
    homepage = "https://pdoc.dev/";
    description = "API Documentation for Python Projects";
    mainProgram = "pdoc";
    license = licenses.unlicense;
    maintainers = with maintainers; [ pbsds ];
  };
}
