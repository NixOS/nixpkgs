{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage rec {
  pname = "overturemaps";
  version = "0.18.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-D2WAeuwT0ujr30YiWlMuIM3oFohTrOBKdSlW6AL9BrA=";
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
