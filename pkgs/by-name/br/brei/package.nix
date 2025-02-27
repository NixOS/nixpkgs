{
  python3Packages,
  lib,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "brei";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "entangled";
    repo = "brei";
    tag = "v${version}";
    hash = "sha256-UbxCgouK+qiELmsiUZDNO6untyzxM8mOVocvhN8g4+Q=";
  };

  build-system = [ python3Packages.poetry-core ];

  pythonRelaxDeps = [ "argh" ];

  dependencies = with python3Packages; [
    rich
    rich-argparse
    argh
  ];

  meta = {
    description = "Minimal workflow system and alternative to Make";
    homepage = "https://entangled.github.io/brei";
    maintainers = with lib.maintainers; [ mgttlinger ];
    platforms = python3Packages.python.meta.platforms;
    license = lib.licenses.asl20;
    mainProgram = "brei";
  };
}
