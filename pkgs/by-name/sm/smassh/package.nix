{
  lib,
  fetchFromGitHub,
  smassh,
  python3,
  testers,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "smassh";
  version = "3.2.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "kraanzu";
    repo = "smassh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4w7mkZrm8m3MA18QLRRoRF022aaQP64iUGKUWsskqDk=";
  };

  nativeBuildInputs = with python3.pkgs; [ hatchling ];

  pythonRelaxDeps = [
    "platformdirs"
    "textual"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    click
    platformdirs
    requests
    textual
  ];

  # No tests available
  doCheck = false;

  passthru.tests.version = testers.testVersion {
    package = smassh;
    command = "HOME=$(mktemp -d) smassh --version";
    version = "smassh - v${finalAttrs.version}";
  };

  meta = {
    description = "TUI based typing test application inspired by MonkeyType";
    homepage = "https://github.com/kraanzu/smassh";
    changelog = "https://github.com/kraanzu/smassh/blob/main/CHANGELOG.md";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      aimpizza
      kraanzu
    ];
    mainProgram = "smassh";
  };
})
