{
  python3Packages,
  lib,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "brei";
  version = "0.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "entangled";
    repo = "brei";
    tag = "v${version}";
    hash = "sha256-6AwveNt+HUc/lRjKhdoxGLee8AqzIUePHfEK46nLuJY=";
  };

  build-system = [ python3Packages.poetry-core ];

  pythonRelaxDeps = [ "argh" ];

  dependencies = with python3Packages; [
    rich
    rich-argparse
    argh
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    hypothesis
    pytest-asyncio
  ];

  meta = src.meta // {
    description = "Minimal workflow system and alternative to Make";
    maintainers = with lib.maintainers; [ mgttlinger ];
    platforms = python3Packages.python.meta.platforms;
    license = lib.licenses.asl20;
    mainProgram = "brei";
  };
}
