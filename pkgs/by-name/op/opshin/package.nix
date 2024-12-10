{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "opshin";
  version = "0.20.0";

  format = "pyproject";

  src = fetchFromGitHub {
    owner = "OpShin";
    repo = "opshin";
    rev = version;
    hash = "sha256-fJlPeVAuEf80FVxdXnaKASLmjMEgz6ysXenUY72+sos=";
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

  meta = with lib; {
    description = "A simple pythonic programming language for Smart Contracts on Cardano";
    homepage = "https://opshin.dev";
    license = licenses.mit;
    maintainers = with maintainers; [ t4ccer ];
    mainProgram = "opshin";
  };
}
