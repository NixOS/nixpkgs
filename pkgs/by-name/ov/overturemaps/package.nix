{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "overturemaps";
  version = "0.15.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XzD+G8ER6AbmJJpX5vq235K4DAh/h5OWWHtum5sV9MY=";
  };

  build-system = with python3Packages; [ poetry-core ];

  dependencies = with python3Packages; [
    click
    pyarrow
    shapely
  ];

  meta = {
    description = "Official command-line tool of the Overture Maps Foundation";
    homepage = "https://overturemaps.org/";
    mainProgram = "overturemaps";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crimeminister ];
  };
}
