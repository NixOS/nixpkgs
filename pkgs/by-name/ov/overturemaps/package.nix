{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "overturemaps";
  version = "1.0.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
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

  pythonImportsCheck = [ "overturemaps" ];

  preCheck = ''
    substituteInPlace pytest.ini \
      --replace-fail "testpaths = tests benchmarks" "testpaths = tests"
  '';

  disabledTestPaths = [
    # requires network
    "tests/test_changelog.py"
    "tests/test_gers.py"
    "tests/test_releases.py"
  ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
  ];

  meta = {
    description = "Official command-line tool of the Overture Maps Foundation";
    homepage = "https://overturemaps.org/";
    mainProgram = "overturemaps";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crimeminister ];
  };
})
