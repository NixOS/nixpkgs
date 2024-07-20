{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "fastapi-cli";
  version = "0.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tiangolo";
    repo = "fastapi-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-eWvZn7ZeLnQZAvGOzY77o6oO5y+QV2cx+peBov9YpJE=";
  };

  build-system = [ python3.pkgs.pdm-backend ];

  dependencies = with python3.pkgs; [
    rich
    typer
  ];

  optional-dependencies = with python3.pkgs; {
    standard = [
      fastapi
      uvicorn
    ];
  };

  pythonImportsCheck = [ "fastapi_cli" ];

  meta = {
    description = "Run and manage FastAPI apps from the command line with FastAPI CLI";
    homepage = "https://github.com/tiangolo/fastapi-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "fastapi-cli";
  };
}
