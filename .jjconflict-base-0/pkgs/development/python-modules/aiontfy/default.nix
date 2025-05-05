{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-regex-commit,
  hatchling,
  lib,
  mashumaro,
  orjson,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "aiontfy";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "aiontfy";
    tag = "v${version}";
    hash = "sha256-WQb6sNjpQVgh+9vH7EyrmJHCWL0Mcmw4hHPHa8KsLYc=";
  };

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  dependencies = [
    aiohttp
    mashumaro
    orjson
  ];

  pythonImportsCheck = [ "aiontfy" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/tr4nt0r/aiontfy/releases/tag/${src.tag}";
    description = "Async ntfy client library";
    homepage = "https://github.com/tr4nt0r/aiontfy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
