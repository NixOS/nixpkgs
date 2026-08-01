{
  lib,
  fetchFromGitHub,
  python3Packages,
  unstableGitUpdater,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pq-cli";
  version = "1.0.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "pq-cli";
    tag = finalAttrs.version;
    hash = "sha256-QpHNN+rZwhZ45kY4/Czm0iJp/n6yx4ukcjSjpco5yKE=";
  };

  build-system = with python3Packages; [
    hatchling
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
    "urwid"
    "urwid-readline"
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Progress Quest: the CLI edition";
    homepage = "https://github.com/rr-/pq-cli";
    changelog = "https://github.com/rr-/pq-cli/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "pqcli";
  };
})
