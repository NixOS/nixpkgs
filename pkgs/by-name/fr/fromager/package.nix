{
  lib,
  python3,
  fetchFromGitHub,
  writableTmpDirAsHomeHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fromager";
  version = "0.68.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-wheel-build";
    repo = "fromager";
    tag = version;
    hash = "sha256-7NM8hRsMnnHWxzjwNv/cLIm9iOUsUEzoCwPuFUN8+hk=";
  };

  build-system = with python3.pkgs; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3.pkgs; [
    click
    elfdeps
    html5lib
    packaging
    pkginfo
    psutil
    pydantic
    pyproject-hooks
    pyyaml
    requests
    requests-mock
    resolvelib
    rich
    setuptools
    stevedore
    tomlkit
    tqdm
    uv
    wheel
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
    twine
    uv
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [
    "fromager"
  ];

  disabledTestPaths = [
    # Depends on wheel.cli module that is private since wheel 0.46.0
    "tests/test_wheels.py"
  ];

  disabledTests = [
    # Accessing pypi.org (not allowed in sandbox)
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
}
