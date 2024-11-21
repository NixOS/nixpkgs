{
  python3Packages,
  lib,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "afusion";
  version = "1.1.2";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Hanziwww";
    repo = "AlphaFold3-GUI";
    rev = "refs/tags/v${version}";
    hash = "sha256-SoZ9bJ/g3sLaPsXE3Yrq4E9qzj0TQ4o+wAh2OnmYSCw=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    streamlit
    pandas
    loguru
  ];
}
