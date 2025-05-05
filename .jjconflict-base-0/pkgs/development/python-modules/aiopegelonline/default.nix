{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiopegelonline";
  version = "0.1.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "mib1185";
    repo = "aiopegelonline";
    tag = "v${version}";
    hash = "sha256-kDz+q4Y6ImgXbY7OSC/PKXPtKdktixW+ee51xHMX9o4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==75.6.0" "setuptools"
  '';

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiopegelonline" ];

  meta = with lib; {
    description = "Library to retrieve data from PEGELONLINE";
    homepage = "https://github.com/mib1185/aiopegelonline";
    changelog = "https://github.com/mib1185/aiopegelonline/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
