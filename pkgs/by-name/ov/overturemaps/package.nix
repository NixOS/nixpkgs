{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "overturemaps";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yKl13Y9kRCGHzoqeZIQEac/PrByTCtCQFaz8sUgeVIs=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    colorama
    geopandas
    numpy
    orjson
    pyarrow
    pyfiglet
    shapely
    tqdm
  ];

  # Drop once tqdm 4.67.3 reaches master
  pythonRelaxDeps = [ "tqdm" ];

  pythonImportsCheck = [ "overturemaps" ];

  meta = {
    description = "Official command-line tool of the Overture Maps Foundation";
    homepage = "https://overturemaps.org/";
    mainProgram = "overturemaps";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crimeminister ];
  };
}
