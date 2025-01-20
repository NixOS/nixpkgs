{
  python3Packages,
  lib,
  pkgs,
  fetchFromGitHub,
}:
let
  argh_0_30_5 = python3Packages.argh.overridePythonAttrs (old: rec {
    version = "0.30.5";
    src = python3Packages.fetchPypi {
      pname = "argh";
      inherit version;
      hash = "sha256-s339YXoJ0ZpKe8rtDgYLKIvHrI39wPrPiGpJol/zNyg=";
    };
  });
in
python3Packages.buildPythonApplication rec {
  pname = "brei";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "entangled";
    repo = "brei";
    rev = "v${version}";
    sha256 = "sha256-UbxCgouK+qiELmsiUZDNO6untyzxM8mOVocvhN8g4+Q=";
  };

  pyproject = true;

  nativeBuildInputs = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    rich
    rich-argparse
    argh_0_30_5
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
