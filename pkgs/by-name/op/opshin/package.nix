{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opshin";
  version = "0.22.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "opshin";
    rev = version;
    hash = "sha256-ixA5D7Bm/tjYEFhqaJ4sKkCkqQZpDyrwfD/LgN6Y4Uo=";
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
