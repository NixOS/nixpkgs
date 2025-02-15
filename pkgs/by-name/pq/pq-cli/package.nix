{
  lib,
  fetchFromGitHub,
  python3Packages,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication rec {
  pname = "pq-cli";
  version = "1.0.2-unstable-2024-07-15";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "pq-cli";
    rev = "4122e936c87436552f35ff7972d6e543ba6c837b";
    hash = "sha256-PvHkTjPjOubhl9gfPTF7yNaFgg2GLk8y+PtF09fpaII=";
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
