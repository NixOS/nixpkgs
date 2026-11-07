{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  aiohttp,
  pytest,
  pytestCheckHook,
  pytest-mock,
  pytest-asyncio,
}:

buildPythonPackage rec {
  pname = "pyytlounge";
  version = "3.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "FabioGNR";
    repo = "pyytlounge";
    tag = "v${version}";
    hash = "sha256-8cdahP1u8Rf4m/167ie9aKcELLiWNvZOx7tV9YLK4nU=";
  };

  build-system = [ hatchling ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest
    pytestCheckHook
    pytest-mock
    pytest-asyncio
  ];

  meta = {
    description = "Python YouTube Lounge API";
    homepage = "https://github.com/FabioGNR/pyytlounge";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.lukegb ];
  };
}
