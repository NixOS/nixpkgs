{ lib
, fetchFromGitHub
, smassh
, python3
, testers
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smassh";
  version = "3.1.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kraanzu";
    repo = "smassh";
    rev = "v${version}";
    hash = "sha256-QE7TFf/5hdd2W2EsVbn3gV/FundhJNxHqv0JWV5dYDc=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
    pythonRelaxDepsHook
  ];

  pythonRelaxDeps = [
    "textual"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    textual
    appdirs
    click
    requests
  ];

  # No tests available
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = smassh;
    command = "HOME=$(mktemp -d) smassh --version";
  };

  meta = with lib; {
    description = "A TUI based typing test application inspired by MonkeyType";
    homepage = "https://github.com/kraanzu/smassh";
    changelog = "https://github.com/kraanzu/smassh/blob/main/CHANGELOG.md";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ aimpizza ];
    mainProgram = "smassh";
  };
}
