{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opshin";
  version = "0.24.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "opshin";
    tag = version;
    hash = "sha256-5IzPxzNvH9nlOYBCbc8kC7yzf8L8LPA5Wq9agqg9kng=";
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
