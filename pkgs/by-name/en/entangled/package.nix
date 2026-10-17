{
  lib,
  python3Packages,
  fetchFromGitHub,
  git,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "entangled";
  version = "2.4.3";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "entangled";
    repo = "entangled.py";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ORUjjoxHRseupuB7K/BO8xBEgn3hTbkGuUp2VTP6PLs=";
  };

  build-system = [ python3Packages.hatchling ];

  dependencies = with python3Packages; [
    brei
    click
    copier
    filelock
    msgspec
    pyyaml
    repl-session
    rich
    rich-argparse
    rich-click
    tomlkit
    typeguard
    watchfiles
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    python3Packages.pytest-timeout
    git
  ];

  pythonRelaxDeps = [
    "rich"
    "tomlkit"
  ];

  meta = {
    description = "Python port of Entangled";
    homepage = "https://github.com/entangled/entangled.py";
    changelog = "https://github.com/entangled/entangled.py/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mjm ];
    mainProgram = "entangled";
  };
})
