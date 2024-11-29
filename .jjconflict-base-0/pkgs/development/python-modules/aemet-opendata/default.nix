{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  geopy,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aemet-opendata";
  version = "0.6.3";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "AEMET-OpenData";
    rev = "refs/tags/${version}";
    hash = "sha256-fGl3nHU2MlSKFWh4lkpXWad7ivMhxkIsbODcZOemYaQ=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    geopy
  ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "aemet_opendata.interface" ];

  meta = with lib; {
    description = "Python client for AEMET OpenData Rest API";
    homepage = "https://github.com/Noltari/AEMET-OpenData";
    changelog = "https://github.com/Noltari/AEMET-OpenData/releases/tag/${version}";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ dotlambda ];
  };
}
