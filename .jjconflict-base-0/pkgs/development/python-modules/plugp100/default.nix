{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  certifi,
  scapy,
  urllib3,
  semantic-version,
  aiohttp,
  jsons,
  requests,
  # Test inputs
  pytestCheckHook,
  pyyaml,
  pytest-asyncio,
  async-timeout,
}:

buildPythonPackage rec {
  pname = "plugp100";
  version = "5.1.4";

  src = fetchFromGitHub {
    owner = "petretiandrea";
    repo = "plugp100";
    tag = version;
    sha256 = "sha256-a/Rv5imVJOJNaLzPozK8+XMZZsR5HyIXbCmq2Flkd+I=";
  };

  propagatedBuildInputs = [
    certifi
    jsons
    requests
    aiohttp
    semantic-version
    scapy
    urllib3
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    async-timeout
  ];

  disabledTestPaths = [
    "tests/integration/"
    "tests/unit/hub_child/"
    "tests/unit/test_plug_strip.py"
    "tests/unit/test_hub.py "
    "tests/unit/test_klap_protocol.py"
  ];

  meta = with lib; {
    description = "Python library to control Tapo Plug P100 devices";
    homepage = "https://github.com/petretiandrea/plugp100";
    license = licenses.gpl3;
    maintainers = with maintainers; [ pyle ];
  };
}
