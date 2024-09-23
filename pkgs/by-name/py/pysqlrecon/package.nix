{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "pysqlrecon";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Tw1sm";
    repo = "PySQLRecon";
    rev = "refs/tags/v${version}";
    hash = "sha256-+pme4uOgsh6iZEL73PaR1Y55r+Z/SPEVD2QWBsnMsNs=";
  };

  pythonRelaxDeps = [
    "impacket"
    "rich"
    "typer"
  ];

  nativeBuildInputs = with python3.pkgs; [ poetry-core ];

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    pycryptodome
    rich
    typer
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pysqlrecon" ];

  meta = with lib; {
    description = "Offensive MSSQL toolkit";
    homepage = "https://github.com/Tw1sm/PySQLRecon";
    changelog = "https://github.com/Tw1sm/PySQLRecon/blob/${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
    mainProgram = "pysqlrecon";
  };
}
