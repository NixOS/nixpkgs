{
  lib,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fromager";
  version = "0.82.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-wheel-build";
    repo = "fromager";
    tag = finalAttrs.version;
    hash = "sha256-RlmbpnnwOWM5KLo4z1brdZnULGk3raGYassEqwWy0W0=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3Packages; [
    click
    elfdeps
    license-expression
    packaging
    packageurl-python
    psutil
    pydantic
    pypi-simple
    pyproject-hooks
    pyyaml
    requests
    resolvelib
    rich
    starlette
    stevedore
    tomlkit
    tqdm
    uv
    uvicorn
    wheel
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    requests-mock
    spdx-tools
    twine
    uv
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "fromager"
  ];

  # Upstream runs pytest with `--log-level DEBUG`, which this test suite
  # relies on for caplog assertions against INFO records.
  # Reported: https://github.com/python-wheel-build/fromager/issues/1092
  pytestFlags = [ "--log-level=DEBUG" ];

  disabledTests = [
    # Accessing pypi.org (not allowed in sandbox)
    # Fixed in: https://github.com/python-wheel-build/fromager/pull/1093
    "test_get_build_backend_dependencies"
    "test_get_build_sdist_dependencies"
  ];

  meta = {
    description = "Wheel maker";
    homepage = "https://pypi.org/project/fromager/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ booxter ];
    mainProgram = "fromager";
  };
})
