{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opshin";
  version = "0.21.2";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "opshin";
    rev = version;
    hash = "sha256-YBdYF04iKUwIZncqyEDalU+YN6/qwlx/vQDzZ19GaPU=";
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
