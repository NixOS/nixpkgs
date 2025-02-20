{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "stac-validator";
  version = "3.5.0";
  pyproject = true;
  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "stac-utils";
    repo = "stac-validator";
    tag = "v${version}";
    hash = "sha256-/MConEN+fcY3JKqP/24k0l/m2FHNhIqG7k42ldSPZ1U=";
  };

  build-system = [ python3Packages.setuptools ];

  pythonRelaxDeps = [
    "click"
  ];

  dependencies = with python3Packages; [
    click
    jsonschema
    requests
  ];

  pythonImportsCheck = [ "stac_validator" ];

  meta = {
    description = "Validator for the SpatioTemporal Asset Catalog (STAC) specification";
    homepage = "https://github.com/stac-utils/stac-validator";
    license = lib.licenses.asl20;
    maintainers = lib.teams.geospatial.members;
  };
}
