{
  lib,
  python3,
  fetchFromGitHub,
  postgresql,
  postgresqlTestHook,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "migra";
  version = "3.0.1647431138";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "djrobstep";
    repo = pname;
    rev = version;
    hash = "sha256-LSCJA5Ym1LuV3EZl6gnl9jTHGc8A1LXmR1fj0ZZc+po=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    schemainspect
    six
    sqlbag
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    postgresql
    postgresqlTestHook
  ];
  preCheck = ''
    export PGUSER="nixbld";
  '';
  disabledTests = [
    # These all fail with "List argument must consist only of tuples or dictionaries":
    # See this issue: https://github.com/djrobstep/migra/issues/232
    "test_excludeschema"
    "test_fixtures"
    "test_rls"
    "test_singleschema"
  ];

  pytestFlagsArray = [
    "-x"
    "-svv"
    "tests"
  ];

  meta = with lib; {
    description = "Like diff but for PostgreSQL schemas";
    homepage = "https://github.com/djrobstep/migra";
    license = with licenses; [ unlicense ];
    maintainers = with maintainers; [ soispha ];
  };
}
