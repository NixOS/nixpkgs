{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "poethepoet";
  version = "0.28.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nat-n";
    repo = "poethepoet";
    rev = "refs/tags/v${version}";
    hash = "sha256-um17UHFLX7zLQXLWbYnEnaLUwMgFSxdGt85fjMBEhjQ=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pastel
    tomli
  ];

  optional-dependencies = with python3.pkgs; {
    poetry_plugin = [
      poetry
    ];
  };

  pythonImportsCheck = [ "poethepoet" ];

  meta = with lib; {
    description = "Task runner that works well with poetry";
    homepage = "https://github.com/nat-n/poethepoet";
    changelog = "https://github.com/nat-n/poethepoet/releases/tag/${lib.removePrefix "refs/tags/" src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "poe";
  };
}
