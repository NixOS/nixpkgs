{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  pytest-aiohttp,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "rtsp-to-webrtc";
  version = "0.6.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "allenporter";
    repo = "rtsp-to-webrtc-client";
    rev = "refs/tags/${version}";
    hash = "sha256-D022d2CDKtHTuvEGo8GkOGWHi5sV4g6UwNB9xS2xxIs=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [ "rtsp_to_webrtc" ];

  meta = with lib; {
    description = "Module for RTSPtoWeb and RTSPtoWebRTC";
    homepage = "https://github.com/allenporter/rtsp-to-webrtc-client";
    changelog = "https://github.com/allenporter/rtsp-to-webrtc-client/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
