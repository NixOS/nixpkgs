{
  lib,
  fetchFromGitHub,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fromager";
  version = "0.101.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-wheel-build";
    repo = "fromager";
    tag = finalAttrs.version;
    hash = "sha256-3zDHBVwjPCwqGFuwXw6+l1tZH4aguoVuwh8O7HuZG2M=";
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
    pytest-xdist
    requests-mock
    spdx-tools
    twine
    uv
    writableTmpDirAsHomeHook
  ];

  # Some tests launch ignored background requests to placeholder URLs. Avoid
  # backoff retries: https://github.com/python-wheel-build/fromager/pull/1348
  env.FROMAGER_HTTP_RETRIES = 0;

  # Tests share repository directories and race during setup:
  # https://github.com/python-wheel-build/fromager/pull/1349
  dontUsePytestXdist = true;
  pytestFlags = [ "--numprocesses=0" ];

  pythonImportsCheck = [
    "fromager"
  ];

  meta = {
    description = "Wheel maker";
    homepage = "https://pypi.org/project/fromager/";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ booxter ];
    mainProgram = "fromager";
  };
})
