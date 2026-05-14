{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "overturemaps";
  version = "0.20.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rvc1MpqCdRGuMWS5CSDev9SFgyVX8VczopXU/lWAyxg=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    geopandas
    numpy
    orjson
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
