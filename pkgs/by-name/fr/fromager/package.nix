{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fromager";
  version = "0.47.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-wheel-build";
    repo = "fromager";
    tag = version;
    hash = "sha256-Jw5fOhY4WOwYG5QPCcsT6+BicGtqz9UrHcpPsPQlOWc=";
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
