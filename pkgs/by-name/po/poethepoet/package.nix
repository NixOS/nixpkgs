{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "poethepoet";
  version = "0.27.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nat-n";
    repo = "poethepoet";
    rev = "refs/tags/v${version}";
    hash = "sha256-2AxNu4/tTTH5aW02ec83jxhLJoDKSogY/fm8PUm1cSg=";
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
    description = "Task runner that works well with poetry";
    homepage = "https://github.com/nat-n/poethepoet";
    changelog = "https://github.com/nat-n/poethepoet/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "poe";
  };
}
