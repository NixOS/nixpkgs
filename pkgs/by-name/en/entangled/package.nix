{
  python3Packages,
  lib,
  brei,
  copier,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "entangled";
  version = "2.1.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "entangled";
    repo = "entangled.py";
    tag = "v${version}";
    hash = "sha256-QiRN0cvu6ru5EZLot+p/RRi8okRTmbEjh7sAw1FHUsI=";
  };

  build-system = [
    python3Packages.poetry-core
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

  meta = {
    description = "Literate programming tool using markdown";
    homepage = "https://entangled.github.io";
    maintainers = with lib.maintainers; [ mgttlinger ];
    platforms = python3Packages.python.meta.platforms;
    license = lib.licenses.asl20;
    mainProgram = "entangled";
  };
}
