{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opshin";
  version = "0.23.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "opshin";
    rev = "refs/tags/${version}";
    hash = "sha256-H6tuSJYV9bAwXu/5Y8g6aFbbQFCpq2aqcmRaDq2cAEg=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    setuptools
    poetry-core
    uplc
    pluthon
    pycardano
    frozenlist2
    astunparse
    ordered-set
  ];

  pythonRelaxDeps = [
    "pluthon"
    "uplc"
  ];

  meta = with lib; {
    description = "Simple pythonic programming language for Smart Contracts on Cardano";
    homepage = "https://opshin.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "opshin";
  };
}
