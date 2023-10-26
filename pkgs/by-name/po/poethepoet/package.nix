{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "poethepoet";
  version = "0.24.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nat-n";
    repo = "poethepoet";
    rev = "v${version}";
    hash = "sha256-cIIMwQF0jqGQhNyX2qDBeKZlUNvdC6sBTv5LCxk8MMQ=";
  };

  nativeBuildInputs = [
    python3.pkgs.poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    pastel
    tomli
  ];

  passthru.optional-dependencies = with python3.pkgs; {
    poetry_plugin = [
      poetry
    ];
  };

  pythonImportsCheck = [ "poethepoet" ];

  meta = with lib; {
    description = "A task runner that works well with poetry";
    homepage = "https://github.com/nat-n/poethepoet";
    changelog = "https://github.com/nat-n/poethepoet/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "poe";
  };
}
