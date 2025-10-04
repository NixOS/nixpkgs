{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fromager";
  version = "0.59.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-wheel-build";
    repo = "fromager";
    tag = version;
    hash = "sha256-aKoZKpzgJ3e5JRYSSeLmLlji1Fj8omxvwGZfNXDOhLs=";
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
