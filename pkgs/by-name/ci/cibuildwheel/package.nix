{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  __structuredAttrs = true;
  pname = "cibuildwheel";
  version = "4.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = "cibuildwheel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-mGIAdLyt9iO7NQqns3O7yysS9Kv5+WnQoKKyi1NF2Ek=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    bashlex
    bracex
    build
    certifi
    dependency-groups
    filelock
    humanize
    packaging
    platformdirs
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    xdoctest
  ];
  checkInputs = with python3Packages; [
    build
    filelock
    jinja2
    pytest-timeout
    pytest-xdist
    pytest-rerunfailures
    setuptools
    tomli-w
    validate-pyproject
  ];
  # tests write to ~/.cache and TMPDIR is neatly cleaned up afterwards
  preCheck = "export HOME=$TMPDIR";
  # there's also a `tests` folder with integration tests
  # but we can't / don't want to run these from the build sandbox
  enabledTestPaths = [ "unit_test" ];
  disabledTestPaths = [ "unit_test/download_test.py" ];
  pythonImportsCheck = [ "cibuildwheel" ];

  meta = {
    description = "Build Python wheels for all the platforms with minimal configuration";
    homepage = "https://github.com/pypa/cibuildwheel";
    changelog = "https://github.com/pypa/cibuildwheel/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      jemand771
    ];
    mainProgram = "cibuildwheel";
  };
})
