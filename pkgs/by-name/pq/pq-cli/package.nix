{
  lib,
  fetchFromGitHub,
  python3Packages,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "pq-cli";
  version = "1.0.2-unstable-2025-04-04";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "pq-cli";
    rev = "e6d18352c5874364a7bbb65ad41a198838d907ed";
    hash = "sha256-gT9vxz4oAtoatG8dUDJbr60yyKhglFrxNe1SQMKilb8=";
  };

  build-system = with python3Packages; [
    setuptools
    poetry-core
  ];

  dependencies = with python3Packages; [
    xdg
    xdg-base-dirs
    urwid
    urwid-readline
  ];

  pythonRelaxDeps = [
    "urwid-readline"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Progress Quest: the CLI edition";
    homepage = "https://github.com/rr-/pq-cli";
    changelog = "https://github.com/rr-/pq-cli/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "pqcli";
  };
}
