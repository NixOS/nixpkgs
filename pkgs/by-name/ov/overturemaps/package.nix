{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "overturemaps";
  version = "0.19.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-y91x+S6YKBldy7OWIXCJQ5HuR3KrFRdfBkfMmkaeXy8=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    geopandas
    numpy
    pyarrow
    shapely
  ];

  pythonImportsCheck = [ "overturemaps" ];

  meta = {
    description = "Official command-line tool of the Overture Maps Foundation";
    homepage = "https://overturemaps.org/";
    mainProgram = "overturemaps";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crimeminister ];
  };
}
