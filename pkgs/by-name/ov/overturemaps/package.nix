{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonPackage (finalAttrs: {
  pname = "overturemaps";
  version = "2.1.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-yM2vMwJx40j3Bmb+X94UqfFSA3tZcT4fw1WrSbQknZo=";
  };

  nativeBuildInputs = with python3Packages; [
    hatchling
  ];

  dependencies = with python3Packages; [
    click
    colorama
    numpy
    orjson
    pyarrow
    pyfiglet
    shapely
    tqdm
  ];

  optional-dependencies = with python3Packages; {
    geopandas = [
      geopandas
    ];
  };

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

  nativeCheckInputs =
    with python3Packages;
    [
      pytest-mock
      pytestCheckHook
    ]
    ++ finalAttrs.passthru.optional-dependencies.geopandas;

  meta = {
    description = "Official command-line tool of the Overture Maps Foundation";
    homepage = "https://overturemaps.org/";
    mainProgram = "overturemaps";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ crimeminister ];
  };
})
