{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,
  mashumaro,
  orjson,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  syrupy,
}:

buildPythonPackage rec {
  pname = "webrtc-models";
  version = "0.2.0";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "python-webrtc-models";
    rev = "refs/tags/${version}";
    hash = "sha256-6fVcp9kWr5nV4wOKov3ObqyPJo+u3jN443qv++sJ0TQ=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  pythonRelaxDeps = [ "orjson" ];

  build-system = [ hatchling ];

  dependencies = [
    mashumaro
    orjson
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
    syrupy
  ];

  pythonImportsCheck = [ "webrtc_models" ];

  meta = {
    description = "WebRTC models as Python dataclasses with mashumaro";
    homepage = "https://github.com/home-assistant-libs/python-webrtc-models";
    changelog = "https://github.com/home-assistant-libs/python-webrtc-models/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
