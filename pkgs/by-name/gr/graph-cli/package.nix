{ lib
, python3Packages
, fetchPypi
, qt5
}:

python3Packages.buildPythonApplication rec {
  pname = "graph-cli";
  version = "0.1.19";

  src = fetchPypi {
    inherit version;
    pname = "graph_cli";
    hash = "sha256-AOfUgeVgcTtuf5IuLYy1zFTBCjWZxu0OiZzUVXDIaSc=";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  propagatedBuildInputs = with python3Packages; [
    numpy
    pandas
    (matplotlib.override { enableQt = true; })
  ];

  # does not contain tests despite reference in Makefile
  doCheck = false;
  pythonImportsCheck = [ "graph_cli" ];

  meta = with lib; {
    description = "CLI to create graphs from CSV files";
    homepage = "https://github.com/mcastorina/graph-cli/";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ leungbk ];
    mainProgram = "graph";
  };
}
