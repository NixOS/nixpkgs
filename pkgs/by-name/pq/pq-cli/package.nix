{
  lib,
  fetchFromGitHub,
  python3Packages,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "pq-cli";
  version = "1.0.2-unstable-2025-04-10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "pq-cli";
    rev = "7790e52a6d3c0f6fbaf45f581f0fb98f78247af6";
    hash = "sha256-lRvjSOhEAur8dhrtpGb89BMD3o6/E1aJjyp+G4xZDnQ=";
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
