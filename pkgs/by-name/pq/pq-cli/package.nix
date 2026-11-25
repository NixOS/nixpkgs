{
  lib,
  fetchFromGitHub,
  python3Packages,
  nix-update-script,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "pq-cli";
  version = "1.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rr-";
    repo = "pq-cli";
    tag = finalAttrs.version;
    hash = "sha256-6yqPhvqAlZVe1++YgKQA5CkCKKHbkbVNySyzyo1XBT4=";
  };

  build-system = with python3Packages; [ hatchling ];

  dependencies = with python3Packages; [
    xdg-base-dirs
    urwid
    urwid-readline
  ];

  pythonRelaxDeps = [
    "urwid"
    "urwid-readline"
  ];

  nativeCheckInputs = with python3Packages; [ pytestCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Progress Quest: the CLI edition";
    homepage = "https://github.com/rr-/pq-cli";
    changelog = "https://github.com/rr-/pq-cli/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ genga898 ];
    mainProgram = "pqcli";
  };
})
