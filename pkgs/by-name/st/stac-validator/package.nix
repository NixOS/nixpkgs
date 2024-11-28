{
  lib,
  fetchFromGitHub,
  python3Packages,
}:

python3Packages.buildPythonPackage rec {
  pname = "stac-validator";
  version = "3.4.0";
  pyproject = true;
  disabled = python3Packages.pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "stac-utils";
    repo = "stac-validator";
    rev = "refs/tags/v${version}";
    hash = "sha256-e3v8WvVbZcxN91w+YNUmSILZ1nZ9Vy1UbEpCQkTMQpQ=";
  };

  build-system = [ python3Packages.setuptools ];

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
