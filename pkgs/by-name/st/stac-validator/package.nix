{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "stac-validator";
  version = "3.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "stac-utils";
    repo = "stac-validator";
    tag = "v${version}";
    hash = "sha256-5wcnEdk8+/stdJVQ97Me/+H3GrS7DA+Nd0OQtPEXDl4=";
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
