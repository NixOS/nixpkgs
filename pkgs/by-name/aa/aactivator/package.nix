{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonApplication rec {
  pname = "aactivator";
  version = "2.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Yelp";
    repo = "aactivator";
    tag = "v${version}";
    hash = "sha256-vnBDtLEvU1jHbb5/MXAulXaBaugdCZdLQSP2b8P6SiQ=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    pexpect
  ];

  disabledTestPaths = [
    # presumably because of shell manipulations
    "tests/integration_test.py"
  ];

  meta = {
    description = "Automatically activate Python virtualenvs (and other environments)";
    homepage = "https://github.com/Yelp/aactivator";
    license = lib.licenses.mit;
    mainProgram = "aactivator";
    maintainers = with lib.maintainers; [ keller00 ];
  };
}
