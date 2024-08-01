{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pysqlrecon";
  version = "0.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tw1sm";
    repo = "PySQLRecon";
    rev = "refs/tags/v${version}";
    hash = "sha256-AJCvGpOjnh5ih5HrrpI+x0zyB7P6rMGL70707UunhEM=";
  };

  pythonRelaxDeps = [
    "rich"
    "typer"
  ];

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
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
