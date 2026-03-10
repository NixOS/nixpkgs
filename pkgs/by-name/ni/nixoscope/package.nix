{
  lib,
  fetchFromGitHub,
  python3Packages,
}:
python3Packages.buildPythonPackage {
  pname = "nixoscope";
  version = "0-unstable-2026-03-05";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "giomf";
    repo = "nixoscope";
    rev = "71de2ff0b4c9376db759a05ad58ace87d2b52ccb";
    hash = "sha256-5yNGtEWlSAfJcy4X8C3dHQ+4Xaawi6aX20C82bfZxG4=";
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
