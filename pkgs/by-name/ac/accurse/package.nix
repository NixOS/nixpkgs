{
  lib,
  python3Packages,
  fetchFromGitHub,
  librsvg,
  xcursorgen,
}:

python3Packages.buildPythonApplication {
  pname = "accurse";
  version = "0.1.0-unstable-2025-07-03";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ATM-Jahid";
    repo = "accurse";
    rev = "0779b0309f1eef3d2aa541ba31390a11ccbeab9b";
    hash = "sha256-l6IxoH0WgmD1NuOJAe8EIfxTUbuAUnPXWHPB4bpL5Ec=";
  };

  build-system = [
    python3Packages.hatchling
  ];

  dependencies = [
    python3Packages.lxml
  ];

  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      librsvg
      xcursorgen
    ])
  ];

  meta = {
    description = "Atomsky's cursor package";
    homepage = "https://github.com/ATM-Jahid/accurse";
    license = lib.licenses.agpl3Only;
    mainProgram = "accurse";
    maintainers = with lib.maintainers; [ zwartemees ];
    platforms = lib.platforms.unix;
  };
}
