{
  lib,
  buildPythonPackage,
  cmdline,
  importlib-metadata,
  mock,
  pytestCheckHook,
  pytest,
  pytest-fixture-config,
  pytest-shutil,
  setuptools,
  virtualenv,
}:

buildPythonPackage {
  pname = "pytest-virtualenv";
  inherit (pytest-fixture-config) version src patches;
  pyproject = true;

  postPatch = ''
    cd pytest-virtualenv
  '';

  build-system = [ setuptools ];

  buildInputs = [ pytest ];

  dependencies = [
    importlib-metadata
    pytest-fixture-config
    pytest-shutil
    virtualenv
  ];

  nativeCheckInputs = [
    cmdline
    mock
    pytestCheckHook
  ];

  # Don't run integration tests
  disabledTestPaths = [ "tests/integration/*" ];

  meta = with lib; {
    description = "Create a Python virtual environment in your test that cleans up on teardown. The fixture has utility methods to install packages and list what’s installed";
    homepage = "https://github.com/manahl/pytest-plugins";
    license = licenses.mit;
    maintainers = with maintainers; [ ryansydnor ];
  };
}
