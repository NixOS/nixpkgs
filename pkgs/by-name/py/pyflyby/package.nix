{
  python3Packages,
  fetchFromGitHub,
  lib,
  pkg-config,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pyflyby";
  version = "1.11.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "pyflyby";
    tag = finalAttrs.version;
    hash = "sha256-Jv3QVLJV7Uio674DRcB1sbDHsUy0y/MG7dd+L1gmFSc=";
  };

  nativeBuildInputs = [
    pkg-config
  ];

  build-system = with python3Packages; [
    meson-python
    pybind11
    setuptools-scm
  ];

  dependencies = with python3Packages; [
    black
    prompt-toolkit
    platformdirs
  ];

  pythonImportsCheck = [ "pyflyby" ];

  nativeCheckInputs = with python3Packages; [
    beartype
    comm
    hypothesis
    ipython
    numpy
    pexpect
    pyte
    pytest-xdist
    pytestCheckHook
    requests
    writableTmpDirAsHomeHook
  ];

  preCheck = ''
    # conftest.py insists on importing pyflyby from the source tree, which
    # lacks the extension module that meson built into $out
    ln -s $out/${python3Packages.python.sitePackages}/pyflyby/_fast_iter_modules*.so lib/python/pyflyby/
    # the tests run `python $(which py)`, which needs the unwrapped Python script
    mkdir "$TMPDIR/bin"
    ln -s $out/bin/.py-wrapped "$TMPDIR/bin/py"
    export PATH="$TMPDIR/bin:$PATH"
  '';

  disabledTestPaths = [
    # expects ipython next to sys.executable, as in a virtualenv
    "tests/test_interactive.py"
  ];

  disabledTests = [
    # expects bin/py in the source tree
    "test_find_py_commandline"
    # replace PYTHONPATH, so the subprocess can't find pyflyby
    "test_collect_exports_module_1"
    "test_collect_exports_module_2"
    "test_tidy_imports_forward_references"
  ];

  meta = {
    description = "Set of productivity tools for Python";
    homepage = "https://github.com/deshaw/pyflyby";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ jfvillablanca ];
    mainProgram = "py";
  };
})
