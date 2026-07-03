{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fortls";
  version = "3.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fortran-lang";
    repo = "fortls";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cUZBr+dtTFbd68z6ts4quIPp9XYMikUBrCq+icrZ1KU=";
  };

  build-system = [ python3Packages.setuptools-scm ];

  dependencies = with python3Packages; [
    json5
    packaging
  ];

  nativeCheckInputs = with python3Packages; [
    pytest-cov-stub
    pytest-xdist
    pytestCheckHook
    versionCheckHook
  ];

  disabledTests = [
    "test_hover"
    "test_version_update_pypi"
  ];

  disabledTestPaths = [
    "test/test_server.py"
    "test/test_server_completion.py"
    "test/test_server_definitions.py"
    "test/test_server_diagnostics.py"
    "test/test_server_documentation.py"
    "test/test_server_hover.py"
    "test/test_server_implementation.py"
    "test/test_server_init.py"
    "test/test_server_references.py"
    "test/test_server_rename.py"
    "test/test_server_signature_help.py"
  ];

  meta = {
    description = "Fortran Language Server";
    mainProgram = "fortls";
    homepage = "https://github.com/fortran-lang/fortls";
    license = [ lib.licenses.mit ];
    maintainers = [ lib.maintainers.sheepforce ];
  };
})
