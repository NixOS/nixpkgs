{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pysqlrecon";
  version = "0.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tw1sm";
    repo = "PySQLRecon";
    rev = "refs/tags/v${version}";
    hash = "sha256-v6IO5fQLvzJhpMPNaZ+ehmU4NYgRDfnDRwQYv5QVx00=";
  };

  pythonRelaxDeps = [
    "rich"
    "typer"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    rich
    typer
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pysqlrecon"
  ];

  meta = with lib; {
    description = "Offensive MSSQL toolkit";
    homepage = "https://github.com/Tw1sm/PySQLRecon";
    changelog = "https://github.com/Tw1sm/PySQLRecon/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pysqlrecon";
  };
}
