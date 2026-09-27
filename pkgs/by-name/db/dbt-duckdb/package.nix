{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication rec {
  pname = "dbt-duckdb";
  version = "1.9.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "duckdb";
    repo = "dbt-duckdb";
    tag = version;
    hash = "sha256-zuSOM5Vfr89aVGDcVQtK1Y4c3hRcL8pRscnvpeP6jbU=";
  };

  build-system = [
    python3Packages.setuptools
    python3Packages.pbr
  ];

  pythonImportsCheck = [
    "dbt.adapters.duckdb"
  ];

  dependencies = with python3Packages; [
    dbt-common
    dbt-adapters
    duckdb
    dbt-core
  ];

  env.PBR_VERSION = version;

  meta = {
    description = "Dbt (http://getdbt.com) adapter for DuckDB (http://duckdb.org)";
    homepage = "https://github.com/duckdb/dbt-duckdb";
    changelog = "https://github.com/duckdb/dbt-duckdb/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ otheanalyst ];
    mainProgram = "dbt-duckdb";
  };
}
