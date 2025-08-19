{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "stac-validator";
  version = "3.10.1";
  pyproject = true;
  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "stac-utils";
    repo = "stac-validator";
    tag = "v${version}";
    hash = "sha256-tqguaptVRo6k6QALOOOL8dysMGDZx07eRJoHG24JirQ=";
  };

  build-system = [ python3Packages.setuptools ];

  pythonRelaxDeps = [
    "click"
  ];

  dependencies = with python3Packages; [
    click
    jsonschema
    pyyaml
    requests
  ];

  pythonImportsCheck = [ "stac_validator" ];

  meta = {
    description = "Validator for the SpatioTemporal Asset Catalog (STAC) specification";
    homepage = "https://github.com/stac-utils/stac-validator";
    license = lib.licenses.asl20;
    teams = [ lib.teams.geospatial ];
  };
}
