{
  lib,
  fetchFromGitHub,
  gitMinimal,
  python3Packages,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "fromager";
  version = "0.103.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-wheel-build";
    repo = "fromager";
    tag = finalAttrs.version;
    hash = "sha256-0errYzOdvjMDiSU9XF2n6fVIBheH3YIafihEyifJ4Ao=";
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
    gitMinimal
    pytestCheckHook
    pytest-socket
    pytest-xdist
    requests-mock
    spdx-tools
    twine
    uv
    writableTmpDirAsHomeHook
  ];

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
