{
  lib,
  aiohttp,
  aresponses,
  awesomeversion,
  backoff,
  buildPythonPackage,
  cachetools,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  yarl,
}:

buildPythonPackage rec {
  pname = "python-technove";
  version = "2.0.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Moustachauve";
    repo = "pytechnove";
    tag = "v${version}";
    hash = "sha256-LgrydBgx68HP8yaywkMMeS71VqhilYGODppBZbdkssQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    awesomeversion
    backoff
    cachetools
    yarl
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "technove" ];

  meta = with lib; {
    description = "Python library to interact with TechnoVE local device API";
    homepage = "https://github.com/Moustachauve/pytechnove";
    changelog = "https://github.com/Moustachauve/pytechnove/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
