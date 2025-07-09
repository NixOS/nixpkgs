{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "cibuildwheel";
  version = "3.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "pypa";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XnTfq3pDO61Bg82u4zgC9zlmpQ2OPz9nd5wsvRWdKLs=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    bashlex
    bracex
    certifi
    dependency-groups
    filelock
    packaging
    platformdirs
  ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];
  checkInputs = with python3Packages; [
    build
    filelock
    jinja2
    pytest-timeout
    pytest-xdist
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
    changelog = "https://github.com/pypa/cibuildwheel/releases/tag/v${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      jemand771
    ];
    mainProgram = "cibuildwheel";
  };
}
