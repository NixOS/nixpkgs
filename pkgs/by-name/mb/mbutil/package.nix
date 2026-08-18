{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication rec {
  pname = "mbutil";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "mbutil";
    tag = "v${version}";
    hash = "sha256-vxAF49NluEI/cZMUv1dlQBpUh1jfZ6KUVkYAmFAWphk=";
  };

  patches = [ ./migrate_to_pytest.patch ];

  build-system = [ python3Packages.setuptools ];

  nativeCheckInputs = [ python3Packages.pytestCheckHook ];
  enabledTestPaths = [ "test/test.py" ];
  disabledTests = [
    # sqlite3.OperationalError: database is locked
    "test_utf8grid_disk_to_mbtiles"
  ];

  meta = {
    description = "Importer and exporter for MBTiles";
    mainProgram = "mb-util";
    homepage = "https://github.com/mapbox/mbutil";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
