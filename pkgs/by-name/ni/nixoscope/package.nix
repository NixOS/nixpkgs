{
  fetchFromGitHub,
  lib,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "nixoscope";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "giomf";
    repo = "nixoscope";
    tag = "v${version}";
    hash = "sha256-9w5+KgC1daxGZ0BEVX75bKExpdnzik5pFnOPGHLDtiQ=";
  };

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    graphviz
  ];

  meta = {
    description = "Visualize dependencies between NixOS modules";
    homepage = "https://github.com/giomf/NixoScope";
    license = with lib.licenses; [
      mit
    ];
    maintainers = with lib.maintainers; [
      giomf
    ];
    mainProgram = "nixoscope";
  };
}
