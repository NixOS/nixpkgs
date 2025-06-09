{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fromager";
  version = "0.46.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-wheel-build";
    repo = "fromager";
    tag = version;
    hash = "sha256-SBb5gWV8/t3oRAR2R5T72DW1LKrxXXH6yho9l7agsNI=";
  };

  build-system = with python3.pkgs; [
    setuptools
    setuptools-scm
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
    resolvelib
    rich
    setuptools
    stevedore
    tomlkit
    tqdm
    virtualenv
    wheel
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    requests-mock
    twine
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
}
