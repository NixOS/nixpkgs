{
  lib,
  python3Packages,
  fetchPypi,
  qt5,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "graph-cli";
  version = "0.1.19";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "graph_cli";
    hash = "sha256-AOfUgeVgcTtuf5IuLYy1zFTBCjWZxu0OiZzUVXDIaSc=";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    numpy
    pandas
    (matplotlib.override { enableQt = true; })
  ];

  # does not contain tests despite reference in Makefile
  doCheck = false;
  pythonImportsCheck = [ "graph_cli" ];

  meta = {
    description = "CLI to create graphs from CSV files";
    homepage = "https://github.com/mcastorina/graph-cli/";
    license = with lib.licenses; [ gpl3Only ];
    maintainers = with lib.maintainers; [ leungbk ];
    mainProgram = "graph";
  };
})
