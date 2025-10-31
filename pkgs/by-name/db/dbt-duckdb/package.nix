{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "dbt-duckdb";
  version = "1.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "duckdb";
    repo = "dbt-duckdb";
    rev = version;
    hash = "sha256-zuSOM5Vfr89aVGDcVQtK1Y4c3hRcL8pRscnvpeP6jbU=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.wheel
  ];

  pythonImportsCheck = [
    "dbt_duckdb"
  ];

  meta = {
    description = "Dbt (http://getdbt.com) adapter for DuckDB (http://duckdb.org";
    homepage = "https://github.com/duckdb/dbt-duckdb";
    changelog = "https://github.com/duckdb/dbt-duckdb/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "dbt-duckdb";
  };
}
