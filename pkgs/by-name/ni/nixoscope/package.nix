{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage {
  pname = "nixoscope";
  version = "0-unstable-2026-03-09";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "giomf";
    repo = "nixoscope";
    rev = "cd55aeb660deb823b17e6946e417fa14d966f8f7";
    hash = "sha256-cyEzO2UJaCWfecWZAVke2u/1guUO6Hl+YAbVL9pSgqU=";
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
