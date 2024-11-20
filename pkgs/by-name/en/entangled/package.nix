{
  python3Packages,
  lib,
  brei,
  copier,
  fetchFromGitHub,
  git,
}:

python3Packages.buildPythonApplication rec {
  pname = "entangled";
  version = "2.1.12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "entangled";
    repo = "entangled.py";
    tag = "v${version}";
    hash = "sha256-1D/i2vv+VCay8Oz5R86q+7VrA9xt6lYeY0IJPwOyZrQ=";
  };

  build-system = with python3Packages; [
    uv-build
    hatchling
  ];

  pythonRelaxDeps = [
    "argh"
    "tomlkit"
    "watchdog"
  ];

  dependencies = with python3Packages; [
    rich
    rich-argparse
    argh
    brei
    filelock
    mawk
    pyyaml
    watchdog
    pexpect
    tomlkit
    copier
  ];

  nativeCheckInputs = [
    python3Packages.pytestCheckHook
    git
  ];

  meta = src.meta // {
    description = "Literate programming tool using markdown";
    homepage = "https://entangled.github.io";
    maintainers = with lib.maintainers; [ mgttlinger ];
    platforms = python3Packages.python.meta.platforms;
    license = lib.licenses.asl20;
    mainProgram = "entangled";
  };
}
