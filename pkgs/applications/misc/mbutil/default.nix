{
  lib,
  buildPythonApplication,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonApplication rec {
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

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];
  enabledTestPaths = [ "test/test.py" ];

  meta = {
    description = "Importer and exporter for MBTiles";
    mainProgram = "mb-util";
    homepage = "https://github.com/mapbox/mbutil";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ sikmir ];
  };
}
