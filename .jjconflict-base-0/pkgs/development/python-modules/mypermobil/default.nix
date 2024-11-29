{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiocache,
  aiohttp,
  aiounittest,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mypermobil";
  version = "0.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Permobil-Software";
    repo = "mypermobil";
    rev = "refs/tags/v${version}";
    hash = "sha256-linnaRyA45EzqeSeNmvIE5gXkHA2F504U1++QBeRa90=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiocache
    aiohttp
  ];

  pythonImportsCheck = [ "mypermobil" ];

  nativeCheckInputs = [
    aiounittest
    pytestCheckHook
  ];

  disabledTests = [
    # requires networking
    "test_region"
  ];

  meta = {
    changelog = "https://github.com/Permobil-Software/mypermobil/releases/tag/v${version}";
    description = "Python wrapper for the MyPermobil API";
    homepage = "https://github.com/Permobil-Software/mypermobil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
